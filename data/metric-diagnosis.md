# Metric Diagnosis — Day-7 retention

*2026-09-17 · Trevor Laverriere · companion to `metric-findings.md`*

> **One constraint governs everything below, and I found it while running this.**
> **No user in the dataset has a session after day 4.** Max observed session-day
> offset is **day 3** for cohorts 1–4 and **day 4** for cohort 5.
>
> So every `day_7` and `day_30` flag in `retention.csv` is an **assertion, not a
> measurement** — for all 500 users, not just week 5. Separately,
> `broke_streak_week1` is flagged for **190** users while the session log shows an
> observable week-1 gap for only **7**; they agree for **4**.
>
> The flag columns and the session log are effectively two unlinked datasets. The
> flags carry the signal; the sessions can only describe days 0–4. Everything here
> is diagnosis of a synthetic system, and confidence scores in §4 are scored
> against that.

---

# 1 · Metric tree

Day-7 retention is not one number, it is three populations with different rates.
The decomposition below is an **identity** — it closes exactly on the weeks 1–4
baseline (400 users, untreated).

```
Day-7 retention = 33.0%   (132 / 400)
│
├─ Never started a streak ........... 80 users (20.0%) · d7 33.8% → 6.8 pp
│     lever: STREAK-START RATE
│
└─ Started a streak ................ 320 users (80.0%)
      │   lever: STREAK-BREAK RATE (45.3% of starters break*)
      │
      ├─ Kept it ................... 204 users (51.0%) · d7 38.7% → 19.7 pp
      │
      └─ Broke it .................. 116 users (29.0%) · d7 22.4% → 6.5 pp
            lever: COMEBACK RATE  ← the conversion this feature targets
                                    gated by NOTIFICATION REACH
```
\* 116 of 320 starters (36.3%) carry the break flag; 145 users carry it overall,
so 29 non-starters are flagged as breaking something the session log never shows
them starting. Another symptom of the two tables not agreeing.

**The identity:**

```
D7 = (1 − start) · d7_nostart
   +  start · (1 − break) · d7_kept
   +  start · break       · d7_broke

   = 0.200 × 33.8%  +  0.800 × 0.6375 × 38.7%  +  0.800 × 0.3625 × 22.4%
   = 6.76 pp        +  19.74 pp                +  6.50 pp        =  33.0%  ✓
```

## Which levers actually move the number

Moving each lever **10 pp in the favourable direction**, holding the others:

| Lever | Current | → | Day-7 impact | Verdict |
|---|---|---|---|---|
| **Comeback rate** (d7 among breakers) | 22.4% | 32.4% | **+2.9 pp** | **Highest leverage** |
| **Streak-break rate** (among starters) | 36.3% | 26.3% | **+1.3 pp** | Half the leverage |
| **Streak-start rate** | 80.0% | 90.0% | **−0.1 pp** | **No leverage at all** |
| **Notification opt-in** | *no such column exists* | — | not estimable | See below |

**The streak-start finding is the surprise and it is the most useful thing in this
tree.** Starting a streak barely predicts Day-7 retention: users who never started
retain at **33.8%**, users who started retain at **32.8%**. Pushing more people
into a streak moves Day-7 by approximately **nothing**, because the two groups
retain the same. Any onboarding work aimed at "get more users to start a streak"
is aimed at a lever with no arm.

**Comeback rate is the real lever, and it is the one the feature targets.** That
is the strongest argument in the data *for* the Comeback screen — not the +30 pp.

**Notification opt-in cannot be modelled: there is no opt-in, permission or
deliverability column anywhere.** The nearest proxies:

| Proxy | Value |
|---|---|
| `streak_lost` open rate | 17.7% (25/141) |
| `comeback_screen` open rate | 35% (7/20) |
| **Did opening a nudge predict Day-7?** | **No — −6 pp, *p* = 0.49** |

That last row matters more than the other two. **Attention did not convert to
retention.** It is the same warning as the open-rate arithmetic in
`metric-findings.md` Q4, arrived at from a different direction: reach is a
necessary condition being measured as if it were a sufficient one. If we ship
instrumentation for this feature, **an opt-in/permission field is the missing
column** — P1 in the QA checklist is currently unmeasurable.

---

# 2 · What caused the decline in weeks 1–4

Day-7 fell **37% → 37% → 31% → 27%**, a 10-point drop. Here is what it was *not*,
each ruled out with a number, because the generic answers are all available and
all wrong.

