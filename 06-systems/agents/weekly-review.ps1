<#
Streakly Learning Loop Agent
Reads outcome-log.md, scores resolved diagnoses hit/partial/miss against what
actually happened, and proposes ONE heuristic update to CLAUDE.md.

Judging whether a hypothesis was right is not something regex can do from free
text -- comparing "Push notification delivery issue" to a paragraph describing
what really happened is the same kind of judgment anomaly-diagnosis.ps1's
Step 3 needed. This script makes the TALLY mechanical instead: it requires
"what actually happened" entries to carry a "[SCORE: hit|partial|miss]" tag,
written by whoever resolves the placeholder (a human, or an LLM call reading
the SQL result against the hypothesis). That's a new convention, not yet
adopted anywhere in outcome-log.md -- see learning-loop.md Part 1.
#>

param(
    [string]$OutcomeLogPath = ".\outcome-log.md",
    [double]$HighConfidenceFloor = 7,
    [double]$MedConfidenceFloor = 4
)

function Get-ScoredEntries {
    param([string]$Path)
    $Entries = @()
    if (-not (Test-Path $Path)) { return $Entries }
    $RawLog = Get-Content $Path -Raw -Encoding UTF8
    $Blocks = $RawLog -split '(?=^## )', 0, 'Multiline' | Where-Object { $_ -match '^## ' }
    foreach ($Block in $Blocks) {
        if ($Block -notmatch 'happened:\s*(?!\[\s*\])(.+?)\[SCORE:\s*(hit|partial|miss)\s*\]') { continue }
        $Note  = $Matches[1].Trim()
        $Score = $Matches[2].Trim().ToLower()
        # two formats carry a top hypothesis: a COMPLETED run's ranked list
        # ("1. Label -- confidence N/10") and a STOPPED-at-Step-3 entry
        # ("Top hypothesis: Label -- confidence N/10"). Matching only the
        # first left every low-confidence stop with Confidence = $null,
        # which PowerShell's numeric comparison silently treats as 0 --
        # so it landed in the "Low" confidence band by coincidence, not
        # because its confidence was actually known and low. Caught by
        # running the fixture: the STOPPED entry printed "confidence /10".
        $TopHyp = $null; $Confidence = $null
        if ($Block -match '(?m)^\s*1\.\s*(.+?)\s*--\s*confidence\s*(\d+)') {
            $TopHyp = $Matches[1].Trim()
            $Confidence = [double]$Matches[2]
        } elseif ($Block -match 'Top hypothesis:\s*(.+?)\s*--\s*confidence\s*(\d+)') {
            $TopHyp = $Matches[1].Trim()
            $Confidence = [double]$Matches[2]
        }
        $HeaderLine = ($Block -split "`r?`n")[0]
        $Entries += [PSCustomObject]@{
            Header = $HeaderLine.Trim()
            TopHypothesis = $TopHyp
            Confidence = $Confidence
            Score = $Score
            Note = $Note
        }
    }
    return $Entries
}

$Scored = Get-ScoredEntries -Path $OutcomeLogPath

Write-Output "=== Learning loop: $($Scored.Count) scored entries found in $OutcomeLogPath ==="
if ($Scored.Count -eq 0) {
    Write-Output "Nothing to score yet -- every current outcome-log.md placeholder is still '[ ]'."
    Write-Output "This is a real limitation, not a bug: see learning-loop.md Part 3 for a"
    Write-Output "worked example against a simulated fixture instead."
    exit 0
}

foreach ($E in $Scored) {
    Write-Output "$($E.Header)"
    Write-Output "  Top hypothesis: $($E.TopHypothesis) (confidence $($E.Confidence)/10) -> $($E.Score.ToUpper())"
}
Write-Output ""

$HitCount = @($Scored | Where-Object { $_.Score -eq 'hit' }).Count
$PartialCount = @($Scored | Where-Object { $_.Score -eq 'partial' }).Count
$MissCount = @($Scored | Where-Object { $_.Score -eq 'miss' }).Count

