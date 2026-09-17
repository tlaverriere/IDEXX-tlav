<#
Streakly Anomaly Diagnosis Agent
Chained from metric-pulse.ps1: only runs when pulse's AnyAlert is true for a
metric. Takes that metric's before/after values plus its component drivers as
input -- it does not re-pull or re-derive them from the CSVs.

Steps 1, 2, 4 (timing) and 5 are deterministic gates, implemented here for
real. Step 3's hypothesis TEXT is documented judgment (see anomaly-diagnosis.md
Part 3) encoded as an explicit rule table below, not a formula that invents
business explanations -- the rule table is what a human or an LLM call would
be reasoning from in a real deployment.
#>

param(
    # --- what pulse handed off ---
    [string]$TriggerMetric = "Day-7 retention",
    [double]$CurrentValue  = 35,
    [double]$PreviousValue = 39,

    # --- decomposition drivers (this metric tree is Day-7's; a break-rate-triggered
    #     run would need its own tree -- not built here, see Boundaries) ---
    [double]$BreakRateCurrent  = 29,
    [double]$BreakRatePrevious = 22,
    [double]$SessionsWk1Current  = 3.2,
    [double]$SessionsWk1Previous = 4.1,
    [double]$PushOptinCurrent  = 51,
    [double]$PushOptinPrevious = 54,

    # --- corroborating context from pulse's channel breakdown, if any ---
    [string]$WatchChannel = "paid",
    [double]$WatchChannelDeltaPts = -4,

    # --- thresholds (documented in anomaly-diagnosis.md Part 2) ---
    [double]$AlertThresholdPts       = 2,
    [double]$BreakRateMeaningfulPts  = 3,
    [double]$SessionsMeaningfulPct   = 10,
    [double]$PushOptinMeaningfulPts  = 5,
    [double]$TopHypothesisConfidenceMin = 6,

    [string]$OutDir  = ".\slack-drafts",
    [string]$LogPath = ".\outcome-log.md"
)

$Timestamp = Get-Date -Format "ddd MMM d, h:mmtt"

function Write-Log {
    param([string]$Status, [string]$Body)
    $Entry = "`n## $Timestamp -- $Status`n`n$Body`n"
    Add-Content -Path $LogPath -Value $Entry -Encoding utf8
}

# ---------- Step 1: threshold check ----------
$TriggerDelta = [math]::Round($CurrentValue - $PreviousValue, 1)
$Step1Pass = [math]::Abs($TriggerDelta) -gt $AlertThresholdPts

Write-Output "Step 1 -- threshold check: $TriggerMetric moved $TriggerDelta pt (threshold $AlertThresholdPts pt)"
if (-not $Step1Pass) {
    Write-Output "STOP: move at or below threshold. Logged, no diagnostic run."
    Write-Log -Status "STOPPED at Step 1 (below threshold)" -Body "$TriggerMetric moved $TriggerDelta pt, at or below the $AlertThresholdPts pt gate. No decomposition run."
    exit 0
}
Write-Output "PASS -- continuing to decomposition."
Write-Output ""

# ---------- Step 2: metric tree decomposition ----------
$BreakDeltaPts    = [math]::Round($BreakRateCurrent - $BreakRatePrevious, 1)
$SessionsDeltaPct = [math]::Round((($SessionsWk1Current - $SessionsWk1Previous) / $SessionsWk1Previous) * 100, 1)
$PushDeltaPts     = [math]::Round($PushOptinCurrent - $PushOptinPrevious, 1)

$BreakMeaningful    = [math]::Abs($BreakDeltaPts)    -ge $BreakRateMeaningfulPts
$SessionsMeaningful = [math]::Abs($SessionsDeltaPct) -ge $SessionsMeaningfulPct
$PushMeaningful     = [math]::Abs($PushDeltaPts)     -ge $PushOptinMeaningfulPts

$MeaningfulCount = @($BreakMeaningful, $SessionsMeaningful, $PushMeaningful | Where-Object { $_ }).Count

Write-Output "Step 2 -- decomposition:"
Write-Output "  Streak-break rate:   $BreakRatePrevious% -> $BreakRateCurrent%  ($BreakDeltaPts pt)  meaningful=$BreakMeaningful (threshold $BreakRateMeaningfulPts pt)"
Write-Output "  Sessions in week 1:  $SessionsWk1Previous -> $SessionsWk1Current  ($SessionsDeltaPct%)  meaningful=$SessionsMeaningful (threshold $SessionsMeaningfulPct%)"
Write-Output "  Push opt-in rate:    $PushOptinPrevious% -> $PushOptinCurrent%  ($PushDeltaPts pt)  meaningful=$PushMeaningful (threshold $PushOptinMeaningfulPts pt)"
Write-Output "  Drivers meeting their meaningful-movement threshold: $MeaningfulCount"

if ($MeaningfulCount -lt 2) {
    Write-Output "STOP: fewer than 2 drivers moved meaningfully. Flagged inconclusive."
    Write-Log -Status "STOPPED at Step 2 (inconclusive)" -Body "$TriggerMetric moved $TriggerDelta pt but only $MeaningfulCount driver(s) crossed their meaningful-movement threshold. Decomposition does not localise a cause. Placeholder for what actually happened: [ ]"
    exit 0
}
Write-Output "PASS -- at least 2 drivers moved meaningfully, continuing to hypotheses."
Write-Output ""

# ---------- Step 3: hypothesis generation (rule table -- see Part 3) ----------
$Hypotheses = @()

