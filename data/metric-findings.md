# Metric Findings — Day-7 decline, week-1 breaks, and the week-5 experiment

*2026-09-17 · Trevor Laverriere · analysis run against two datasets, both synthetic*

> **Read this first.** I was asked to analyse the Google Sheet. I did. The Sheet
> **cannot answer questions 2 and 4** — it has no streak field and no Comeback
> artifact. Its tables describe a personal-finance app (`spending_breakdown`,
> `savings_goal`, `spending_alert`), and its week-5 experiment is `summary_v1`,
> a weekly summary send.
>
> `data/README.md` already says this and points at local CSVs instead. Those do
> have `broke_streak_week1`, a `comeback` screen and a `comeback_screen` nudge.
> They are **not** a relabel of the Sheet — different dates, different session
> counts, different weeks 1–4. So both are reported below, and **the local set is
> the one to quote.** Where they disagree I say so.
>
> **Neither dataset reproduces Streakly's real figures** (48% → 39%). Nothing
> here substitutes for Query 1.

## Verdict up front

**Do not scale the Comeback screen on this evidence.**

The open-rate result is strong and holds up under every check I ran. The
**retention** result — the only one that speaks to the >50% Day-7 target — fails
four separate checks. Details in Q3. The single worst one: for all 100 week-5
users, **day 7 falls on 2026-05-11 and the last date anywhere in the dataset is
2026-05-08.** The headline number is measured four days past the end of the data.

---

# Q1 · Day-7 retention by cohort week

## SQL

```sql
SELECT
  cohort_week,
  COUNT(*)                      AS cohort_size,
  SUM(day_7)                    AS retained_d7,
  ROUND(100.0 * AVG(day_7),  1) AS day7_pct,
  ROUND(100.0 * AVG(day_1),  1) AS day1_pct,
  ROUND(100.0 * AVG(day_30), 1) AS day30_pct
FROM nudge_retention
GROUP BY cohort_week
ORDER BY cohort_week;
```

Week 5 mixes treated and untreated users, so it has to be split before it means
anything:

```sql
SELECT u.variant AS arm,
       COUNT(*)                       AS n,
       ROUND(100.0 * AVG(r.day_7), 1) AS day7_pct
FROM nudge_retention r
JOIN nudge_users u USING (user_id)
WHERE r.cohort_week = 5
GROUP BY u.variant;
```

## Plain English

Group every user by the week they signed up, then take the share flagged active
on day 7. One row per cohort. The second query stops week 5 from being read as a
single number, because half of it received the treatment.

## Result

| Cohort week | Sheet day-7 | Local day-7 | day-1 (local) | day-30 (local) |
|---|---|---|---|---|
| 1 | 60% | 37% | 91% | 10% |
| 2 | 53% | 37% | 90% | 10% |
| 3 | 48% | 31% | 92% | 6% |
| 4 | 44% | 27% | 93% | 8% |
| 5 | 61% | 61% | 91% | 29% |

- **Sheet:** week 1 → week 4 is **−16 pp**, slope −5.3 pp/week, *p* = 0.024, 95% CI [−29.7, −2.3].
- **Local:** week 1 → week 4 is **−10 pp**, slope −3.6 pp/week, *p* = 0.13, 95% CI [−22.9, +2.9] — **not significant at n=100/week.**

**Week 5 is not a recovery.** Split by arm, in both datasets: control 46%,
treatment 76%. The apparent rebound is the experiment.

One difference that matters: in the Sheet, week-5 control (46%) sits right on the
week-4 trend (44%). In the local data, week-5 control (46%) is **19 pp above**
week 4 (27%) — so the local control arm broke trend on its own. That is a reason
to trust the local week-5 numbers *less*, not more.

## What it means for the decision

*Confidence: directional.* The decline is consistently downward but only reaches
significance in one of the two datasets, and neither matches Streakly's actual
numbers.

