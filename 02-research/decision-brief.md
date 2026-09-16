# What We're Trying to Solve — and What We'd Do About It

**For:** Marcus, Head of Product · **From:** Trevor · **2026-09-14** · *originally a pre-read for Thursday*
*Revision 5. You asked for the problem before the solutions, so the problem comes first and the recommendation comes last.*

> ## Outcome — approved 2026-09-16
>
> Marcus approved the recommendation as written: **Option C as the direction**, validation funded, and the **release gated on Query 1** rather than assumed by it.
>
> **Kept as the document of record**, unedited below this banner. It shows what was approved and on what evidence — including Part 1's *"What we do not know,"* which the approval did not change and does not retire.
>
> **Not settled at the meeting, and still needed:** an owner and date for Query 1, owners for both fast tracks, a recovery target, and whether to instrument for attribution.

**Sources:** `interview-synthesis.md` (n=3), `nps-analysis.md` (10 verbatims), `competitive-matrix.md` (5 competitors + 1 control), external user forums, and `../01-orient/strategy.md` for the full design. **On the external voice:** Reddit is inaccessible from our research tooling, so that layer is Hacker News and the Clozemaster forum — real users, different platform. Labelled **external voice** throughout, never presented as Reddit.

---

## Situation

Day-7 retention sits at 39% against a 48% baseline, and the loss concentrates in users who break a streak in week 1. We have three designed features ready to scope, and one unanswered data question that could show all three are aimed at the wrong thing.

---

# Part 1 — The Problem

## What research found

| Finding | Source | Confidence |
|---|---|---|
| **The content is not the problem — the mechanic is.** Every piece of praise targets lessons or the first-week experience; every complaint targets the streak system | All 3 interviews, all 10 verbatims | **Strong.** Rules out the most expensive direction |
| **There is no way back after a break.** *"No way to recover it, nothing. So I gave up."* — Tom. Corroborated by external voice: *"lost it and haven't opened the app since. Why would I, all my hard work is lost?"* | Top NPS theme (4/10), Tom, external voice | **Best-evidenced thing we have** — three independent sources |
| **Week-1 harm may start before any break.** Our only week-1 interviewee is disengaging at day 4 with her streak fully intact | Amara, n=1 | **Directional.** Most consequential and least tested claim we hold |
| **Forgiveness can hollow out the streak.** A 500-day-streak user: *"I didn't deserve that 500 day streak"* | External voice only — absent from all internal sources | **Directional** — and it reshaped the design |
| **Habit takes ~3 weeks.** *"Most people quit long before the habit forms"* | Priya | **Directional** |
| **Drift:** users who fade without ever breaking a streak | 2 NPS respondents + Amara | **Directional**, two independent sources |

## What we do *not* know — read this before Part 2

The design is finished. **The problem statement is not validated.** Both are true and should be held at once.

- Interviews are n=3. NPS is 10 verbatims with no scores attached. **Neither is segmented to week 1**, which is our core metric.
- Raj's *"two consecutive misses → ~2x churn"* — our most persuasive number — remains one unreviewed evening of analysis.
- That **v2 caused the decline is not established.** Correlation in time only; confounds unexamined.
- **No recovery target has been set**, in either number or timeframe. Still an open question, not an assumption.

## The one question that could invalidate all of this

**Query 1** decomposes the 9-point decline by week-1 behaviour: users who broke a streak, users who didn't, and users who **never established one**.

If the loss sits with that third group, this is an **onboarding problem** and none of the three features below addresses it.

It runs on existing data, takes days, needs no new sources — and **has no owner.** Full spec in `../01-orient/validation-plan.md`.

---

# Part 2 — What We'd Do About It

## The three features