if ($SessionsMeaningful -and ($PushDeltaPts -lt 0)) {
    $Hypotheses += [PSCustomObject]@{
        Rank = 0; Label = "Push notification delivery issue"
        Likelihood = "high"; Confidence = 8
        Reason = "Sessions in week 1 dropped $SessionsDeltaPct% and push opt-in moved the same direction ($PushDeltaPts pt) in the same window -- the standard signature of users not receiving the nudge rather than ignoring it."
    }
}
if ($WatchChannel -eq "paid" -and $WatchChannelDeltaPts -le -2) {
    $Hypotheses += [PSCustomObject]@{
        Rank = 0; Label = "New user cohort quality shift from paid channel"
        Likelihood = "medium"; Confidence = 5
        Reason = "Paid channel flagged by the pulse digest as down $WatchChannelDeltaPts pt last week -- corroborating context from outside this metric tree, not one of its three drivers."
    }
}
$Hypotheses += [PSCustomObject]@{
    Rank = 0; Label = "Streak-reset copy regression after last deploy"
    Likelihood = "low"; Confidence = 3
    Reason = "Mechanically plausible but no field in this decomposition confirms or rules it out on its own -- always included as the residual catch-all, capped low until it's checked directly against deploy timing."
}

# force an array even when only one hypothesis survives -- PowerShell unwraps
# a single-element pipeline result to a scalar, which silently breaks Count
# and the rank loop below (caught in testing: rank showed "0" with 1 survivor)
$Hypotheses = @($Hypotheses | Sort-Object -Property Confidence -Descending)
for ($i = 0; $i -lt $Hypotheses.Count; $i++) { $Hypotheses[$i].Rank = $i + 1 }

Write-Output "Step 3 -- ranked hypotheses:"
foreach ($H in $Hypotheses) {
    Write-Output "  $($H.Rank). $($H.Label) ($($H.Likelihood) likelihood, confidence $($H.Confidence)/10) -- $($H.Reason)"
}

$Top = $Hypotheses[0]
$Step3Pass = $Top.Confidence -gt $TopHypothesisConfidenceMin

if (-not $Step3Pass) {
    Write-Output "STOP: top hypothesis confidence $($Top.Confidence)/10 does not exceed $TopHypothesisConfidenceMin/10."
    $LowConfBody = @"
Trigger: $TriggerMetric moved $TriggerDelta pt ($PreviousValue% -> $CurrentValue%)
Top hypothesis: $($Top.Label) -- confidence $($Top.Confidence)/10 (needed > $TopHypothesisConfidenceMin/10)
No hypothesis cleared the confirmation bar. Posted as a low-confidence alert, not a diagnostic.
Placeholder for what actually happened: [ ]
"@
    Write-Log -Status "STOPPED at Step 3 (low confidence)" -Body $LowConfBody
    if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
    $LowConfMsg = "LOW-CONFIDENCE ALERT -- $Timestamp`n`nTrigger: $TriggerMetric moved $TriggerDelta pt ($PreviousValue% -> $CurrentValue%)`nTop hypothesis only reaches $($Top.Confidence)/10: $($Top.Label)`nNo SQL dispatched -- confidence bar not cleared. Needs a human look, not a query.`n"
    $LowConfMsg | Out-File -FilePath (Join-Path $OutDir "low-confidence-$($Timestamp -replace '[:, ]','-').txt") -Encoding utf8
    exit 0
}
Write-Output "PASS -- top hypothesis clears the confirmation bar, continuing to SQL + Slack draft."
Write-Output ""

# ---------- Step 4: SQL to confirm top hypothesis + Slack draft ----------
$Sql = @"
SELECT date, COUNT(*) as push_sent, SUM(delivered) as push_delivered,
       AVG(opened) as open_rate
FROM streakly_notifications
WHERE sent_date >= CURRENT_DATE - 7
GROUP BY date
ORDER BY date;
"@

$SlackBody = @"
Streakly Anomaly Detected, $Timestamp

Trigger: $TriggerMetric dropped $([math]::Abs($TriggerDelta))pts ($PreviousValue% -> $CurrentValue%) overnight

Metric tree decomposition:
Streak-break rate: $BreakRatePrevious% -> $BreakRateCurrent% ($BreakDeltaPts pt)
Sessions in week 1: $SessionsWk1Previous -> $SessionsWk1Current ($SessionsDeltaPct%)
Push opt-in rate: $PushOptinPrevious% -> $PushOptinCurrent% ($PushDeltaPts pt)

Top 3 hypotheses:
"@
foreach ($H in $Hypotheses) { $SlackBody += "`n$($H.Rank). $($H.Label) ($($H.Likelihood) likelihood, confidence $($H.Confidence)/10) -- $($H.Reason)" }
$SlackBody += @"


SQL to confirm hypothesis 1:

$Sql

Logged to outcome-log.md. Run this query and reply with the output. I'll interpret.
"@

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
$SlackFile = Join-Path $OutDir "anomaly-$($Timestamp -replace '[:, ]','-').txt"
$SlackBody | Out-File -FilePath $SlackFile -Encoding utf8

Write-Output "Step 4 -- SQL + Slack draft written to $SlackFile"
Write-Output "(No Slack connector authorized in this environment -- see anomaly-diagnosis.md header. This is the message that would post.)"
Write-Output ""

# ---------- Step 5: log the call ----------
$LogBody = @"
Trigger: $TriggerMetric moved $TriggerDelta pt ($PreviousValue% -> $CurrentValue%)
Ranked hypotheses:
"@
foreach ($H in $Hypotheses) { $LogBody += "`n  $($H.Rank). $($H.Label) -- confidence $($H.Confidence)/10 ($($H.Likelihood))" }
$LogBody += "`n`nWhat actually happened: [ ]"

Write-Log -Status "COMPLETED full loop -- diagnostic posted" -Body $LogBody
Write-Output "Step 5 -- logged to $LogPath with a placeholder for what actually happened."
