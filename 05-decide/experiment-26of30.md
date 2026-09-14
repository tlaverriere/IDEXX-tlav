# Experiment Design — 26-of-30 Goal + Streak Freeze · **SUPERSEDED**

*Last updated: 2026-09-14*

> ## ⚠ Superseded 2026-09-14 — do not scope from the arms below
>
> The streak freeze has been **eliminated** and the quota reworked into a calendar-month goal with its own month streak. See `../01-orient/strategy.md`, **Candidate 3**.
>
> - **Obsolete:** the 2×2 factorial, the freeze arm, the sequencing debate, the fixed first-30-days window, and the "is 26 the right threshold" framing. With no second mechanic there is nothing to attribute, so this becomes a **two-arm test** — cheaper and faster than anything specified below.
> - **Still sound, reuse it:** the staged ladder (Stage 0 counterfactual replay → concept test → painted door → A/B), the guardrail thinking, the day-30-mechanic-versus-day-7-metric horizon mismatch, and the falsification conditions.
>
> A rewrite as a two-arm test of Candidate 3 is logged as a pending item in `../01-orient/change_log.md`.

**Status: draft, nothing was approved.** This was a test design for a **parked** candidate. It did not presume the candidate would be built, and writing it did not advance it past the Thursday problem-validation gate. Its purpose was to have an answer ready if Thursday asked "how would we know."

---

## What is being tested

An explicit quota goal — complete **26 of your first 30 days** — with four misses pre-granted rather than earned or purchased. Per Trevor, 2026-09-14: it sits **alongside** the streak freeze, and it does **not** replace the streak counter. All three coexist.

**Why it is distinct from everything else on the table:** the freeze and the Comeback screen are *repair* mechanics that fire at or after a break. A quota is a *framing* mechanic that changes the stated target from day 1 — the only candidate positioned upstream of the break, which is where our week-1 evidence points.

**The number 26 is an assumption, not a finding.** Treat the threshold as a parameter for Stage 0 to set. Designing around 26 before seeing the miss distribution is how a placeholder hardens into a requirement.

---

## Decompose before designing

Four separable claims with very different costs to test. Testing H2 first is the expensive mistake.

| | Claim | Cheapest adequate test |
|---|---|---|
| **H1** | Quota framing produces less week-1 anxiety than streak framing | Concept test (~1 week) |
| **H2** | It raises Day-7 retention | A/B (~6–8 weeks) |
| **H3** | It does not weaken habit formation for users who would have succeeded anyway | Guardrails inside the same A/B |
| **H4** | Pre-granted slack is what does the work, vs. earned or purchased | Only separable with a freeze arm |

---

## Stage 0 — Counterfactual replay (Raj, existing data, days not weeks)

**The gate. Run this before anything else.**

> Among users who churned after a streak reset, how many had **four or fewer total misses** in their first 30 days?

- Mostly **more** than four → the quota would not have retained them. Candidate is weak and nothing was built.
- Mostly **four or fewer** → strong prior — *and* it may show the **freeze is redundant**, because the quota would have absorbed the same misses.

**Second query, same pass:** the full distribution of misses across the first 30 days. Let the data pick the threshold rather than inheriting 26.

Runs on existing data, requires no new sources, and can rule out half the bundle before any build. This is problem-validation work, not solution design.

---

## Stage 1 — Concept test (~1 week, qualitative)

Put both framings in front of week-1 users and recently-churned users. Tests H1, which is the only claim our current week-1 evidence speaks to at all.

**Probe these three scenarios specifically — each is a known failure mode and each is free to test on paper:**

1. **The contradiction at the moment of a miss.** With the counter retained, a user still watches it reset to zero while the quota says they are fine. Does that read as reassurance or as mixed messaging? *Highest-priority probe.*
2. **Depleted slack.** "You have used 3 of your 4 spare days and it is day 8." Does this feel better or worse than a streak reset? If worse, the design needs rolling or regenerating windows before it is worth building.
3. **Legibility.** Can a new user state what success means, unprompted, after seeing onboarding? Three coexisting systems — counter, spare-day budget, freeze token — against a population already describing the product as "a chore instead of a game."

