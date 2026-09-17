# Query 1 — Handoff to Raj

*2026-09-17 · Trevor Laverriere · assigned owner: **Raj** · due **Wednesday 2026-09-23***

> **Send as async message, not raised in standup.** Per `../stakeholders/raj.md` he
> reads async first and does not like being surprised in the room. Everything below
> should reach him in writing before it is discussed.

---

## The message

**Raj — this one is yours, and it was your question first.**

In the original thread you asked *"what happens if the user has never set a streak?"*
That is precisely the third segment of Query 1, and it is the case that could
invalidate all three approved features. You identified the hole before any of our
research existed. I am asking you to close it.

**Due Wednesday the 23rd**, so the answer is in the room for Thursday's quarterly
review rather than being promised in it.

### What it is

Full spec in `../01-orient/validation-plan.md`. Three parts, one pass:

- **Query 1** — split new users by week-1 behaviour: **(a)** started a streak and
  broke it, **(b)** started and did not break, **(c)** never established one. Both
  the pre-decline cohort (Day-7 = 48%) and now (39%). Share of cohort and Day-7
  retention per segment, then attribute the 9-point move between **mix shift** and
  **within-segment decline**.
- **Query 1b** — within segment (a), the distribution of **distinct missed days in
  the first 7**, bucketed 0/1/2/3/4/5+. One extra `GROUP BY`. **You already have
  this segment** — your *"~2x churn after two consecutive missed days"* finding is
  defined on the ≥2-miss population. I need ≥2 *total* rather than ≥2 consecutive,
  which is a looser filter on the same logic.
- **Query 1c** — the volume half of the acquisition-spend cost: users lost per week
  to the 9 points. **The cost-per-user half is not yours** — I am getting CAC from
  finance separately.

### What done looks like

You have asked *"how will we know if this is working?"* more than once, so here it
is for this piece of work specifically:

**Done** = the segment table for both periods, the mix-vs-within-segment attribution,
and the 1b distribution. **That is it.** No recommendation, no interpretation, no
deck. If the numbers say the decline sits with users who never established a streak,
write that down and send it — **the kill conditions are pre-registered in the
validation plan precisely so an inconvenient answer is a valid result rather than a
problem.** I would rather have that answer on Wednesday than a comfortable one.

### The capacity call, stated rather than left for you to discover

You also owe me a **freeze data-model estimate**, and I am consciously putting that
second. The reason is sequencing, not priority games: **the freeze accounting work
holds until Query 1 clears the gate**, so estimating held work before the gate runs
is out of order. Query 1 first, estimate after.

Two things I am *not* moving off, because they are answers rather than work:

- **Is there a scheduled evaluator, or does streak state only update when a user
  appears?** This decides whether any pre-break surface is a screen or a platform
  project.
- **Was v2 A/B tested or staged-rolled?** If either, the causality answer is already
  in the data and Query 2 gets much cheaper.

Both are 30 seconds of your knowledge, not analysis. Whenever suits.

### What I am not asking for

- Not the counterfactual replay. That waits on Query 1 by design — running it first
  risks optimising a solution for a problem we have mislocated.
- Not a re-defence of your 2x figure. **1b will put a distribution behind it**, which
  is more useful than the aggregate ratio either way. Sample-data analysis on the
  17th put the break-related churn relative risk nearer 1.24–1.34, so the direction
  holds and the magnitude is open. That is not a criticism of one evening's work.
- Not a timeline commitment on anything downstream. That comes after the gate.

**If Wednesday is not achievable, tell me today and I will change what I take into
Thursday** — I would rather adjust the deck than the date.

---

## Why this assignment is defensible, for the record

**It was framed as Marcus's call and it is being made here instead.** Worth stating
plainly, because the gate is on the record as the reason his approval was sound:

- The **owner** question was capacity and prioritisation, not authority. Trevor owns
  the area and runs the squad's working sessions; Raj is on that squad.
- Waiting for Marcus to name someone kept it unowned for **four days** while the
  release stayed gated on it. The cost of continuing to wait exceeded the cost of
  deciding.
- **Raj is the only defensible owner.** He produced the finding the gate exists to
  test, he identified the segment the gate turns on, and he already holds the data
  cut 1b needs.

**Marcus must be told, not left to discover it.** This changes the first ask in both
`recommendation-memo.md` and the quarterly deck from *"I need an owner"* to *"it is
owned, and here is what it found."* If he wanted a different owner he should have the
chance to say so before Wednesday.

## Still unassigned after this

| Item | Needs |
|---|---|
| **CAC input for Query 1c** | Finance or growth. Not Raj's |
| **Owners for both fast tracks** | Notification quality, and the week-1 acknowledgment moment |
| **8–12 week-1 interviews** | Lena. The only item measured in weeks, and the one that closes her evidence gap |
