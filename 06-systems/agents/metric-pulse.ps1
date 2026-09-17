<#
Streakly Metric Pulse Agent
Reads data/users.csv + data/retention.csv, compares CurrentWeek to PreviousWeek
(overall and by acquisition_channel), and writes the Monday digest.

No live warehouse connection exists yet — this reads the local sample CSVs.
See ../metric-pulse.md Part 4 for how this maps onto a real data source.
#>

param(
    [string]$DataDir = "..\..\data",
    [string]$OutDir  = ".\digests",
    [int]$CurrentWeek  = 4,
    [int]$PreviousWeek = 3,
    [double]$Baseline  = 39.0,   # live Day-7 baseline per CLAUDE.md — not derivable from the sample CSVs
    [double]$AlertThresholdPts = 2.0
)

$UsersPath = Join-Path $DataDir "users.csv"
$RetPath   = Join-Path $DataDir "retention.csv"

$UsersRows = Import-Csv $UsersPath
$RetRows   = Import-Csv $RetPath

$UserChannel = @{}
foreach ($Row in $UsersRows) { $UserChannel[$Row.user_id] = $Row.acquisition_channel }

function Get-WeekStats {
    param([string]$Week)

    $Overall  = @{n=0; d7=0; brk=0}
    $ByChannel = @{
        organic  = @{n=0; d7=0; brk=0}
        paid     = @{n=0; d7=0; brk=0}
        referral = @{n=0; d7=0; brk=0}
    }

    foreach ($Row in $RetRows) {
        if ($Row.cohort_week -ne $Week) { continue }
        $Ch = $UserChannel[$Row.user_id]
        if (-not $Ch) { continue }

        $D7  = 0; if ($Row.day_7 -eq '1' -or $Row.day_7 -eq 'True' -or $Row.day_7 -eq 'true') { $D7 = 1 }
        $Brk = 0; if ($Row.broke_streak_week1 -eq '1' -or $Row.broke_streak_week1 -eq 'True' -or $Row.broke_streak_week1 -eq 'true') { $Brk = 1 }

        $Overall.n += 1; $Overall.d7 += $D7; $Overall.brk += $Brk
        $ByChannel[$Ch].n += 1; $ByChannel[$Ch].d7 += $D7; $ByChannel[$Ch].brk += $Brk
    }

    $Result = @{
        overall = @{
            n = $Overall.n
            d7_rate  = [math]::Round(($Overall.d7 / [math]::Max($Overall.n,1)) * 100, 1)
            brk_rate = [math]::Round(($Overall.brk / [math]::Max($Overall.n,1)) * 100, 1)
        }
        channels = @{}
    }
    foreach ($Ch in @('organic','paid','referral')) {
        $G = $ByChannel[$Ch]
        $Result.channels[$Ch] = @{
            n = $G.n
            d7_rate  = [math]::Round(($G.d7 / [math]::Max($G.n,1)) * 100, 1)
            brk_rate = [math]::Round(($G.brk / [math]::Max($G.n,1)) * 100, 1)
        }
    }
    return $Result
}

$This = Get-WeekStats -Week "$CurrentWeek"
$Last = Get-WeekStats -Week "$PreviousWeek"

$D7Delta  = [math]::Round($This.overall.d7_rate  - $Last.overall.d7_rate, 1)
$BrkDelta = [math]::Round($This.overall.brk_rate - $Last.overall.brk_rate, 1)

$AlertD7  = [math]::Abs($D7Delta)  -ge $AlertThresholdPts
$AlertBrk = [math]::Abs($BrkDelta) -ge $AlertThresholdPts
$AnyAlert = $AlertD7 -or $AlertBrk

# Channel with the largest-magnitude Day-7 move this week — the "watch this" line
$WatchChannel = $null
$WatchDelta   = 0
foreach ($Ch in @('organic','paid','referral')) {
    $ChDelta = [math]::Round($This.channels[$Ch].d7_rate - $Last.channels[$Ch].d7_rate, 1)
    if ([math]::Abs($ChDelta) -gt [math]::Abs($WatchDelta)) {
        $WatchDelta = $ChDelta
        $WatchChannel = $Ch
    }
}

function Format-Arrow {
    param([double]$Delta)
    if ($Delta -le -0.05) { return "down" }
    elseif ($Delta -ge 0.05) { return "up" }
    else { return "flat" }
}

function Format-Line {
    param([string]$Label, [double]$Rate, [double]$Delta)
    $Dir = Format-Arrow $Delta
    $Sym = switch ($Dir) { "down" {"|down|"} "up" {"|up|"} default {"|flat|"} }
    $Pts = "{0:N1}pt" -f [math]::Abs($Delta)
    if ($Dir -eq "flat") { return "$Label`: $Rate% ($Sym flat)" }
    return "$Label`: $Rate% ($Sym $Pts)"
}

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

$Lines = @()
$Lines += "Streakly Retention Pulse - Week $CurrentWeek vs Week $PreviousWeek"
$Lines += ""
$HeadlineLine = Format-Line "Day-7 retention" $This.overall.d7_rate $D7Delta
if ($AlertD7) { $HeadlineLine += "  ALERT (>= $AlertThresholdPts pt move)" }
$Lines += $HeadlineLine

$BreakLine = Format-Line "Streak-break rate" $This.overall.brk_rate $BrkDelta
if ($AlertBrk) { $BreakLine += "  ALERT (>= $AlertThresholdPts pt move)" }
$Lines += $BreakLine
$Lines += ""
$Lines += "By channel (Day-7):"
foreach ($Ch in @('organic','paid','referral')) {
    $ChDelta = [math]::Round($This.channels[$Ch].d7_rate - $Last.channels[$Ch].d7_rate, 1)
    $Suffix = if ($Ch -eq $WatchChannel -and $AnyAlert) { "  <- watch this" } else { "" }
    $Lines += "  " + (Format-Line $Ch $This.channels[$Ch].d7_rate $ChDelta) + $Suffix
}
$Lines += ""
if ($AnyAlert -and $WatchChannel) {
    $Lines += "Top signal: $WatchChannel channel Day-7 moved $WatchDelta pt week over week. Check for a cause before next Monday."
} elseif ($AnyAlert) {
    $Lines += "Top signal: headline metric crossed the alert threshold; no single channel explains it alone."
} else {
    $Lines += "Top signal: no channel or headline move crossed the $AlertThresholdPts pt threshold this week."
}
$Lines += ""
$Lines += "Baseline on file (live product, CLAUDE.md): $Baseline% Day-7. This run compares sample-data week $PreviousWeek to week $CurrentWeek, not the live baseline -- there is no production data source wired in yet."
$Lines += ""
if ($AnyAlert) {
    $Lines += "Next: run anomaly diagnosis? Reply YES to trigger 06-systems/agents/anomaly-diagnosis.md."
}

$Lines -join "`n" | Out-File -FilePath (Join-Path $OutDir "pulse-wk$CurrentWeek-vs-wk$PreviousWeek.txt") -Encoding utf8

Write-Output ($Lines -join "`n")
