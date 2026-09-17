# Learning Loop Test Fixture — SIMULATED, not real outcomes

*Five invented entries in `outcome-log.md`'s exact format, used only to prove
`weekly-review.ps1` scores and aggregates correctly. Nothing below happened.
The real log has zero scored entries as of 2026-09-17 — see learning-loop.md
Part 3.*

## Mon Sep 14, 9:02AM -- COMPLETED full loop -- diagnostic posted

Trigger: Day-7 retention moved -3 pt (42% -> 39%)
Ranked hypotheses:
  1. Push notification delivery issue -- confidence 8/10 (high)
  2. New user cohort quality shift from paid channel -- confidence 5/10 (medium)
  3. Streak-reset copy regression after last deploy -- confidence 3/10 (low)

What actually happened: SQL confirmed a delivery outage on the 13th, 40% of sends failed. [SCORE: hit]

## Tue Sep 15, 9:10AM -- COMPLETED full loop -- diagnostic posted

Trigger: Day-7 retention moved -5 pt (39% -> 34%)
Ranked hypotheses:
  1. Push notification delivery issue -- confidence 8/10 (high)
  2. New user cohort quality shift from paid channel -- confidence 5/10 (medium)
  3. Streak-reset copy regression after last deploy -- confidence 3/10 (low)

What actually happened: delivery was fine; a paid campaign change three days earlier was the real driver. [SCORE: miss]

## Wed Sep 16, 9:05AM -- COMPLETED full loop -- diagnostic posted

Trigger: Day-7 retention moved -3 pt (41% -> 38%)
Ranked hypotheses:
  1. New user cohort quality shift from paid channel -- confidence 5/10 (medium)
  2. Push notification delivery issue -- confidence 4/10 (medium)
  3. Streak-reset copy regression after last deploy -- confidence 3/10 (low)

What actually happened: paid was part of it, but a concurrent onboarding bug was the bigger factor -- right family, wrong specifics. [SCORE: partial]

## Thu Sep 17, 9:00AM -- STOPPED at Step 3 (low confidence)

Trigger: Day-7 retention moved -3 pt (38% -> 35%)
Top hypothesis: Streak-reset copy regression after last deploy -- confidence 3/10 (needed > 6/10)

What actually happened: it actually was the copy regression -- the low-confidence gate correctly withheld SQL, but the catch-all was still right. [SCORE: miss]

## Fri Sep 18, 9:08AM -- COMPLETED full loop -- diagnostic posted

Trigger: Day-7 retention moved -4 pt (35% -> 31%)
Ranked hypotheses:
  1. Push notification delivery issue -- confidence 8/10 (high)
  2. New user cohort quality shift from paid channel -- confidence 5/10 (medium)
  3. Streak-reset copy regression after last deploy -- confidence 3/10 (low)

What actually happened: confirmed -- delivery failure again, second one this month. [SCORE: hit]
