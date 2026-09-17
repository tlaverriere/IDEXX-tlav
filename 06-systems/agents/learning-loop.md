# The Learning Loop — Comeback Coach

*2026-09-17 · Trevor Laverriere · closes the loop `outcome-log.md` was built for*

## Part 1 · What's mechanical and what isn't

Same honest split as every other agent in this stack. **Judging whether a hypothesis was
right by reading free text is not something a script should do** — that's exactly the kind
of comparison anomaly-diagnosis's Step 3 already established as human/LLM judgment, not
regex. So this agent introduces one new convention rather than trying to parse prose:

**Whoever resolves a placeholder tags it:** `What actually happened: <free text> [SCORE: hit|partial|miss]`

Once that tag exists, the *tally* is fully mechanical — counting hits, grouping by
confidence band, and finding which specific hypothesis label is underperforming its own
confidence anchor. **`weekly-review.ps1` does exactly that, for real, below.** Nobody has
adopted the tag yet — the three unresolved placeholders in the real `outcome-log.md` are
still bare `[ ]`, not `[SCORE: ...]` — so this is a convention proposed here, not one
already in use.

---

## Part 2 · The self-review prompt

The weekly review itself — turning a tally into a plain finding and exactly one proposed
change — is judgment, run as a prompt (by a human reading the script's output, or by an LLM
call in the real deployment). This is the actual prompt:

```
You are reviewing one week of Streakly anomaly-diagnosis outcomes.

Input: the scored entries and calibration tally from weekly-review.ps1's output
(hit/partial/miss counts, confidence-band hit rates, and any flagged
underperforming hypothesis label).

Do:
1. State the week's hit rate in one sentence. Don't editorialize if n is small --
   say so plainly ("n=3, too small to trust yet") rather than implying a trend.
2. If any confidence band's actual hit rate diverges from what its label implies,
   name the specific hypothesis causing it -- never "confidence in general is off."
3. Propose exactly ONE heuristic update to CLAUDE.md. Not a list. If nothing in
   this week's data clears the bar for a change, say that -- "no change proposed"
   is a valid, complete output.
4. Write the proposal in CLAUDE.md's own voice: a rule, a **Why:** line citing the
   actual n and the actual miss, and a **How to apply:** line. Do not soften it
   into a suggestion Claude might use -- if it's not worth stating as a rule, it's
   not worth proposing.
5. Do NOT write it into CLAUDE.md yourself. Output the proposed entry and stop.
   A file that shapes every future session's behavior does not get edited by an
   automated weekly job on n=3 -- that's the same "ask before writing" rule this
   project already holds for every tracked file, and it matters more here, not
   less, because this is the file that decides how the other two agents get
   trusted next week.
```

**Point 5 is the load-bearing rule of this whole feature.** A learning loop that silently
rewrites its own persistent memory is a system correcting itself faster than anyone can
watch it — exactly the failure mode "never let a solution get treated as settled" already
guards against, aimed at CLAUDE.md instead of a product decision. **This loop proposes.
A human approves.** Always.

---

## Part 3 · Run it

`weekly-review.ps1`, in this folder. Reads `outcome-log.md` for `[SCORE: ...]`-tagged
entries, tallies hit/partial/miss overall and by confidence band, and names the one
proposal a human should look at — following the prompt above mechanically for the tally,
then in the same voice for the write-up.

**Against the real log, run as-is:**

```
=== Learning loop: 0 scored entries found in .\outcome-log.md ===
Nothing to score yet -- every current outcome-log.md placeholder is still '[ ]'.
```

**True and correctly reported** — none of the three unresolved calls have been checked
against reality yet, and none carry the `[SCORE: ...]` tag this loop depends on. That's a
real backlog to clear, not a bug in the script.

**Against `learning-loop-fixture.md`** — five invented entries, clearly labeled simulated,
built only to prove the mechanics work before there's real data to run them on:

```
Overall: 2 hit / 1 partial / 2 miss (of 5)

Calibration by confidence band:
  High (>=7):  2/3 hit
  Medium (4-6): 0/1 hit
  Low (<4):    0/1 hit

=== Proposed heuristic update (ONE, for human sign-off) ===
High-confidence calls are not landing at the rate their score implies.
Specifically: "Push notification delivery issue" hit 2/3 at confidence >=7.

Proposed CLAUDE.md entry (Standing Constraints, evidence-confidence style):
  "anomaly-diagnosis's "Push notification delivery issue" hypothesis has hit 2/3
  at its base confidence of 7+/10 -- lower its rule-table anchor in
  anomaly-diagnosis.md until the hit rate at that confidence improves. Recorded
  [date], n=3 -- re-check after more entries resolve, this is not yet a stable rate."
```

**Three bugs found running the fixture, fixed in the committed script:**
1. The top-hypothesis regex only matched a COMPLETED run's `"1. Label -- confidence N"`
   format, so the low-confidence STOPPED entry's confidence came back `$null` —
   which PowerShell's numeric comparison silently treats as `0`, landing it in the "Low"
   band by coincidence rather than because its confidence was genuinely known and low.
   Fixed by also matching the STOPPED format (`"Top hypothesis: Label -- confidence N"`).
2. **Hardened against the same class of bug recurring**: band membership now explicitly
   excludes entries with `Confidence -eq $null`, and reports the exclusion, instead of
   trusting that every entry will always parse.
3. The first version of the proposal step named "whichever hypothesis type is missing" —
   too vague to act on. Fixed to group by label within the flagged band and name the
   specific worst performer, which is what actually appears in the output above.

**The proposal above is exactly what a human would see and decide on — it is not written
into CLAUDE.md by this script, per Part 2, point 5.**

---

## Boundaries

| | |
|---|---|
| **Does** | Tally hit/partial/miss and confidence-band calibration mechanically, once entries carry the `[SCORE: ...]` tag; name the single most actionable pattern by specific hypothesis label. |
| **Does not** | Judge whether a hypothesis was right — that's the human or LLM call filling in `[SCORE: ...]` in the first place. Write to CLAUDE.md. Run against untagged entries (all three real ones, today). |
| **Depends on** | A convention nobody has adopted yet — `[SCORE: hit\|partial\|miss]` on every resolved placeholder. Worth raising with Raj before this loop has anything real to say. |
| **Chains from** | `outcome-log.md`, the same file Weekly Insight now also reads (`registry.md` §2) — this is the second consumer of that log, not a new source. |