The useful finding is the shape, not the size: **day-1 is flat at 90–93% across
every cohort while day-7 falls.** Users are activating and then leaving inside
days 2–6. That narrows Query 1 — it makes "the loss is users who never
established anything" less likely and "the loss is in the first week after
activation" more likely. It does not answer Query 1, and the gate should still hold.

---

# Q2 · Do week-1 streak breakers retain worse?

## The Sheet cannot answer this

There is no streak column in any of the five tables. The only route is deriving
breaks from gaps in `nudge_sessions`, and that table will not support it:

```sql
-- integrity check 1: sessions dated before the user existed
SELECT COUNT(*) AS impossible_rows, COUNT(DISTINCT s.user_id) AS users_affected
FROM nudge_sessions s
JOIN nudge_users u USING (user_id)
WHERE s.session_date < u.signup_date;
-- 207 rows across 171 users

-- integrity check 2: flagged day-7 retained, but no session in week 1
WITH wk1 AS (
  SELECT DISTINCT s.user_id
  FROM nudge_sessions s
  JOIN nudge_users u USING (user_id)
  WHERE DATE_DIFF(s.session_date, u.signup_date, DAY) BETWEEN 0 AND 6
)
SELECT COUNT(*) FROM nudge_retention r
WHERE r.day_7 = 1 AND r.user_id NOT IN (SELECT user_id FROM wk1);
-- 72 users
```

207 sessions predate their own signup. 72 users are flagged day-7 retained with
no recorded week-1 session at all. Users average 4.7 sessions across a 30-day
window, and a gap is even *observable* for only 144 of 500 users. The table is a
**sample of sessions, not an activity log**, so daily-level streaks cannot be
reconstructed from it.

For completeness: the derived proxy returns **+2.1 pp, *p* = 0.71** — a null.
**Do not report that number.** It is what a broken instrument prints, not a finding.

## The local data answers it properly

```sql
SELECT
  broke_streak_week1,
  COUNT(*)                        AS users,
  ROUND(100.0 * AVG(day_7),  1)   AS day7_pct,
  ROUND(100.0 * AVG(day_30), 1)   AS day30_pct,
  ROUND(100.0 * AVG(churned), 1)  AS churn_pct
FROM retention
WHERE cohort_week <> 5          -- week 5 carries the treatment
GROUP BY broke_streak_week1;
```

## Plain English

`broke_streak_week1` is recorded per user, so this is a direct split: breakers
versus everyone else, comparing day-7, day-30 and churn. Week 5 is excluded
because half of it was treated, which would contaminate the comparison.

## Result — weeks 1–4 only

| Group | n | Day-7 | Churn |
|---|---|---|---|
| Broke in week 1 | 145 | **23.4%** | 76.6% |
| Did not break | 255 | **38.4%** | 61.6% |

**−15 pp, ratio 0.61, *p* = 0.0022, 95% CI [−24.1, −5.9].** Churn relative risk
**1.24**. The gap holds in all five cohort weeks individually (23% vs 42%, 23% vs
46%, 24% vs 36%, 23% vs 29%, 38% vs 80%).

Across all 500 users the gap is −19 pp (*p* < 0.0001) and churn RR is 1.34 —
close to, but below, Raj's directional ~2x.

**Day-30 shows no gap at all** (12.6% vs 12.6%, *p* = 0.99). Treat that as
unknown rather than as a finding: day 30 falls after the last date in the dataset
for **400 of 500 users**.

## The finding that actually matters

Decomposing the week-1 → week-4 decline into "more people breaking" versus
"retention falling within each group":

| Component | Contribution |
|---|---|
| More users breaking (26% → 35%) | **−1.7 pp** |
| Retention falling *within* groups | **−8.3 pp** |
| Total | −10 pp |

And within groups: **breakers stayed flat (23.1% → 22.9%) while non-breakers fell
41.9% → 29.2%.** The deterioration is concentrated in users who **never broke a
streak**.

## What it means for the decision