Write-Output "Overall: $HitCount hit / $PartialCount partial / $MissCount miss (of $($Scored.Count))"

# calibration by confidence band -- do high-confidence calls actually land more often?
# explicit -ne $null guard: without it, an entry whose confidence couldn't be
# parsed would silently score as 0 and land in "Low" rather than being excluded
$KnownConfidence = @($Scored | Where-Object { $_.Confidence -ne $null })
$UnknownConfidence = @($Scored | Where-Object { $_.Confidence -eq $null })
$HighBand = @($KnownConfidence | Where-Object { $_.Confidence -ge $HighConfidenceFloor })
$MedBand  = @($KnownConfidence | Where-Object { $_.Confidence -ge $MedConfidenceFloor -and $_.Confidence -lt $HighConfidenceFloor })
$LowBand  = @($KnownConfidence | Where-Object { $_.Confidence -lt $MedConfidenceFloor })
if ($UnknownConfidence.Count -gt 0) { Write-Output "($($UnknownConfidence.Count) scored entry(ies) had no parseable confidence -- excluded from banding, not counted as low.)" }

function Get-HitRate { param($Band) if ($Band.Count -eq 0) { return "n/a" }; $H = @($Band | Where-Object { $_.Score -eq 'hit' }).Count; return "$H/$($Band.Count)" }

Write-Output ""
Write-Output "Calibration by confidence band:"
Write-Output "  High (>=$HighConfidenceFloor):  $(Get-HitRate $HighBand) hit"
Write-Output "  Medium ($MedConfidenceFloor-$($HighConfidenceFloor-1)): $(Get-HitRate $MedBand) hit"
Write-Output "  Low (<$MedConfidenceFloor):    $(Get-HitRate $LowBand) hit"

# one heuristic proposal -- the single most actionable pattern, not a list
Write-Output ""
Write-Output "=== Proposed heuristic update (ONE, for human sign-off -- see Part 2) ==="
if ($MissCount -eq 0 -and $PartialCount -eq 0) {
    Write-Output "No misses or partials yet -- nothing to propose. Re-run after more entries resolve."
} elseif ($HighBand.Count -gt 0 -and (Get-HitRate $HighBand) -notmatch "^$($HighBand.Count)/") {
    # name the specific hypothesis label driving the miss, not "whichever is
    # missing" -- a proposal has to point at one line in the rule table
    $HighBandByLabel = $HighBand | Group-Object -Property TopHypothesis
    $WorstLabel = $HighBandByLabel | ForEach-Object {
        $Hits = @($_.Group | Where-Object { $_.Score -eq 'hit' }).Count
        [PSCustomObject]@{ Label = $_.Name; Hits = $Hits; Total = $_.Count; Rate = $Hits / $_.Count }
    } | Sort-Object Rate | Select-Object -First 1

    Write-Output "High-confidence calls are not landing at the rate their score implies."
    Write-Output "Specifically: `"$($WorstLabel.Label)`" hit $($WorstLabel.Hits)/$($WorstLabel.Total) at confidence >=$HighConfidenceFloor."
    Write-Output ""
    Write-Output "Proposed CLAUDE.md entry (Standing Constraints, evidence-confidence style):"
    Write-Output "  `"anomaly-diagnosis's `"$($WorstLabel.Label)`" hypothesis has hit $($WorstLabel.Hits)/$($WorstLabel.Total)"
    Write-Output "  at its base confidence of $HighConfidenceFloor+/10 -- lower its rule-table anchor in"
    Write-Output "  anomaly-diagnosis.md until the hit rate at that confidence improves. Recorded"
    Write-Output "  [date], n=$($WorstLabel.Total) -- re-check after more entries resolve, this is not yet a stable rate.`""
} else {
    Write-Output "Misses/partials are concentrated at medium or low confidence, where the"
    Write-Output "score already signals low trust. No confidence-anchor change proposed --"
    Write-Output "the gate is working as intended. Re-check after more entries resolve."
}
