# Experiment Design — Comeback Screen, Day-7 Retention

*2026-09-17 · Trevor Laverriere · supersedes the arms in `05-decide/experiment-26of30.md`*

**Purpose.** Pressure-test the week-5 pilot result and specify the full test that
would actually substantiate the >50% Day-7 target.

---

# 1 · Is the pilot result significant?

**What significance means for a go/no-go decision:** it tells you how likely you
are to see a gap this large when the true gap is zero — and nothing else, in
particular nothing about how *big* the real effect is or whether your feature
caused it.

## Result

| | Treatment | Control |
|---|---|---|
| Retained at day 7 | 38 / 50 (**76%**) | 23 / 50 (**46%**) |

| Statistic | Value |
|---|---|
| Difference | **+30.0 pp** |
| Pooled proportion | 0.61 |
| Standard error (pooled) | 0.0976 |
| **z** | **3.075** |
| **Two-sided *p*** | **0.0021** |
| 95% CI on the difference | **[+11.8 pp, +48.2 pp]** |
| **Significant at 95%?** | **Yes** |

## What it means in plain English

If the Comeback screen truly did nothing, a gap this large would show up about
**2 times in 1,000** runs. So the gap is very unlikely to be zero.

**That is the only thing this establishes, and it is not the thing we need.** Three
reasons it does not license a scaling decision:

1. **The confidence interval runs from +12 pp to +48 pp.** A "significant" result
   here is compatible with an effect four times larger than the one we would plan
   around. Significance answers *is it non-zero*; the interval answers *how big*,
   and the interval is uselessly wide.
2. **Significance cannot tell you what caused the gap.** From
   `metric-diagnosis.md`: **17.6 of the 30 points come from users who never saw the
   screen**, 8.8 from the users it targets, 3.6 from the arms having different
   break rates. The test is significant *and* the majority of the effect is
   unattributable.
3. **The outcome was never observed.** No user in the dataset has a session after
   day 4, so every `day_7` flag is asserted rather than measured.

**Verdict: statistically significant, and not trustworthy.** Those are not a
contradiction — significance is a necessary condition being mistaken for a
sufficient one.

---

# 2 · Minimum detectable effect

**What MDE means:** the smallest true effect a test is big enough to reliably
find — anything smaller and the test will probably miss it even though it is real.

**Why a PM sets it first:** MDE is what determines sample size, so it has to be
chosen from what would change your decision. Set afterwards, it stops being a
design input and becomes a justification for whatever you happened to measure.

## MDE for this test: 5 percentage points

**Why 5 pp is the right bar here.** The target is >50% Day-7 against a 46%
baseline. A 5 pp lift clears it; a 3 pp lift does not. So 5 pp is the smallest
effect that changes the answer to the question we are actually asking.

## What the pilot could detect

| Design | Baseline | MDE at 80% power |
|---|---|---|
| **Pilot (n=50/arm)** | 46% | **±27.9 pp** |
| Full test (n=1,568/arm) | 46% | ±5.0 pp |

**The pilot could only ever have found an effect of roughly 28 pp or larger, and
it reported 30 pp.** A design that can only see implausible effects will, when it
sees anything, report an implausible one. This is the single clearest reason not
to plan around the pilot's magnitude.

---

# 3 · Sample size

**What statistical power means:** the chance the test finds a real effect when one
genuinely exists. At 80% power, a real 5 pp effect gets detected 4 times in 5 —
and missed 1 time in 5.

**What we risk if power is too low:** we ship a **false negative** — we conclude
"no effect," kill a feature that worked, and the result looks like evidence rather
than like a measurement failure. An underpowered test is worse than no test,
because it produces a number that feels like an answer.

## Calculation

Inputs: baseline 46%, target 51%, power 80%, significance 95% two-sided.

```
n per arm = ( z(0.975)·√(2·p̄(1−p̄))  +  z(0.80)·√(p₁(1−p₁)+p₂(1−p₂)) )²  ÷  (p₁−p₂)²

          = ( 1.960·√(2·0.485·0.515) + 0.842·√(0.46·0.54 + 0.51·0.49) )² ÷ 0.05²
          = ( 1.385 + 0.594 )² ÷ 0.0025
          = 1,568 per arm
```

**≈ 1,570 per arm · 3,140 total.** Verified by back-calculation: achieved power at
this n for a true 5 pp effect is **79.9%**.

## How sensitive this is to the MDE

| MDE | Per arm | Total |
|---|---|---|
| 2 pp | 9,775 | 19,550 |
| 3 pp | 4,349 | 8,698 |
| **5 pp** | **1,568** | **3,136** |
| 7 pp | 800 | 1,600 |
| 10 pp | 392 | 784 |

Halving the MDE roughly quadruples the sample. This is why the MDE is a business
decision, not a statistical one.