---

## Stage 2 — Framing-only painted door (optional, cheap)

Change onboarding copy and the stated goal to "aim for 26 of your first 30 days" while the existing streak accounting runs underneath. Isolates the *frame* from the *mechanics* and gives a directional read on H1/H2 without building quota logic.

Worth doing only if Stage 1 is encouraging and Stage 3 is more than a few weeks out.

---

## Stage 3 — The A/B

### Arms

Because the mechanics would ship together, control-vs-bundle shows whether the bundle works but **not which half did it** — and we would maintain both indefinitely without knowing if one is dead weight.

|  | No freeze | Freeze |
|---|---|---|
| **Streak only** | control | freeze only |
| **26-of-30** | quota only | both |

The quantity of interest is the **interaction**: do they compound, or is one redundant once the other exists? Interaction effects need materially more power than main effects.

**Cheaper alternative — sequence instead.** Quota first, since it targets the evidenced failure mode, then layer the freeze only if a gap remains. Slower to the full answer, far cheaper to the first one. **Recommended unless Raj's sizing shows the factorial is affordable.**

### Population

New-user cohorts only, randomized at signup. **Do not migrate existing users** — it confounds the read, and it is precisely what would cost us the long-streak segment.

### Metrics

- **Primary:** Day-7 retention (north star).
- **Secondary:** Day-14 and Day-30 retention, days-active-in-first-30, lesson completions.
- **Guardrails (H3 is the real risk):** habit-strength proxy such as time-of-day consistency; notification opt-out rate; engagement among high-consistency users specifically.

The plausible bad outcome is **anxiety down, habit down** — week 1 becomes pleasant and the daily ritual never forms. Our retained-user interview describes a *daily* ritual and a 30-day celebration as the inflection point; a mechanic that permits skipping may erode the cue that produced her.

### Sample and duration

- Raj to compute **minimum detectable effect before commitment.** Detecting a 9-point swing and a 2-point swing require very different N, and four arms split the sample.
- **Horizon mismatch is structural:** the mechanic resolves at day 30, the north star reads at day 7. Expect a Day-7 signal early and a full answer in roughly 6–8 weeks including cohort accumulation.

---

## What would falsify this

- **Stage 0:** churned users mostly exceeded four misses.
- **Stage 1:** the depleting budget reads as more stressful than a reset, or users cannot state what success means.
- **Stage 3:** Day-7 up while Day-30 or habit-strength is down — early comfort bought at the cost of habit.

---

## One structural advantage worth noting

A randomized test on new users **does not require resolving whether v2 caused the decline.** Randomization handles the confounds that `strategy.md` condition 1 is currently stuck on. The causality question still matters for understanding the problem, but not for answering "does this fix work."

That is an argument for moving toward experiment rather than continuing to litigate causality — but it is not an argument for skipping the problem-validation gate, because an experiment can only tell us whether *this* fix moves the metric, not whether we picked the right problem.

---

## Dependencies and open items

| Item | Owner | Status |
|---|---|---|
| Stage 0 counterfactual replay | Raj *(proposed, unassigned)* | Not started |
| Miss-distribution query to set the threshold | Raj *(proposed, unassigned)* | Not started |
| Minimum detectable effect / sizing for factorial vs. sequenced | Raj *(proposed, unassigned)* | Not started |
| Concept-test script and recruiting | Lena *(proposed, unassigned)* | Not started |
| Decide: factorial or sequenced | Trevor + Marcus | Open |
| Resolve slack double-counting rule | Unassigned | Open |

**Nothing above is assigned.** Owner suggestions reflect who contributed adjacent work, not agreed assignments.
