# Counterfactual Replay — Analysis Spec

**For:** Raj · **From:** Trevor · **2026-09-14**
**Status: proposed, unassigned.** Nothing here is approved and no build depends on it.

---

## Why this exists

We have a candidate retention mechanic (Candidate 3 in `../01-orient/strategy.md`) whose every number is currently a guess. Rather than build it and find out, replay it against history: **take users who already churned, apply the proposed rules to their actual activity, and see whether the mechanic would have protected them.**

It runs on existing data, needs no new sources, and can do one of two useful things — kill the candidate before anyone builds it, or replace four guessed numbers with measured ones.

**This gates the candidate.** It is problem-validation work, not solution design, so it does not jump the Thursday gate.

---

## The mechanic to replay

Simulate this over each user's real daily activity. **Two layers now, not one** — the freeze changes the daily streak, so it is no longer a pass-through from today's product.

**Daily streak layer**

| Rule | Value |
|---|---|
| Daily streak | Consecutive days; resets on one miss **unless a freeze applies** |
| Freeze — seeded | **1 at the start of each of the first 3 four-week blocks** (days 1, 29, 57), then seeding stops |
| Freeze — earned | **1 per perfect 4-week block** (signup-anchored, zero misses) |
| Freeze cap | **7**. Anything earned or seeded while at cap is lost |
| Application | Automatic on a missed day |
| Scope | Protects the daily streak **only** — the day still counts as a miss against the weekly goal |
| Anti-loop | A frozen day does **not** count as perfect for earning |

**Weekly layer**

| Rule | Value |
|---|---|
| Weekly goal | Miss **at most 1 day** per week; weeks signup-anchored |
| Miss bank | Unused weekly misses accumulate, **cap 3**, applied automatically |
| Starting bank | **3** at signup, so week 1 has **4** misses available |
| Week streak | Consecutive weeks meeting the goal |

**What to simulate and what to leave out — the test is whether it needs a user decision.** Freezes and bank draws **auto-apply**, so they replay faithfully. The **last-gasp save requires an opt-in** we cannot infer from history, so leave it out. That makes every result below a **floor**: real reach is this, plus whatever the save adds.

---

## Definitions — two for you to pin down, one already settled

**1. What counts as a miss.** Please use whatever definition the current streak already uses — same timezone handling, same threshold for "completed." Apples-to-apples with the live counter matters more than picking the theoretically better definition.

**2. ~~What a "week" is~~ — settled.** Weeks are **signup-anchored**: days 1–7, 8–14, and so on. Week 1 therefore maps exactly onto the Day-7 window, and no user ever has a partial week. Please simulate it that way. **Flag it if signup-anchored windows are expensive to compute over history** — that's worth knowing before it becomes a build assumption as well as an analysis one.

**3. Your churn definition.** Whatever you normally use is fine; just state it, since Q1 depends on it.

**Cohort:** post-v2 users, since that's the current product. See Q5 for why a pre-v2 split is worth a look.

---

## The queries

### Q1 — Would the mechanic have protected users who churned?

Among users who churned after a streak reset, report **both**:

- **Q1a** — share whose **week streak** would still have been intact at the moment they went inactive.
- **Q1b** — share whose **daily streak** would still have been intact, i.e. a freeze was available and absorbed the fatal miss.

*Output:* two percentages plus the distributions behind them. They answer different questions — **Q1b sizes the Freeze feature, Q1a sizes the Weekly Streak** — and the two features are being considered separately as well as together, so please don't merge them.

### Q2 — How clustered are misses?

Distribution of consecutive-miss run lengths — 1 day, 2, 3, 4, 5+ — reported separately for **all users** and **churned users**.

*Why:* clustering is what weekly tolerance handles worst, and this is what should set the bank cap. If most runs are 1–2 days, a cap of 3 is generous. If 4–5 day runs are common, cap 3 under-covers and the number is wrong.