**The Comeback Screen** *(Lena's concept)* — shown when the daily streak actually breaks: the user's **best-streak stat** plus **one 60-second comeback lesson**. Raj confirms it's buildable on existing data; targeting logic unbuilt. *The original sketch included a one-tap freeze; the freeze bank makes that affordance unnecessary rather than merely removed.*

**The Freeze** — protects the **daily streak** from a single missed day; the streak otherwise still resets on one miss, as today. Earned one per **perfect 4-week block**, **never purchasable**. One seeded at the start of each of the **first 3 blocks** (days 1, 29, 57), then seeding stops. Cap **7**. Protects the daily streak only — the day still counts against the weekly goal. *Principle to defend: protection is a trophy for not failing, not a cushion against failing.*

**The Weekly Streak** — a second currency beside the daily streak. The daily streak measures **perfection**, the week streak measures **consistency**. Miss at most **1 day per week** plus anything banked; weeks **signup-anchored** so week 1 maps exactly onto Day-7; miss bank cap **3** with accounts starting at the cap; opt-in **7-day run** to rescue a failed week, 4 per account year.

**The property that matters:** with the Freeze and Weekly Streak together, a week-1 user's **first missed day costs nothing visible.**

## How the features map to the findings

| Finding | Comeback | Freeze | Weekly |
|---|:---:|:---:|:---:|
| Content fine, mechanic is the problem | ● | ● | ● |
| No way back after a break | ● | ● | ● |
| Week-1 harm before any break | — | ● | ● |
| Forgiveness hollowing out the streak | — | ● | ● |
| Habit takes ~3 weeks | — | ● | ● |
| *"Home screen looks the same…"* (NPS R7) | **●** | — | — |
| The return visit — unowned white space | **●** | — | — |
| Drift | ○ | ○ | ○ |
| Notification tone, timing, volume | — | — | — |

● addresses · ○ weak · — not addressed

**Two honest gaps:** **notifications are addressed by none of these** — that's Fast track 1 — and **drift is weak across all three**, because none of them re-engages someone who simply forgets.

## Options

| | Option | Case for | Case against |
|---|---|---|---|
| **A** | **Comeback Screen only** | Smallest build; targets our best-evidenced finding; only option in unowned white space | Fires only *after* a break, so it can't reach a pre-break week-1 user. Leaves the reset itself brutal |
| **B** | **Freeze + Weekly Streak** | The *"first miss costs nothing"* property; reframes from day 1; pays off on day 7, inside our metric | Nothing acknowledges a user who does break through protection. Leaves state-awareness and the white space unaddressed |
| **C** | **All three** | Covers the full timeline — **before** the miss, **at** the miss, **after** it. Only option closing both the state-awareness gap and the white space | Largest scope; attribution forfeited. **And B shrinks the Comeback Screen's audience** — fewer users ever reach a broken streak |

**The alternative I'd accept:** **B first, then A.** Ship the two features, measure how many users still break through protection, and size the Comeback Screen's real audience before paying to build it. Slower, but it buys attribution.

---

## Recommended Action

**Approve Option C as the direction and fund validation now — with the release gated on Query 1 rather than assumed by it.**

The direction is what needs your alignment on Thursday. The release decision needs one number that is days away, so there's no reason to take both at once.

## What proceeds and what holds while Query 1 runs

Naming this precisely, because "in parallel" is meaningless otherwise:

| Proceeds | Holds until Query 1 lands |
|---|---|
| Both fast tracks — independent of the answer | Production changes to **streak accounting** (freeze bank, miss bank) — expensive and hard to unwind |
| Design and copy on all three features | Any schema or data migration |
| Instrumentation groundwork — needed for any experiment | External comms or launch commitments |
| Feasibility spikes: Comeback targeting logic, signup-anchored week computation | |

Nothing that Query 1 could invalidate gets built in the interim, and the hold is days rather than weeks.

## Why now

- **The leak is masked and compounding.** MAU still grows 28% YoY, so a 9-point Day-7 decline is invisible at the top line while quietly raising the acquisition spend needed to hold flat.
- **The Weekly Streak is the first mechanic we've designed that resolves inside our own metric** — it pays off on day 7. Every earlier version paid off around day 30, outside the window we're trying to move.
- **We are the only app in our comparison set with no missed-day mechanic at all.** Five of five competitors ship one; the only app resetting on a first miss is Lumosity, our do-nothing control.
- **The white space is open but not empty.** Duolingo's one-month 2026 streak revival drew **15.4M revivals, ~8M from users with no active streak** — and they publish internal work on resurrected users, so this is deliberate investment, not a one-off. It won't stay unclaimed.

## Decisions needed Thursday

1. **Direction: A, B or C.**
2. **An owner and date for Query 1.** The one thing I would not ship without — and it is days of work on data we already have.
3. **Owners for both fast tracks** — notification quality, and an acknowledgment moment inside week 1. Covered by none of these features.
4. **A recovery target.** None has been set, in number or timeframe. Without one we cannot judge whether any of this worked.
5. **If C: whether to instrument for attribution**, accepting the cost, or to accept that we won't know which feature did the work.

**Every number in these features is an assumption** — 1 miss/week, bank cap 3, freeze cap 7, 3 seeds, a 7-day save run, 4 saves a year. None is derived from our data. The replay spec in `../05-decide/counterfactual-replay.md` is written to set them rather than confirm them.