*Confidence: the break penalty is well-supported in this dataset; the
decomposition is directional and rests on n=100/week.*

Breaking a streak in week 1 is genuinely associated with worse day-7 retention —
that part of the premise survives. But **the decline across cohorts is not mainly
explained by more people breaking.** Roughly 1.7 of 10 points is mix; the rest is
users who kept their streaks intact and left anyway.

That is the **drift path**, and by construction no break-triggered surface
reaches it. If this pattern replicates in Streakly, the Comeback screen addresses
the smaller share of the problem. This is the inconvenient answer Query 1 was
pre-registered to be able to return, and it is worth flagging to Marcus **before**
the query lands rather than after.

---

# Q3 · Week 5 — treatment vs control

## SQL

```sql
SELECT
  u.variant                       AS arm,
  COUNT(*)                        AS n,
  ROUND(100.0 * AVG(r.day_1),  1) AS day1_pct,
  ROUND(100.0 * AVG(r.day_7),  1) AS day7_pct,
  ROUND(100.0 * AVG(r.day_30), 1) AS day30_pct
FROM nudge_users u
JOIN nudge_retention r USING (user_id)
WHERE u.cohort_week = 5 AND u.variant <> ''
GROUP BY u.variant;
```

Then the check that decides whether the headline is believable — does the effect
sit in the group that could actually see the screen?

```sql
SELECT u.variant AS arm, r.broke_streak_week1,
       COUNT(*) AS n, ROUND(100.0 * AVG(r.day_7), 1) AS day7_pct
FROM users u JOIN retention r USING (user_id)
WHERE u.cohort_week = 5 AND u.variant <> ''
GROUP BY u.variant, r.broke_streak_week1;
```

## Plain English

First query: average the retention flags within each arm. Second: split each arm
by whether the user broke a streak in week 1. A Comeback screen fires on a break,
so if it causes the lift, the lift has to be concentrated in breakers. Users who
never broke are the closest thing to a placebo group.

## Result

| Arm | n | Day-1 | Day-7 | Day-30 |
|---|---|---|---|---|
| comeback / summary_v1 | 50 | 94% | **76%** | 36% |
| control | 50 | 88% | **46%** | 22% |

| Metric | Difference | *p* | 95% CI |
|---|---|---|---|
| Day-7 | **+30 pp** (×1.65) | **0.0021** | [+11.8, +48.2] |
| Day-30 | +14 pp (×1.64) | 0.12 | [−3.6, +31.6] |
| Day-1 | +6 pp | 0.29 | [−5.2, +17.2] |

Randomisation is clean in the local data: channel 17/17/16 vs 17/16/17, platform
25/25 vs 25/25, `goal_set_date` 50/50, break rate 40% vs 50% (*p* = 0.31).

*(In the Sheet, `goal_set_date` is imbalanced 44% vs 22%, p = 0.019. Standardising
for it moves the estimate only from +30 pp to +28.6 pp, so it does not explain the
result — but it is either a randomisation failure or an early treatment effect,
and the Sheet cannot tell you which.)*

## Four reasons not to act on the +30 pp

**1 · The measurement window has not closed.** Every week-5 user signed up
2026-05-04. Day 7 is 2026-05-11. **The last date anywhere in the dataset is
2026-05-08.** The `day_7` flag for the entire treated cohort refers to a date the
data does not cover. It was asserted, not observed.

**2 · The effect is not where the mechanism requires it to be.**

| Subgroup | Treatment | Control | Difference | *p* |
|---|---|---|---|---|
| **Breakers** — can see the screen | 50% (n=20) | 28% (n=25) | +22 pp | **0.13** |
| **Non-breakers** — cannot see it | 93.3% (n=30) | 64% (n=25) | **+29.3 pp** | **0.007** |

The effect is larger and the only significant one in the group the feature cannot
reach. *Caveat on my own argument:* `broke_streak_week1` only flags week-1 breaks,
so a "non-breaker" could have broken later — though all four sends land on days
2–5, inside week 1, which makes that explanation strained.

