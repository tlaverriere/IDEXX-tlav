# Outcome Log

Append-only. Every anomaly-diagnosis run logs here, including stops at Step 1 or 2 -- not only full completions.

## Thu Sep 17, 11:11AM -- COMPLETED full loop -- diagnostic posted

Trigger: Day-7 retention moved -4 pt (39% -> 35%)
Ranked hypotheses:
  1. Push notification delivery issue -- confidence 8/10 (high)
  2. New user cohort quality shift from paid channel -- confidence 5/10 (medium)
  3. Streak-reset copy regression after last deploy -- confidence 3/10 (low)

What actually happened: [ ]


## Thu Sep 17, 11:11AM -- STOPPED at Step 1 (below threshold)

Day-7 retention moved -1 pt, at or below the 2 pt gate. No decomposition run.


## Thu Sep 17, 11:11AM -- STOPPED at Step 2 (inconclusive)

Day-7 retention moved -4 pt but only 0 driver(s) crossed their meaningful-movement threshold. Decomposition does not localise a cause. Placeholder for what actually happened: [ ]


## Thu Sep 17, 11:11AM -- STOPPED at Step 3 (low confidence)

Trigger: Day-7 retention moved -4 pt (39% -> 35%)
Top hypothesis: Streak-reset copy regression after last deploy -- confidence 3/10 (needed > 6/10)
No hypothesis cleared the confirmation bar. Posted as a low-confidence alert, not a diagnostic.
Placeholder for what actually happened: [ ]

