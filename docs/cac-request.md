# CAC Request — the cost half of Query 1c

*2026-09-17 · Trevor Laverriere · assigned to **finance / growth** · **owner not yet named***

> **This is the one assignment today without a name on it, and by our own standard
> that means it is not assigned.** The weekly-status rule is *a blocker with no named
> owner is not a blocker, it is a complaint.* No finance or growth contact appears
> anywhere in the project record, so I have not guessed one.
>
> **This is also the one item that genuinely routes through Marcus.** Query 1 and the
> fast tracks were inside Trevor's own squad — that framing confused authority with
> prioritisation. Finance is outside the squad boundary, and Marcus owns the exec
> relationship. **Naming this person is a real ask for him, unlike the other three.**

---

## The request — send as-is once there is a name

**Subject: one number for a retention business case — paid CAC**

We are sizing what a retention decline is costing us in acquisition spend, and I need
one input from you.

**What I need: paid CAC, and the same figure by channel if you hold it** — paid,
organic, referral.

**Two periods, to match the cohorts our analysis uses:**

- The pre-decline window (when Day-7 retention was 48%)
- The current window (Day-7 at 39%)

**What I will do with it.** Multiply it by the users-per-week we are losing to a
9-point Day-7 decline, which our engineering lead is producing this week. Output is a
weekly and annualised replacement cost. I will label the CAC source and date
wherever the number appears.

**Why paid CAC specifically, rather than blended.** A lost user has to be *replaced*,
and replacement happens at the margin — which is the paid channel. Blended CAC
averages in organic and referral users who cost us close to nothing incrementally, so
it would understate what the leak actually costs to cover. **If you think blended is
the right basis here, say so and I will use it** — but I want the choice to be
deliberate rather than whichever number was easiest to find.

**If the two-period split is expensive, one current figure is enough to start.**

---

## Context, for whoever picks this up

**Why it matters.** Day-7 retention is 39% against a 48% baseline. MAU is still
growing 28% YoY, so the decline is **invisible at the top line** while quietly
raising what we spend to hold flat. That is the argument we have been making
qualitatively for four weeks without a number behind it.

**Why now.** Marcus has asked *"what is the cost of waiting another quarter?"* **three
times.** It is the one item in his profile marked *"partly answered, never
quantified."* Saying *"I don't have it"* a fourth time is not a position.

**Why it is only half the calculation.** The volume half — users lost per week — is
**Query 1c**, owned by Raj and due Wednesday 2026-09-23. Spec at
`../01-orient/validation-plan.md`. Neither half is useful alone.

**A dependency worth knowing about.** The volume calculation needs our **weekly
new-signup rate**, which is not in anything we currently hold and which also gates the
8-week experiment timeline in `../data/experiment-design.md` (it needs ≥1,120/week).
If that figure sits with growth rather than engineering, it can come back in the same
reply as CAC.

## What this is not

- **Not a full LTV or payback model.** One multiplication, honestly labelled.
- **Not a funding request.** It sizes a problem; it does not ask for budget.
- **Not urgent to the day.** Query 1c's volume half lands Wednesday, so anything
  before the following week keeps the two halves together.

## Status

| | |
|---|---|
| **Assigned to** | Finance / growth function |
| **Named owner** | **None yet — this is what is missing** |
| **Who can name it** | **Marcus.** Outside the squad, and he owns the exec relationship |
| **Blocks** | The cost half of Query 1c. Does not block Query 1, 1b, or the release gate |