## The design choice that actually matters: whom do we measure?

The Comeback screen only fires on a break. If we measure everyone, the effect gets
diluted by the ~60% of users who never see it.

| Design | Primary population | Signups needed per arm | Total |
|---|---|---|---|
| **(a)** | All new signups, 5 pp on the full cohort | 1,568 | **3,136** |
| **(b)** | **Breakers, 5 pp among breakers** | 3,920 (at a 40% break rate) | **7,840** |
| (c) | Everyone, powered to see a 5 pp breaker effect diluted to 2 pp | 9,775 | 19,550 |

**Recommended: (b), with (a) as a secondary read.** Enrol every new signup, but
**pre-register breakers as the primary population** and the full cohort as
secondary. Rationale:

- (a) is cheapest but answers the wrong question — a null could mean the feature
  failed *or* that it worked on 40% of users and got averaged away.
- (c) is the statistically purest way to keep a single whole-cohort readout, and at
  19,550 users it is 6× the cost of (b) for the same insight.
- (b) tests the mechanism on the population the mechanism acts on, which is also
  what `metric-diagnosis.md` H1 requires.

**Pre-registration is what makes (b) legitimate.** Choosing the breaker subgroup
after seeing the data is exactly how the pilot's +30 pp happened.

---

# 4 · Duration

## The constraint that was not in the brief

**Day-7 retention is a new-signup metric. WAU is not the enrolment pool.** The
85,000 WAU figure counts existing users, and an existing user has no day 7. The
number this test is actually rate-limited by is **new signups per week**, and that
figure is not in anything we hold.

Both readings, so the decision does not wait on the gap:

### Reading 1 — if 85,000 really is the weekly eligible pool

| Design | Enrolment needed | Share of one week | Enrolment time | Total elapsed |
|---|---|---|---|---|
| (a) | 3,136 | 3.7% | < 1 week | **~2–3 weeks** |
| **(b)** | **7,840** | **9.2%** | **< 1 week** | **~2–3 weeks** |

Total elapsed = 7-day rolling launch + under a week of enrolment + 1 week for the
last cohort to reach day 7. **Fits inside 8 weeks with five weeks to spare.**

### Reading 2 — the break-even, if the pool is new signups only

Reserving 1 week for day-7 maturation leaves 7 weeks of enrolment:

| Design | Minimum new signups per week to fit in 8 weeks |
|---|---|
| (a) | **448** |
| **(b)** | **1,120** |
| (c) | 2,793 |

Weeks required for the recommended design (b) at various real rates:

| New signups / week | Weeks needed | Fits in 8? |
|---|---|---|
| 200 | 41 | No |
| 500 | 17 | No |
| 1,000 | 9 | **No — misses by one week** |
| 2,000 | 5 | Yes |
| 5,000 | 3 | Yes |

## Answer

**Yes under reading 1, and conditionally under reading 2.** The test fits in 8
weeks if and only if we enrol **≥1,120 new signups per week**. At 1,000/week it
misses by a single week, which makes this a genuinely live threshold rather than a
comfortable one.

**One question to Raj closes this: what is our weekly new-signup volume?** Until
it is answered, the 8-week commitment is unconfirmed. If the rate turns out to sit
below 1,120, the options are to fall back to design (a) at 448/week, relax the MDE
to 7 pp, or extend past 8 weeks — in that order of preference.

---

# 5 · The decision

**Recommendation: wait for the full test on streak accounting, and scale the
notification and surface change now.** The "wait or scale" framing has a false
premise — these are two changes with two different evidence bases, and they can
move independently. That split is already the proceeds/holds structure Marcus
approved.

| | Scale now | Wait for the full test |
|---|---|---|
| **Notification + Comeback surface** | **Do this.** Evidence: 100% vs 14% return rate, and the current notification has a 0% action rate across 141 sends. Reversible, no streak-state migration | — |
| **Production streak accounting** (freeze bank, weekly goal, miss bank) | — | **Do this.** Touches 2.1M users' streak state, a revert does not un-corrupt it, and the only supporting evidence is a result whose majority share is unattributable |

## Risk of each path, one sentence each

- **Risk of waiting:** we spend 8 more weeks on a leak we still cannot price in
  acquisition spend, while three features get built against a problem statement our
  own decomposition says explains under a fifth of the decline.
- **Risk of scaling now:** we migrate streak state for 2.1M users on a 50-per-arm
  result where under a third of the effect is attributable to the feature and day-7
  was never actually observed — and if it is wrong, the revert does not restore the
  streaks.

**Why waiting wins:** the two risks are not symmetric. Waiting costs time on a
decline that is already four weeks old and is invisible at the top line because MAU
grows 28% YoY. Scaling wrong costs 2.1M users' streak history, irreversibly, on
the one mechanic our own research says is experienced as punishment.

