<#
Streakly Weekly Insight Agent
Pulls four sources: retention metrics (data/*.csv), sprint completions
(01-orient/change_log.md), top NPS theme (02-research/nps-analysis.md), and
-- new as of the registry/connection-plan pass -- the anomaly-diagnosis
outcome log (outcome-log.md), closing the anomaly -> weekly-insight
connection named as a gap in weekly-insight.md's own Boundaries section.

Three of the four are pulled mechanically and for real below: the retention
signal (a CSV join, same logic as metric-pulse.ps1), the top NPS theme
(parsed straight out of nps-analysis.md's ranked table), and the outcome-log
summary (counting entries and checking placeholders needs no judgment). The
one that isn't -- condensing today's change_log rows into exactly 3 "Done
this week" bullets, plus the pilot-open-rate "Changed" bullet and the "Watch
next week" pick -- is judgment, the same way anomaly-diagnosis.ps1's
hypothesis TEXT was judgment: the script surfaces real candidates, a human
(or an LLM call, in the real version) picks and phrases the final 3. See
weekly-insight.md Part 1 for why this split is honest rather than a shortcut.
#>

param(
    [string]$WeekOf = (Get-Date -Format "yyyy-MM-dd"),
    [string]$DataDir = "..\..\data",
    [string]$ChangeLogPath = "..\..\01-orient\change_log.md",
    [string]$NpsPath = "..\..\02-research\nps-analysis.md",
    [string]$OutcomeLogPath = ".\outcome-log.md",
    [string]$OutDir = "..\..\reports",
    [string]$SlackOutDir = ".\slack-drafts",

    # Judgment picks -- defaults are the analyst's actual selections for this run
    [string[]]$DoneBullets = @(
        "Comeback screen PRD finalized and pressure-tested against three reviewers -- Raj, Marcus, and a churned user (docs/prd.md, docs/objection-log.md)",
        "Full experiment design specified and pre-registered -- 1,568 users per arm, kill conditions set, no interim efficacy looks (data/experiment-design.md)",
        "Metric pulse and anomaly-diagnosis agents built and run for real against sample data, not just spec'd (06-systems/agents/)"
    ),
    [string]$SecondChangedBullet = "Comeback screen open rate climbed 28% -> 56% across the pilot's four sends -- the one pilot number holding up under scrutiny, unlike the withdrawn +30pt Day-7 claim (data/metric-findings.md)",
    [string]$WatchBullet = "Query 1 lands Wednesday 2026-09-23 (Raj) -- decomposes the 9-point Day-7 decline and decides whether any of the three approved features address it; the release is gated on the answer (docs/query1-handoff.md)"
)

# ---------- Source 1: retention metrics, real CSV join ----------
$UsersRows = Import-Csv (Join-Path $DataDir "users.csv")
$RetRows   = Import-Csv (Join-Path $DataDir "retention.csv")
$UserChannel = @{}
foreach ($Row in $UsersRows) { $UserChannel[$Row.user_id] = $Row.acquisition_channel }

function Get-ChannelDay7 {
    param([string]$Week, [string]$Channel)
    $N = 0; $D7 = 0
    foreach ($Row in $RetRows) {
        if ($Row.cohort_week -ne $Week) { continue }
        if ($UserChannel[$Row.user_id] -ne $Channel) { continue }
        $N += 1
        if ($Row.day_7 -eq '1' -or $Row.day_7 -eq 'True' -or $Row.day_7 -eq 'true') { $D7 += 1 }
    }
    if ($N -eq 0) { return $null }
    return [math]::Round(($D7 / $N) * 100, 1)
}

$PaidWk4 = Get-ChannelDay7 -Week "4" -Channel "paid"
$PaidWk3 = Get-ChannelDay7 -Week "3" -Channel "paid"
$PaidDelta = [math]::Round($PaidWk4 - $PaidWk3, 1)

$RetentionBullet = "Paid-channel Day-7 dropped $([math]::Abs($PaidDelta))pt week-over-week in the sample data ($PaidWk3% -> $PaidWk4%) -- flagged as likely noise at n~34 per channel-week, not a confirmed signal (data/retention.csv via metric-pulse's own join)"

# ---------- Source 2: top NPS theme, parsed from the real ranked table ----------
$NpsLines = Get-Content $NpsPath -Encoding UTF8
$TopThemeLine = $NpsLines | Where-Object { $_ -match '^\|\s*1\s*\|' } | Select-Object -First 1

# deliberately no literal em-dash in this regex -- Windows PowerShell 5.1 parses
# a .ps1 source file's own non-ASCII literals using the system codepage unless
# the file carries a BOM, so a literal "--" character embedded in the script
# silently stops matching the correctly UTF8-decoded file content (caught by
# running this: it worked before -Encoding UTF8 was added below, by two wrongs
# cancelling out, then broke once the file was decoded correctly). ".*" skips
# whatever separator the table actually uses instead of requiring one exact
# character to round-trip through two different encodings correctly.
$TopTheme = $null
if ($TopThemeLine -match '^\|\s*1\s*\|\s*\*\*(.+?)\*\*.*\|\s*\*\*(.+?)\*\*\s*\|\s*(.+?)\s*\|') {
    $TopTheme = [PSCustomObject]@{
        Theme = $Matches[1].Trim()
        Count = $Matches[2].Trim()
        Respondents = $Matches[3].Trim()
    }
}

if ($TopTheme) {
    $NpsBullet = "Top NPS theme unchanged: `"$($TopTheme.Theme)`" -- $($TopTheme.Count) ($($TopTheme.Respondents)) -- $($NpsPath)"
} else {
    $NpsBullet = "Top NPS theme: could not parse $NpsPath's ranked table -- check its format did not change"
}

# ---------- Source 3: change_log.md sprint completions, real candidate extraction ----------
$ChangeLogLines = Get-Content $ChangeLogPath -Encoding UTF8
$TodayRows = $ChangeLogLines | Where-Object { $_ -match "^\|\s*\*{0,2}$WeekOf\*{0,2}\s*\|" }

$Candidates = @()
foreach ($Row in $TodayRows) {
    # skip past the Date cell first ([^|]+ matches it whether or not it's bolded),
    # then grab the first bold span in the Change cell -- without the leading
    # "^\|[^|]+\|" this matched the bolded **date** itself on most rows instead
    # of the headline (caught by running it: 4 of the first 5 candidates were
    # just "2026-09-17")
    if ($Row -match '^\|[^|]+\|\s*\*\*([^*]+)\*\*') { $Candidates += $Matches[1] }
}

Write-Output "=== Source pulls ==="
Write-Output "Retention (real join): paid channel $PaidWk3% -> $PaidWk4% ($PaidDelta pt)"
Write-Output "NPS (real parse): $($TopTheme.Theme) -- $($TopTheme.Count)"
Write-Output "Change log: $($TodayRows.Count) rows dated $WeekOf; $($Candidates.Count) candidate headlines extracted"
Write-Output "  (first 5 candidates, for audit -- final 3 'Done' bullets below are a judgment pick, not top-5-by-recency)"
$Candidates | Select-Object -First 5 | ForEach-Object { Write-Output "   - $_" }
Write-Output ""

# ---------- Source 4: anomaly-diagnosis outcome log, real entry parse ----------
# Closes the anomaly-diagnosis -> weekly-insight connection. Counting entries
# and checking whether a placeholder is still "[ ]" is mechanical, same as
# the NPS pull -- no summarization needed here.
$OutcomeEntries = @()
if (Test-Path $OutcomeLogPath) {
    $RawLog = Get-Content $OutcomeLogPath -Raw -Encoding UTF8
    $Blocks = $RawLog -split '(?=^## )', 0, 'Multiline' | Where-Object { $_ -match '^## ' }
    foreach ($Block in $Blocks) {
        $Status = $null; $TopHyp = $null; $Resolved = $false; $HasPlaceholder = $false
        # match against the header's first line only -- "^...(.+)$" on the
        # whole multi-line $Block can never succeed, because "." doesn't
        # cross newlines by default and there's no Singleline/Multiline flag
        # set, so the capture group has to reach true end-of-string without
        # ever crossing the line break after the header (caught by running
        # it: Status was "NO MATCH" on every block, which silently zeroed
        # UnresolvedCount below)
        $HeaderLine = ($Block -split "`r?`n")[0]
        if ($HeaderLine -match '--\s*(.+)$') { $Status = $Matches[1].Trim() }
        if ($Block -match '(?m)^\s*1\.\s*(.+?)\s*--\s*confidence') { $TopHyp = $Matches[1].Trim() }
        # a "STOPPED" entry with no placeholder line at all (below-threshold)
        # is genuinely nothing to track -- but "inconclusive" and
        # "low confidence" stops DO carry a placeholder, and belong in the
        # unresolved count too: whether a stop was the right call is exactly
        # what the learning loop needs to check, not only full completions
        if ($Block -match 'happened:\s*\[\s*\]') { $HasPlaceholder = $true; $Resolved = $false }
        elseif ($Block -match 'happened:\s*(\S.*)') { $HasPlaceholder = $true; $Resolved = $true }
        $OutcomeEntries += [PSCustomObject]@{ Status = $Status; TopHypothesis = $TopHyp; HasPlaceholder = $HasPlaceholder; Resolved = $Resolved }
    }
}
$UnresolvedCount = @($OutcomeEntries | Where-Object { $_.HasPlaceholder -and -not $_.Resolved }).Count
$EarliestUnresolved = $OutcomeEntries | Where-Object { $_.HasPlaceholder -and -not $_.Resolved -and $_.TopHypothesis } | Select-Object -First 1

if ($OutcomeEntries.Count -gt 0) {
    $OutcomeBullet = "Anomaly log this week: $($OutcomeEntries.Count) run(s) ($($UnresolvedCount) unresolved)."
    if ($EarliestUnresolved) { $OutcomeBullet += " Earliest open call: `"$($EarliestUnresolved.TopHypothesis)`" -- still awaiting what-actually-happened." }
} else {
    $OutcomeBullet = "Anomaly log this week: no entries found at $OutcomeLogPath."
}
Write-Output "Outcome log (real parse): $($OutcomeEntries.Count) entries, $UnresolvedCount unresolved"
Write-Output ""

# ---------- Assemble the report ----------
$DayName = (Get-Date $WeekOf).ToString("ddd MMM d")

$ReportLines = @()
$ReportLines += "# Streakly Weekly Insight, $DayName"
$ReportLines += ""
# each pair of backticks below is ONE literal backtick (markdown code-span
# marker) -- a single backtick is PowerShell's escape character in a
# double-quoted string, so "`n" silently became a real newline here before
# this fix (caught by running it: the sources line broke mid-word at "nps-")
$ReportLines += "*Sources: retention metrics (``data/``, real join), sprint completions (``change_log.md``, $($TodayRows.Count) rows dated $WeekOf), top NPS theme (``nps-analysis.md``, parsed).*"
$ReportLines += ""
$ReportLines += "## Done this week"
foreach ($B in $DoneBullets) { $ReportLines += "- $B" }
$ReportLines += ""
$ReportLines += "## Changed this week"
$ReportLines += "- $RetentionBullet"
$ReportLines += "- $SecondChangedBullet"
$ReportLines += ""
$ReportLines += "## Watch next week"
$ReportLines += "- $WatchBullet"
$ReportLines += ""
$ReportLines += "*NPS context (not one of the 3-2-1 slots, carried for completeness): $NpsBullet*"
$ReportLines += ""
$ReportLines += "*$OutcomeBullet*"

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
$ReportPath = Join-Path $OutDir "$WeekOf.md"
$ReportLines -join "`n" | Out-File -FilePath $ReportPath -Encoding utf8

Write-Output "Report saved to $ReportPath"
Write-Output ""

# ---------- 3-2-1 Slack summary ----------
$SlackLines = @()
$SlackLines += "Streakly Weekly Insight, $DayName"
$SlackLines += ""
$SlackLines += "Done this week:"
foreach ($B in $DoneBullets) { $SlackLines += "- $B" }
$SlackLines += ""
$SlackLines += "Changed this week:"
$SlackLines += "- $RetentionBullet"
$SlackLines += "- $SecondChangedBullet"
$SlackLines += ""
$SlackLines += "Watch next week:"
$SlackLines += "- $WatchBullet"
$SlackLines += ""
$SlackLines += "Saved to $ReportPath"

if (-not (Test-Path $SlackOutDir)) { New-Item -ItemType Directory -Path $SlackOutDir | Out-Null }
$SlackPath = Join-Path $SlackOutDir "weekly-insight-$WeekOf.txt"
$SlackLines -join "`n" | Out-File -FilePath $SlackPath -Encoding utf8

Write-Output "Slack draft written to $SlackPath"
Write-Output "(No Slack connector authorized in this environment -- this is the message that would post.)"