## Ruled out

| Candidate cause | Evidence it is not this |
|---|---|
| **Acquisition mix shifted** | Channel split is **identical every week**: 34 organic / 34 paid / 32 referral. Standardising week 4 to week 1's mix explains **0.0 pp** of the −10 |
| **Platform mix shifted** | Identical every week: 60 iOS / 40 Android, no web |
| **Onboarding broke** | Day-1 activation is **flat at 91–93%** across all five cohorts |
| **Goal-setting dropped off** | **100%** of users in every cohort set a goal |
| **Users engaged less** | **3.2 sessions/user in every week.** Mean duration 232 / 242 / 233 / 229 s. Distinct week-1 active days: 3.2 every week |
| **Users engaged differently** | Screen mix flat — lesson 34/31/33/32%, streak 35/33/34/33%, home 31/36/32/35% |
| **Fewer people started a streak** | **Exactly 80 of 100 started, every single week** |

Volume, mix, activation and depth are constant. **Nothing about how much people
used the product changed.** The outcome changed.

## Ruled in

**Cause 1 — more starters broke.** Break rate among starters climbed:

| | wk1 | wk2 | wk3 | wk4 |
|---|---|---|---|---|
| Break rate among starters | **28.7%** | 38.8% | **41.2%** | 36.2% |

**Cause 2 — and retention fell for people who did *not* break.** Decomposing the
−10 pp, from `metric-findings.md` Q2:

| Component | Contribution |
|---|---|
| More users breaking | **−1.7 pp** |
| Rates falling *within* groups | **−8.3 pp** |

Breakers stayed flat (23.1% → 22.9%). **Non-breakers fell 41.9% → 29.2%.** The
larger share of the decline is users who kept their streaks and left anyway.

**Cause 3 — it is channel-specific, and referral is untouched.**

| Channel | wk1 d7 | wk4 d7 | Change |
|---|---|---|---|
| Paid | 32.4% | **14.7%** | **−17.7 pp** |
| Organic | 41.2% | 29.4% | −11.8 pp |
| **Referral** | 37.5% | **37.5%** | **0.0 pp** |

Composition did not move, so this is not "more paid users" — it is **the same
share of paid users retaining half as well.**

## The specific story

*Same traffic, same volume of use, same start rate. More of those starts broke,
non-breakers got worse, and the damage landed entirely on paid and organic while
referral did not move at all.*

Two readings fit, and this data cannot separate them:

1. **Paid traffic quality degraded** over those four weeks (campaign or targeting
   drift). Referral is typically the highest-intent channel, which is consistent
   with it being immune.
2. **A product change hurt low-commitment users specifically.** Referral users
   arrive with a personal recommendation and absorb friction that paid users do not.

**Caveat, stated plainly:** these channel cells are **n=34 per channel per week**.
Paid's 14.7% is **5 users**. The direction repeats across weeks; the magnitude is
noise. Treat cause 3 as a lead to check on real data, not a finding.

**What this does *not* support: that a streak-break mechanic caused the decline.**
Break rate rose 7.5 pp and that accounts for 1.7 of the 10 points.

---

# 3 · What the week-5 split actually tells us

## What it fixed — and this is a real, clean effect

**The return visit.** Within the one window where both arms have data:

| | Has a day-4 session | `day_7` flag |
|---|---|---|
| **Comeback arm** | **50 / 50 (100%)** | 76% |
| **Control arm** | **7 / 50 (14%)** | 46% |

Restricted to breakers, same window:

| | Returned after the prompt | `day_7` |
|---|---|---|
| `comeback_screen` recipients | **20 / 20 (100%)** | 50% |
| `streak_lost` recipients | **4 / 25 (16%)** | 28% |

**The Comeback screen produced a next-day return for every treated user, against
14% of control.** That is the most defensible causal statement available here, and
it maps exactly onto **Gap 1** in `competitive-matrix.md` — the unowned return
visit. The old `streak_lost` notification has a **0% action rate across 141 sends**
and a 16% return rate. The new one gets people back.