**3 · Control was exposed.** Eight control users have `comeback` screen sessions.
Control should never see it. Separately, 22 of 30 comeback-arm *non-breakers* also
have one — so the trigger is firing more broadly than a break.

**4 · The study could only ever detect an implausible effect.** At n=50/50 and a
46% control rate, the minimum detectable effect at 80% power is **+27.9 pp**. The
observed effect is +30 pp — sitting just past the threshold. The CI runs from
+11.8 to +48.2 pp. A +48 pp retention lift from a notification redesign is not a
credible quantity. Within breakers alone the MDE is roughly **+59 pp**, so that
subgroup was never going to produce a readable answer.

## What it means for the decision

*Confidence: the direction is plausible; the magnitude is not usable.*

This experiment does not establish that the Comeback screen improves retention.
It is underpowered by construction, measured past the end of its own data, shows
its effect in the unexposed group, and has contamination in control.

Against the **>50% Day-7 within 4 weeks** target, this cannot be cited as
evidence the target is reachable. Treating it as a pilot that "worked" is exactly
the pressure CLAUDE.md flags — an approved direction turning a gate into a
formality.

---

# Q4 · Did the Comeback open rate improve across the 4 sends?

## SQL

```sql
SELECT
  send_number,
  SUM(CASE WHEN variant = 'comeback' THEN 1 ELSE 0 END)      AS trt_sent,
  SUM(CASE WHEN variant = 'comeback' THEN opened ELSE 0 END) AS trt_opened,
  ROUND(100.0 * SUM(CASE WHEN variant = 'comeback' THEN opened ELSE 0 END)
              / SUM(CASE WHEN variant = 'comeback' THEN 1 ELSE 0 END), 1) AS trt_open_pct,
  ROUND(100.0 * SUM(CASE WHEN variant = 'control'  THEN opened ELSE 0 END)
              / SUM(CASE WHEN variant = 'control'  THEN 1 ELSE 0 END), 1) AS ctl_open_pct
FROM comeback_sends
GROUP BY send_number
ORDER BY send_number;
```

Send rows are not independent — four per user — so the honest test uses the user
as the unit:

```sql
WITH per_user AS (
  SELECT user_id, variant,
         SUM(opened)                             AS opens,
         MAX(CASE WHEN opened THEN 1 ELSE 0 END) AS any_open
  FROM comeback_sends
  GROUP BY user_id, variant
)
SELECT variant AS arm, COUNT(*) AS users,
       ROUND(AVG(opens), 2)           AS mean_opens_per_user,
       ROUND(100.0 * AVG(any_open),1) AS any_open_pct
FROM per_user GROUP BY variant;
```

## Plain English

First query: open rate per send, side by side by arm, to see whether attention
grows or decays. Second: collapse to one row per user first, because 400 send
rows come from only 100 people and treating them as independent overstates
significance.

## Result

| Send | Comeback | Control | Difference | *p* |
|---|---|---|---|---|
| 1 | 28% (14/50) | 4% (2/50) | +24 pp | 0.001 |
| 2 | 38% (19/50) | 4% (2/50) | +34 pp | <0.001 |
| 3 | 46% (23/50) | 4% (2/50) | +42 pp | <0.001 |
| 4 | **56%** (28/50) | 4% (2/50) | +52 pp | <0.001 |

**Yes — it improved, and monotonically.** Send 4 vs send 1 within treatment is
**+28 pp (*p* = 0.005)**; control is flat (+0 pp). That is the opposite of
novelty decay.

User-level: **1.68 vs 0.16 mean opens per user**; **92% vs 16%** opened at least
one. Of opened sends, **36.9%** were acted on in treatment versus **0/8** in control.

Corroborated independently by two other tables — `comeback` screen sessions in
week 5 run 81 across 42 treatment users vs 8 across 8 control users, and in the
nudges table:

| Nudge | Sent | Opened | Acted on |
|---|---|---|---|
| `comeback_screen` | 20 | **35%** | **50%** |
| `streak_lost` | 141 | 17.7% | **0%** |

**The old notification had a 0% action rate across 141 sends.** That is Tom's
interview quote showing up in the data — *"There was no way to recover it,
nothing. So I gave up."* There was no action to take.

## Two things to correct in how this gets described

**"The 4 sends" are not weekly.** In the local data they land on days **2, 3, 4
and 5** from signup — four consecutive days inside week 1, despite the column
being called `send_number` and the Sheet's equivalent being called `week_number`.
So "open rate climbed across 4 sends" means across four days, not four weeks.
*(In the Sheet they are genuinely weekly — days 1–7, 8–14, 15–21, 22–28 — which
means its sends 2–4 land after day 7 and cannot have affected day-7 retention at all.)*

**The control open rate is not real behaviour.** Exactly **2 of 50** on every one
of the four sends, from 8 distinct users. Real open rates do not repeat to the
unit. This is generated data, and the 4% control baseline should not be quoted as
a benchmark anywhere.

## What it means for the decision

*Confidence: strong within this dataset, and the most robust result of the four.*

People open the Comeback surface, they keep opening it, and they act on it — where
the old `streak_lost` notification produced literally zero actions. That supports
the **messaging and surface** change on its own merits, and it supports Lena's
research finding about streak-reset-as-punishment.

But note the arithmetic against Q3: send 1 reached a 28% open rate, and the
claimed day-7 lift is +30 pp. For the sends to have caused that lift, essentially
every single person who opened one would have to have been retained by it. That
is not a plausible conversion rate, and it is independent evidence that the +30 pp
in Q3 is not coming from this mechanism.

---

# What I would need to change the verdict

| # | Need | Why | Owner |
|---|---|---|---|
| 1 | Re-run week 5 with the **window closed** — day-7 and day-30 fully observed | The headline is currently measured past the end of the data | Raj |
| 2 | **Powered** test — roughly 700/arm to detect +10 pp at 80% power on a 46% base | +30 pp was the smallest effect this design could see | Raj |
| 3 | Effect restricted to **exposed breakers**, pre-registered | Mechanism requires it; current data contradicts it | Raj |
| 4 | Explain the **8 exposed control users** and the broad trigger firing | Contamination invalidates the comparison | Raj |
| 5 | **Query 1** on real Streakly data | Q2's decomposition suggests most of the decline is drift, not breaks | **unowned — still the gate** |

# Notes for the tracked files

- `01-orient/change_log.md` — new entry: metric analysis run 2026-09-17; the
  week-5 pilot does **not** support the retention claim; open-rate result does
  support the surface change.
- `01-orient/strategy.md` — the drift path moves from *"directional, two
  independent sources"* toward *"possibly the larger share of the decline"* on the
  Q2 decomposition. Still synthetic data, so this is a confidence shift, not a tier change.
- `02-research/decision-brief.md` — Marcus will see "+30 pp day-7" quoted
  somewhere eventually. Better that it comes with the four caveats attached.
- **Raj's ~2x churn figure:** this dataset puts the break-related churn relative
  risk at **1.24–1.34**, not 2x. Directional agreement, materially smaller
  magnitude. Worth one line in the brief.

# Method note

No SQL engine is available on this machine (no sqlite3, no working Python, no
DuckDB). The SQL above is the specification — the numbers were produced by
PowerShell aggregations written to mirror each query exactly. Two-proportion
z-tests with pooled standard error for *p*-values, unpooled for confidence
intervals; MDE at 80% power, two-sided α=0.05. Anyone with a warehouse should be
able to paste the SQL and reproduce the tables. `DATE_DIFF` is BigQuery syntax and
will need swapping for your dialect; the Sheet stores dates as serial numbers, so
they need casting first.