---

# 6 · Leading indicators to monitor weekly

**Read this first: monitoring is not testing.** Checking the primary metric weekly
and stopping when it looks good inflates the false-positive rate well past 5% —
peek 8 times at α=0.05 and the real error rate is roughly 20%. These three are
**operational safety checks**, for catching a broken or harmful rollout. The
go/no-go decision happens once, at the pre-registered end. Any early stop must be
for **harm**, against a pre-registered guardrail, never for good news.

## 1 · Reached-and-returned rate among breakers

*Of users who broke a streak, what share were actually delivered the prompt, and
what share returned within 48 hours.*

**Why:** this is the mechanism's proximal outcome and the only thing the pilot
established cleanly. It also folds in the deliverability gap — **QA checklist P1:
if push is off, the surface is unreachable and there is no in-app fallback.**

**What would make me nervous:**
- **Treatment return rate less than control + 10 pp by week 2.** The pilot showed
  100% vs 14%. Anything near parity means the mechanism is not firing at all, and
  we would be running seven more weeks of a test of nothing.
- **Reached share below ~60%.** Then we are measuring a notification-permission
  problem wearing a retention feature's clothes, and the honest fix is an in-app
  entry point, not more weeks of data.

## 2 · Streak-rebuild rate among returners

*Of users who returned via the Comeback surface, what share hold a live streak of
≥1 seven days later.*

**Why:** this is **H1** from `metric-diagnosis.md`, the hypothesis I recommend
testing first — the screen may win the visit and lose the week. In the pilot,
**100% of treated breakers returned and 50% churned anyway.** This metric is the
difference between those two numbers, measured directly.

**What would make me nervous:**
- **Rebuild rate below ~40% while the return rate stays high.** That is H1
  confirming: we are buying visits that do not convert, and the fix is a product
  change (something live to rebuild toward), not more traffic.
- **A rebuild rate that starts high and decays week over week.** That would point
  at the mechanic rather than the surface — the freeze and miss banks emptying,
  leaving later cohorts with less protection than earlier ones. Note the day-85
  protection cliff already recorded in `strategy.md`.

## 3 · Notification-disable rate and non-breaker engagement

*Push opt-outs per arm, plus weekly sessions among users who have **not** broken a
streak.*

**Why:** this is the harm guardrail, and it is pointed at our two best-evidenced
risks. Amara — our only week-1 interviewee — said the prompt would make her **more**
likely to leave, and the NPS set already contains someone who disabled all
notifications after three in one afternoon. Non-breakers are also where the
pilot's unexplained +17.6 pp sits, so this arm needs watching for a different
reason: we do not know why that group moved.

**What would make me nervous:**
- **Any sustained excess disable rate in treatment over control.** Not a
  threshold — *any* gap. Opting out of notifications is irreversible in practice
  and it removes the only entry point the feature has, so this defect compounds
  rather than washing out.
- **Non-breaker weekly sessions falling in treatment.** That is the pressure
  mechanic doing harm to users it was never meant to touch, and it is the one
  outcome that should stop the test early.

---

# Design summary

| Parameter | Value |
|---|---|
| **Primary metric** | Day-7 retention |
| **Primary population** | Week-1 streak breakers (**pre-registered**) |
| Secondary population | All new signups |
| Baseline | 46% |
| **MDE** | **5 pp** (46% → 51%) |
| Significance | 95%, two-sided |
| Power | 80% |
| **Sample** | **1,568 breakers per arm ≈ 3,920 signups per arm · 7,840 total** |
| Allocation | 50/50, new signups only |
| **Duration** | **~3 weeks** if the weekly eligible pool is 85,000; **8 weeks requires ≥1,120 new signups/week** |
| Rollout | 7-day rolling launch, per the approved measurement design |
| Guardrail split | Existing users 50/50 — **safety only, cannot measure Day-7** |
| Kill switch | In scope; required before enrolment opens |
| Interim analyses | None for efficacy. Harm guardrails only, pre-registered |
| Blocking dependency | **Weekly new-signup volume — unanswered** |

## Pre-registered kill conditions

Stop and do not ship if any of these holds:

1. Non-breaker weekly sessions in treatment fall below control with a sustained gap.
2. Notification-disable rate in treatment exceeds control at any sustained level.
3. Reached share among eligible breakers stays below 60% after week 2 — the result
   would not generalise to a population we cannot reach.

## What this design does *not* resolve

**Query 1 still gates the release.** This experiment tests whether the feature
works. Query 1 tests whether the problem is the one the feature addresses — and
`metric-diagnosis.md` found that more users breaking streaks accounts for only 1.7
of a 10-point decline. **A successful experiment on the wrong problem is still the
wrong problem.** Query 1 remains unowned.