*(The 100% is too clean to be behaviour — this is generated data. Read it as "the
screen moved the return visit decisively," not as a 100% conversion rate.)*

## What it did not fix, and what the +30 pp actually consists of

Decomposing the +30 pp Day-7 gap three ways (control as base):

| Source of the +30 pp | Contribution |
|---|---|
| **Non-breakers retaining better** — users the screen cannot reach | **+17.6 pp** |
| **Breakers retaining better** — the mechanism's actual target | **+8.8 pp** |
| **Arms having different break rates** (40% vs 50%) — randomisation artifact | **+3.6 pp** |
| Total | **+30.0 pp** |

**Under 9 of the 30 points are attributable to the mechanism at all.** The largest
single component is a group that never saw the screen.

So the honest summary of week 5:

| Claim | Status |
|---|---|
| The Comeback screen restores the return visit | **Supported** — 100% vs 14%, matched window |
| The return visit converts to Day-7 retention | **Not demonstrated.** Day-7 is unobservable — no session data past day 4 |
| The +30 pp is the Comeback screen working | **Contradicted** — 17.6 of 30 pp sits in unexposed users |
| The screen helps breakers specifically | **Weakly supported** — +22 pp, *p* = 0.13, n=20/25 |

**And the finding that reframes the feature:** 100% of treated breakers returned,
and **50% of them still churned by day 7.** The return is solved. What happens
after the return is not — which is the subject of §4.

---

# 4 · Four ranked hypotheses for why treatment users still churned

**Population:** 12 of 50 treatment users churned by day 7. Profile against the 38
retained:

| Attribute | Churned (12) | Retained (38) |
|---|---|---|
| **Broke streak in week 1** | **83.3%** | **26.3%** |
| Mean `current_streak` | **1.25** | **9.53** |
| Organic channel | 8.3% | 42.1% |
| Paid channel | 50% | 28.9% |
| Has a comeback session | 91.7% | 81.6% |
| Acted on ≥1 send | 50% | 55.3% |
| Active on day 1 | **100%** | 92.1% |
| Still opening the *last* send | 7 of 12 | 21 of 38 |

**Two things to note before the hypotheses.** Exposure is **not** the
differentiator — churners saw the screen slightly *more* than retained users
(91.7% vs 81.6%) and acted on it about as often. And there is **no engagement
decay before churn**: 7 of 12 churners opened send 4, the final one. They were
still paying attention when they left.

Isolating the 20 treatment users who broke — 10 churned, 10 retained — exposure is
literally identical (comeback session 10/10 in both), opens near-identical (9/10 vs
10/10), sessions 5.0 vs 5.3, duration 252 s vs 241 s. **The only attribute that
separates them is acquisition channel** (paid 6/10 vs 3/10; organic 1/10 vs 5/10).

---

## H1 — The screen restores the visit but not the streak *(rank 1)*

**Testable prediction:** Among treatment users who broke and returned, those whose
streak is still **0** at day 7 churn at **≥2×** the rate of those who rebuilt to
≥1. The Comeback screen wins the session and loses the week, because the returner
arrives at a counter that still reads zero and has nothing to rebuild toward.

**Confidence: 8 / 10.** The data already shows the mechanism half-working and
half-failing on the same users: **100% of treated breakers returned and 50%
churned anyway**, with exposure identical between the two halves. Whatever
separates them happens *after* the return, which is exactly what this predicts.
Held below 9 because streak-at-day-7 is not in the data, so the prediction is
consistent with the evidence rather than tested by it.

- **Confirms it:** streak value at day 7 for returners — churn concentrated in those still at 0.
- **Rules it out:** returners who rebuilt to ≥1 churn at the same rate as those still at 0.

**Why rank 1:** every breaker in the treatment arm has `current_streak` = 0, and
treatment non-breakers retain at 93.3% against breakers' 50%. Having a live streak
is the single strongest correlate of retention in the week-5 data. The screen
returns the user without returning the streak.

---

## H2 — Acquisition intent decides, and the screen cannot overcome it *(rank 2)*

**Testable prediction:** Paid-acquired treatment users churn at **≥2×** organic-acquired
treatment users **with exposure held constant** — the screen reaches both equally
and only changes the outcome for users who had intent to begin with.

**Confidence: 6 / 10.** The direction repeats in two independent places — within
the treatment arm (churners 50% paid / 8.3% organic) and across the untreated
baseline (paid −17.7 pp, referral 0.0 pp) — which is more than one slice of noise.
Capped at 6 because n=17 paid users in the treatment arm and 34 per channel per
week in baseline; paid's worst cell is 5 users.

- **Confirms it:** the paid/organic churn gap persists after controlling for break status and exposure.
- **Rules it out:** paid and organic churn equally once break status is controlled — i.e. channel was proxying for break rate all along.

**Why rank 2:** it is the only hypothesis with corroboration *outside* week 5, but
if true it is not a product fix, which is why it loses to H1 on actionability.

---

## H3 — The offer arrives before the break, so it reads as a warning *(rank 3)*

**Testable prediction:** Users whose first send landed **before** their break churn
more than users whose first send landed after it — a prompt that precedes the
failure functions as a deadline, not a rescue.

**Confidence: 4 / 10.** The timing anomaly is real and verified: sends land on days
**2, 3, 4, 5**, the `streak_lost` nudge fires on day **3**, and every observable
first-gap day is day **3** — so sends 1 and 2 precede the break. But break dates
exist for only **4** users, so the before/after split cannot be built from this
data at all. Scored on a verified mechanism with no measurable exposure.

- **Confirms it:** break timestamps showing send 1 preceded the break, with elevated churn in that group.
- **Rules it out:** break dates cluster on or before day 2, making every send genuinely post-break.

**Why this matters beyond the ranking:** this is **Amara's objection arriving as a
data artifact.** `change_log.md` already records her rejecting the pre-emptive
trigger as *"a deadline with good manners."* If the sends in this experiment were
in fact pre-break, then what the +30 pp measured was a pre-emptive prompt — the
thing we **cut from scope** — and not the Comeback screen at all.

---

## H4 — Repeat breaks: after a second reset the offer lands as noise *(rank 4)*

**Testable prediction:** Treatment users who broke **twice** churn at ≥2× those who
broke once; the first comeback offer is credible and the second is noise.

**Confidence: 2 / 10 — and the score is about the data, not the idea.**
`broke_streak_week1` is a boolean with **no count and no dates**, and **zero users
show 2+ session gaps in week 1**. Sessions run 3–6 rows per user across days 0–4.
There is no variable here that could support or refute this, so it cannot be ranked
above hypotheses the data speaks to. Mechanically it is the most plausible of the
four.

- **Confirms it:** a break-count field showing 2+ breaks with elevated churn among the exposed.
- **Rules it out:** break count uncorrelated with churn among exposed users.

**Instrumentation consequence:** we should ship a **break counter** with this
feature regardless of whether we test H4. It costs one column, it is the natural
input to the frequency cap already specified (*at most once per rolling 7 days*),
and without it this question stays unanswerable forever.

---

# 5 · Which one I would test first

**H1 — the screen restores the visit but not the streak.** Four reasons, in order.

**1 · The data already localises the failure.** Every other hypothesis needs a
field we do not have. H1 is the only one where the evidence already shows the
mechanism working and failing on the *same* users: 100% returned, 50% churned,
exposure identical. We are not guessing where the problem is — we know it is
downstream of the return, which is a far smaller search space than "why do people
churn."

**2 · It is one column and one sprint.** It needs streak value at day 7 for
returners. No new surface, no new experiment, no traffic. H2 needs a channel-controlled
re-run, H3 needs break timestamps we do not collect, H4 needs a break counter that
does not exist.

**3 · It is actionable whichever way it resolves.** Confirmed, the fix is a product
change we have already prototyped — give the returner something live to rebuild
toward, which is exactly what the week strip and spare days do. Refuted, it
promotes H2, and H2 resolving true means part of our retention problem is an
acquisition problem and belongs to a different team. Both outcomes change what
somebody does on Monday.

**4 · It forces the decision we have been deferring.** `spec-readiness.md` §4
records block earning as **unprotectable and invisible** — a user 27 days into a
perfect block loses it silently, and no progress meter ships. H1 predicts precisely
that a returner with nothing visible to rebuild toward leaves. That open question
and this hypothesis are the same question in different clothes, and confirming H1
would make it undeferrable. It is also Lena's call, which means testing H1 puts
evidence in front of the person who owns the answer.

**What I would not do first:** chase the +30 pp. It is the biggest number in the
deck and 17.6 of its 30 points sit in users who never saw the feature. Testing H1
tells us whether the mechanism works. Re-running week 5 at power tells us how big
a thing we already cannot explain.

## Caveat on the whole diagnosis

Every number here comes from synthetic data with no observable behaviour past day 4
and a streak flag that the session log corroborates for 4 of 190 users. This is a
diagnosis of a **plausible** system, useful for choosing what to instrument and
what to ask Raj. **It is not evidence about Streakly**, and it does not touch
Query 1 — which remains the gate, and still has no owner.
