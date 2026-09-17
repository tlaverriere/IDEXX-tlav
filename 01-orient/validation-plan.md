# Validation Plan — The Problem Statement

*Created 2026-09-14. **Status: Query 1 assigned to Raj 2026-09-17, due Wednesday 2026-09-23 — handoff at `../docs/query1-handoff.md`. Queries 2 and 3 and the interview plan remain unassigned.***

**What this is for.** `../05-decide/counterfactual-replay.md` tests whether a *solution* would have worked. This tests whether the *problem* is real and is where we think it is. Different question, different owner-set, and this one comes first.

---

## The reframe this plan rests on

**"Validate the problem" is not the same as "prove v2 caused it."** We have been treating the causality check as blocking everything — `change_log.md` literally lists it that way — but it is not the load-bearing question.

The load-bearing question is: **is the loss where we think it is, and is the mechanism what we think it is.** You can fix a problem without knowing its origin. You cannot fix a problem that isn't where you think it is.

Causality still matters — it tells us whether we are treating a symptom of a different disease — but it is **not on the critical path to a fix**, because a forward experiment on new users is randomised and answers "does this work" regardless of what broke it.

---

## The problem statement is four claims, not one

> *Breaking a streak reads as failure — the counter resets, the app doesn't acknowledge it, and the "you lost your streak" push lands at peak quit risk — so users go passive with no graceful way back.*

| | Claim | Status | Test |
|---|---|---|---|
| **A** | The 9-point loss sits with users who break a streak in week 1 | Unvalidated — rests on Raj's unreviewed figure | Query 1 |
| **B** | v2 caused the decline | Not established — correlation in time only | Query 2 |
| **C** | The mechanism is the reset and/or the notification | Documented but qualitative — Lena plus n=3 | Query 3, then interviews |
| **D** | Churn also occurs with no break at all (drift path) | Directional — two independent sources | Query 1 |

---

## Query 1 — Decompose the nine points · **the one that isn't on the board yet**

Everything currently listed as pending is either the causality check, Raj's figure, or the solution replay. **Nothing asks where the nine points actually sit.** This is a different question from Raj's — his is *churn given two misses*; this is *where the decline lives*.

**Specification.** For the pre-decline cohort (Day-7 = 48%) and the current cohort (Day-7 = 39%), split new users by week-1 behaviour:

- **(a)** Started a streak and broke it within 7 days
- **(b)** Started a streak and did not break it within 7 days
- **(c)** Never established a streak at all

For each segment, in both periods: share of cohort, and Day-7 retention within the segment.

**Then attribute the 9-point move between two causes:**

1. **Segment mix shifted** — more users now landing in (a) or (c)
2. **Retention fell within a segment** — the same behaviour now retains worse

**This distinction may reframe the entire project.** If the decline is mix-driven — more users failing to establish a streak at all — then it is an onboarding or acquisition story, not a reset story, and **neither candidate addresses it.** That possibility is currently unexamined.

Answers claims A and D at once. Runs on the same data as the replay.

### Query 1b — Miss-count distribution within segment (a) · *added 2026-09-17*

**Specification.** For segment (a) — started a streak and broke it within 7 days — report the distribution of **distinct missed days in the first 7**, bucketed:

```
0  ·  1  ·  2  ·  3  ·  4  ·  5+
```

Both periods, share of segment and Day-7 retention within each bucket.

**Why it is nearly free.** Same cohort, same window, same table as Query 1. It is one additional `GROUP BY` on a query that has to run regardless. **And Raj has already built the segment** — his *"~2x churn after two consecutive missed days"* finding is defined on the ≥2-miss population. His cut was ≥2 *consecutive*; this needs ≥2 *total*, which is a looser filter on the same logic.

**What one distribution yields, all at once:**

| Output | Read from |
|---|---|
| **Addressable audience for Candidate 1** | Buckets 2–4. A week-1 user's seeded freeze absorbs one missed day, so the daily streak breaks on the **second** |
| **Memento-fallback share** | Bucket 5+. Both streaks dead — the state the design was built to avoid leading with |
| **Users the Freeze fully protects** | Buckets 0–1. These users never see the Comeback screen at all |
| **Size of the day-8 cliff** | Week 1 tolerates 4 misses; week 2 tolerates 1 once the bank is spent |
| **A sanity check on Raj's figure** | Churn by miss count, rather than one aggregate ratio |

**What it answers.** Not one of the four claims — it answers **condition 5 in `strategy.md`**: *enough users break through protection to justify Candidate 1.* Currently bounded only at **0–36.2% of new signups**, because **Candidate 3's freeze is designed to prevent the event Candidate 1 responds to.** If the distribution concentrates in bucket 1, Candidate 1 has no audience.

**Note the boundary this sits on, because the plan draws one.** §"What this plan does not do" says this plan must not test whether either candidate *would work*. **This does not test efficacy — it sizes an audience**, which is a scoping question, not an outcome question. The distinction matters: the discipline exists to stop us optimising a solution for a mislocated problem, and counting how many users a surface could ever reach does not do that.

**It also improves the sequencing.** The plan holds the counterfactual replay until Query 1 confirms the problem's location. Putting this inside Query 1 means **the audience number arrives before the replay** — so if it lands near zero, the replay never needs to run for Candidate 1 at all.

### Query 1c — What the leak costs in acquisition spend · *added 2026-09-17*