### Q3 — Week-1 miss counts · most important query

For users in their first 7 days: distribution of misses, split by those who reached day 7 and those who didn't.

*Why:* this tells us whether 4 available misses is about right or far more than needed. **If the median week-1 churner missed 5 or more of their first 7 days, no tolerance setting saves them and the problem isn't tolerance at all.** That would be the single most useful thing this analysis could tell us.

### Q4 — Day-8 cliff exposure

Of users still active at day 7, what share would have spent **all four** misses during week 1?

*Why:* those users enter week 2 with one miss and an empty bank — a four-fold tightening at day 8. Right now that risk is my speculation; this measures it.

### Q5 — The freeze bank · three sub-questions

**Q5a — Freeze availability at the fatal miss.** For users who churned after a reset: did they have a freeze available at that moment, and how many had they ever held? *If most had already spent theirs, three seeds are too thin. If most held one, the freeze is doing real work.*

**Q5b — Is a perfect 4-week block actually achievable?** What share of users ever complete **28 consecutive days with zero misses**? *This is the one that could make half the feature decorative. If almost nobody manages it, the earning mechanic never fires and only the three seeds matter — which would mean protection effectively stops at day 84 for everyone.*

**Q5c — The day-85 cliff.** Of users still active at day 85, what share have **never** completed a perfect block? Those users drop to zero daily-streak protection permanently once seeding ends. *Right now the size of that population is my speculation.*

### Q6 — Optional: pre-v2 vs post-v2 split

If cheap, run Q2 and Q3 split by pre- and post-v2 cohorts.

*Why:* it doesn't inform the mechanic, but it speaks to a different open question — whether v2 changed user behaviour at all. That's currently **not established** and blocks the whole frame. Skip if it adds real effort.

---

## Pre-register the interpretation before looking

So we can't retrofit a reading to whatever comes back. **These bands are a starting proposal, not an agreed standard — Trevor and Marcus should settle them before results land.**

| Q1a / Q1b result | Proposed reading — applied to each feature separately |
|---|---|
| Under ~30% | That feature doesn't reach churned users. It is weak, and we spent nothing learning so. |
| ~30–60% | Partial reach. Worth building, but say "partial recovery" out loud rather than later. |
| Over ~60% | Strong prior. The feature addresses the observed failure pattern. |

**Q5b has its own kill condition:** if under ~10% of users ever complete a perfect 4-week block, the earning half of the freeze is decorative — protection would effectively end at day 84 for nearly everyone, and the feature should be redesigned before it ships, not after.

For Q2, Q3 and Q5a/Q5c there is no pass/fail — the output *replaces* a guessed parameter. We currently assume 1 miss/week, a miss-bank cap of 3, a freeze cap of 7 and 3 seeds, with no evidence behind any of them.

---

## Two traps

**1. Don't look only at churned users.** Without the retained baseline we can't tell whether a miss pattern is distinctive or just what everyone does. Every query needs its comparison group.

**2. The fundamental limitation, and please state it in whatever you write up:** this replay shows who the mechanic would have **mechanically protected**, not who would have **stayed**. Behaviour would likely differ under different rules, and a user whose week streak survives might have churned anyway.

So Q1 is an **upper bound on reach, not a prediction of recovery.** It's a necessary-not-sufficient test: a bad result can kill the candidate, but a good result doesn't validate it.

---

## Scope

Days, not weeks. Existing data, no new sources. If time is short, the priority order is:

1. **Q3** — week-1 miss counts. Most consequential and cheapest to reason about.
2. **Q5b** — perfect-block achievability. A single number that could show half the freeze feature never fires.
3. **Q1a / Q1b** — because the two features are being considered separately, not just as a pair.

Everything else can wait.

## What this does not do

It doesn't establish that v2 caused the Day-7 decline, and it doesn't validate the problem statement. Those remain open and are what Thursday exists to resolve.