**Why it is here.** Marcus has asked *"what is the cost of waiting another quarter?"* **three times**, and his profile records it as the one item *"partly answered, never quantified."* We have the qualitative argument — 28% YoY MAU growth hides a 9-point Day-7 decline at the top line while raising the spend needed to hold flat. We have never produced the number. It is attached here because Query 1 already computes everything on the product side.

**Specification — two parts, and only one of them is ours.**

| Part | Input | Source |
|---|---|---|
| **Volume** | Users lost per week to the 9-point decline: new signups/week × 9pp, and the same figure by segment from Query 1 | **This query.** Same cohort, same window |
| **Unit cost** | Blended CAC, or CAC by acquisition channel | **Not in product data — needs finance or growth.** **Owner still needed** — not Raj.|

**Report as:** weekly and annualised replacement cost of the decline, stated by channel if channel CAC is available, with the CAC source and date labelled.

**Honest scoping.** Unlike 1b this is **not free** — the volume half is a byproduct of Query 1, the cost half is an external input we have to go and ask for. It is included because the alternative has been carrying it as a standing open question for four weeks, and because *"I don't have it"* has now been said to Marcus three times. **One request to finance closes it.**

---

## Query 2 — Confound sweep on v2

- **Release log** for the v2 window: what else shipped within ±2 weeks?
- **Acquisition mix** by channel, source and campaign, pre versus post. A worse-quality cohort lowers Day-7 with no product cause at all.
- **Seasonality**: the same calendar window in the prior one or two years.
- **Platform split**: did the decline appear on iOS and Android simultaneously? A staggered store rollout is a natural experiment.

**Ask this before designing anything: was v2 A/B tested before launch, or rolled out in stages?** If either is true, a causal answer already exists in the data and this stops being hard. That single question is worth asking before any study is scoped.

If none of the above yields a comparison, **say so and stop.** Causality may be genuinely unanswerable here, and that is an acceptable outcome — see the bar below.

---

## Query 3 — Last-action sequence · the cheap discriminator

For week-1 churners who broke a streak:

- Did they open the app *after* the miss? Yes or no.
- Was the "you lost your streak" push delivered? Was it opened?
- If they opened the app, what did they do — nothing, one lesson, immediate bounce?
- Time from reset to final session.

**What each pattern implicates:**

| Pattern | Reading |
|---|---|
| Never reopened after missing | The **notification** and the absence of a reason to return. The cheap fast track may be the actual fix. |
| Reopened, did nothing, left | The **reset screen**. Candidate 1's territory. |
| Reopened, completed a lesson, then left | **Neither.** The reset moment is not the failure point and the whole frame needs revisiting. |

This answers "reset versus notification versus both" — the question Thursday must resolve — from logs rather than from opinion. That third row is the one nobody has considered.

---

## Item 4 — Week-1 interviews

**8–12 users in their first week**, and critically: **deliberately include users who never broke a streak.** We currently have exactly one week-1 voice, and she is the single most consequential and least tested claim we hold.

Sample both week-1 churners and week-1 survivors so there is a comparison. Probe what they expected, what made them hesitate, and what the streak meant to them around days 3–5 — not reactions to any proposed solution. This validates the problem; solution reactions belong in a separate concept test.

Owner: Lena. Roughly 1–2 weeks, the only item here that is not days.

---

## Pre-register the kill conditions

Agree these **before** results land, or the frame will survive whatever comes back.

- **Under ~40% of the loss sits with week-1 streak breakers** → the frame is wrong.
- **Most week-1 churners never broke a streak** → drift is the problem, and both candidates are aimed at the wrong thing.
- **Most week-1 churners never reopened after missing** → it is the notification, and Fast track 1 is the actual fix rather than a side bet.
- **The decline is mostly mix-shift into segment (c)** → this is an onboarding problem and the streak mechanic is a red herring.

*(The ~40% threshold is a proposal, not a standard. Trevor and Marcus should settle it.)*

---

## What "validated" should mean — set an achievable bar

Claim C can never be fully validated by data. *"The reset feels like punishment"* is a claim about experience; the honest ceiling is **"consistent with the evidence,"** not "proven."

This matters because an impossible bar produces paralysis and then capitulation — the room cannot meet it, so it builds anyway and calls it a judgment call.

**Proposed bar:**

| Claim | Standard to clear |
|---|---|
| A and D | **Validated** from data, or the frame is abandoned |
| C | **Corroborated** qualitatively — consistent across logs and 8–12 interviews |
| B | **Attempted, and abandoned if unanswerable.** Not a blocker. |

Queries 1–3 are days of work on existing data. The interviews are the long pole. That is an achievable bar inside roughly a week for the data half.

---

## What this plan does not do

It does not test whether Candidate 1 or Candidate 3 would work — that is the counterfactual replay, and it should not start until Query 1 confirms the problem is where we think it is. **Running the replay first risks optimising a solution for a problem we have mislocated.**

**One amendment, 2026-09-17.** Query 1b sizes Candidate 1's addressable audience, which is closer to the solution than the rest of this plan goes. It is included deliberately and the line still holds: **sizing who a surface could reach is not testing whether it works.** The boundary this plan defends is against tuning a solution to a problem we have mislocated, and a headcount cannot do that. It earns its place by being free — one `GROUP BY` on a query that must run anyway — and by arriving *before* the replay, so a near-zero audience saves the replay for Candidate 1 entirely.
