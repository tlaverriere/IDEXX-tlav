# Spec Readiness — Comeback Surface

*2026-09-16 · after a spec review run in character as Raj*

---

# 1 · Readiness summary

## What was solid

| | |
|---|---|
| **The problem chain** | Unusually well documented and confidence-labelled. Every claim traceable to a source, with directional figures marked as directional. Raj did not challenge a single piece of evidence |
| **Feasibility, pre-assessed** | "No new data sources" was established on day one and held up |
| **A working prototype** | Not a mock. Three states that turn out to be literal rows of the truth table below |
| **Risks pre-recorded** | Twelve, written down before review rather than discovered in it |
| **The codebase study earned its keep** | It caught the pre-emptive trigger's missing infrastructure **before kickoff** rather than in sprint two. That one finding paid for the exercise |

## What needed work

**The headline: there was no spec.** There was a PM brief, a decision brief, a hypothesis doc and a prototype. Raj's first substantive line was *"it's a brief, not a spec"* — no acceptance criteria, no enumerated edge cases, no definition of done.

| Gap | Status after the session |
|---|---|
| **Pre-emptive trigger assumed infrastructure that doesn't exist** — nothing runs per-user on a schedule, so "the last day" is unknowable before the user opens the app | **Resolved — cut from v1.** Needs its own dated ticket, not a "negotiable" |
| **2.1M existing users entirely unaddressed.** Every rule was written for someone signing up tomorrow | **Resolved** — 1 seeded freeze, everyone starts at block 1, re-anchor to launch, rolling over 7 days |
| **Best-ever streak cannot be backfilled** | **Resolved, and well** — owned as a launch note ("streak records start today") rather than hidden |
| **No success metric.** Asked three times across the project and never answered | **Resolved — >50% Day-7 within 4 weeks of launch** |
| **No holdout** — shipping to everyone would have reproduced the exact inference failure we spent three days refusing to accept about v2 | **Resolved** — 50/50 split on existing users |
| **Holdout is on the wrong population for the stated metric** | **Resolved 2026-09-16** — new-signup 50/50 split confirmed, alongside the existing-user split |
| **No rollback plan** for a change touching the streak pipeline | **Resolved 2026-09-16** — kill switch confirmed in scope, to be sized as part of the estimate rather than a stretch |
| **One missed day produces three different outcomes across three systems, never written down** | **Resolved by §4 below** |
| **Six cases the truth table surfaced** | **Five resolved 2026-09-16.** One remains — see below |

## Still open going into kickoff

**The spec is ready for estimates.** What remains is one design question and one validation dependency, neither of which blocks writing tickets.

1. **Block earning is unprotectable and invisible.** Any miss kills the current 4-week block, frozen or not, and no progress meter ships — so a user 27 days into a perfect block loses it without ever knowing. Two individually defensible decisions combining into something harsh. **Design question, not a spec gap.**
2. **Query 1 is still unowned**, and the release is still gated on it. **Validation, not spec.**
3. **Confirm with Raj directly that no per-user scheduler exists.** The pre-emptive trigger was cut on the strength of a roleplay's architectural claim, not on Raj's own word. If that claim is wrong, the cut was wrong.

## One thing to note about the target

**>50% is above the previous baseline, not a return to it.** The decline was 48% → 39%. Reversing it lands at 48%; >50% is two points past the best Streakly has ever performed.

That is a legitimate choice, but the spec should carry one target, not two sentences implying different ones — otherwise a 47% result is a win or a miss depending which line the reader quotes.

---

# 2 · Rewritten sections

## 2.1 Trigger — replaces the pre-emptive definition

> The Comeback surface fires **once, on the user's first session after their daily streak has been reset to zero.**
>
> It does **not** fire pre-emptively. A pre-emptive prompt requires a scheduled per-user evaluator that does not exist today; it is tracked separately and is **out of scope for v1**.
>
> **Frequency — confirmed 2026-09-16: at most once per rolling 7 days.** A user who breaks, rebuilds to 1, and breaks again inside the same window sees it once. Prevents the surface becoming the nagging that is already an NPS complaint.

## 2.2 Existing users at launch — new section

> **Population.** All 2.1M registered users are re-anchored at launch.
>
> | Rule | Value |
> |---|---|
> | Week anchor | **Launch date**, not signup date |
> | Block counter | Everyone starts at **block 1** on launch day |
> | Seeded freezes | **1** at launch, then **+1 at launch+28 and launch+56** — the schedule follows the block counter |
> | Seeded miss bank | **3**, matching new accounts — confirmed 2026-09-16 |
> | Rollout | **Rolling over 7 days**, to **50%** of the existing base (see 2.4) |
>
> **Store `weekAnchorDate` as a field. Do not derive it from `createdAt`.** Two anchoring schemes now coexist — launch for existing users, signup for post-launch registrations — and computing either from the creation date puts a branch in every query.
>
> **One rule, no special cases.** *Revised 2026-09-16 from 3 seeded freezes down to 1.* Because the seeding schedule follows the **block counter** rather than the calendar, and existing users start at block 1, an existing user now receives exactly the same ramp as someone signing up on launch day — 1 freeze at block 1, a second at block 2, a third at block 3. **For tolerance purposes every user is treated as if they joined at launch.** That removes the asymmetry, and it removes a branch from both the spec and the code.
>
> **The consequence to accept knowingly:** the users with the most to lose now get the least protection. A 400-day-streak user starts launch day with **one** freeze — two missed days ends a streak they have held for over a year. That is the honest price of "everyone starts at block 1." One of our recorded findings is that a long-tenured user reacts badly to protection being handled invisibly, so **this belongs in the launch note rather than in a FAQ.**

## 2.3 Best-ever streak — new section

> Best-ever streak **must be written at reset time, before the streak is zeroed.** It cannot be reconstructed afterwards: history compresses and the fields needed to recompute a streak are dropped.
>
> **For existing users there is no historical value to recover.** This is owned explicitly rather than hidden: at launch, the field is seeded from the user's current streak and the surface carries a one-time note that **streak records begin at launch.** Do not display a number implying a longer history than we have.

## 2.4 Measurement design — new section

> **Goal:** Day-7 retention **above 50%** within **4 weeks of launch**.
>
> **Two independent splits, doing two different jobs:**
>
> | Split | Population | Purpose |
> |---|---|---|
> | **New signups, 50/50** | Registrations after launch | **Measures the goal.** Day-7 retention is a new-user metric — *"share of new users still active on day 7."* This split is the only thing that can substantiate the >50% claim |
> | **Existing users, 50/50** | The 2.1M, rolled over 7 days | **Safety, not measurement.** Detects whether re-anchoring and granting freezes *harms* already-engaged users |
>
> **The existing-user split is not a measurement of the goal.** Existing users have no day 7. It is a guardrail — one recorded risk is that a long-tenured user resents protection she didn't know she had, or relaxes once she knows she's covered.
>
> **Read timing.** Rollout completes day 7. New users from day 7 onward have the feature from signup and produce a Day-7 figure seven days later, so cohorts registering days 7–21 are readable inside the 28-day window — roughly **14 days of cleanly exposed cohorts.** Power is not the constraint; **anyone asking for a read before week three is looking at noise.**
>
> **Guardrails alongside the primary metric:** days-active (to catch "anxiety down, habit down"), notification opt-out rate, and engagement among high-consistency users.

## 2.5 Rollback — new section

> **Required before launch: a kill switch that disables the entire tolerance layer without a deploy.**
>
> Rationale, and it is not hypothetical. This change writes to streak state for 340K active users, and **a revert does not un-corrupt data.** Two code paths run simultaneously for four weeks, doubling the surface where accounting can go wrong.
>
> Precedent: the closest production analogue ships exactly this — a global flag that disables punishment mechanics for all users at once. It exists because someone needed it.
>
> **Requirement:** a single flag that (a) stops all freeze and miss-bank accounting, (b) suppresses the Comeback surface, (c) leaves existing counter values untouched rather than resetting them.

---

# 3 · Slack message — send before kickoff

> **Raj — scope confirmation before kickoff**
>
> Recapping what we landed on so there are no surprises in planning. Shout if I've got any of this wrong.
>
> **In scope for v1**
> • Comeback surface, **post-break only** — best-streak stat + 60-second lesson that counts as that day's lesson
> • Freeze: earned per perfect 4-week block, cap 7, auto-applied
> • Weekly streak: 1 miss/week + bank of 3, launch-anchored weeks
>
> **Cut from v1**
> • Pre-emptive "last day to save" trigger — needs a scheduled evaluator we don't have. Separate ticket, I'll date it this week rather than leave it open
>
> **Migration**
> • Re-anchor everyone to launch, everyone starts block 1
> • Existing users get **1** seeded freeze, then +1 at block 2 and block 3 — same ramp as a new signup. Miss bank seeded at **3**, same as new accounts
> • Rolling over 7 days, to **50%** of the existing base
> • Best-ever streak seeded from current streak, with a launch note saying records start now. We're owning it, not hiding it
>
> **Success metric** — first time we've had one
> • **Day-7 retention above 50%, within 4 weeks of launch**
> • Two splits: new signups 50/50 to measure it, existing users 50/50 as a safety check. Your point stands — the existing split can't measure Day-7, so both are needed
>
> **Two things I owe you**
> • Truth table — attached, 22 rows. It surfaced 6 cases we had not specified; 5 are now answered in the doc, 1 left open (block earning is unprotectable and invisible — flagging it rather than deciding it alone)
> • Kill switch: **yes, I want it in scope.** Please size it as part of the estimate rather than a stretch
>
> **One thing you owe me** 🙂
> • Query 1 — the week-1 decline decomposition. Spec is ready to hand over, it's days of work on existing data, and the release is gated on it. Can you take it and give me a date?
> • Also, quickly: was v2 A/B tested or staged-rolled before launch? If either, the causality answer is already sitting in our data.

---

# 4 · The truth table

**The core finding, stated first:** the three counters respond to a missed day **independently**, and only two of them can be protected.

| Counter | Protected by | Survives a miss? |
|---|---|---|
| **Daily streak** | A freeze | Yes, if one is available |
| **Week streak** | Miss allowance + bank | Yes, if margin remains |
| **Block earning** *(progress to next freeze)* | **Nothing** | **Never.** Any miss kills the block, frozen or not |

That third row is the important one. **Block earning is unprotectable**, and because no progress meter ships, a user 27 days into a 28-day perfect block loses it invisibly.

## A · Single missed day — the four core cases

*Legend: **F** = freeze available · **M** = weekly misses remaining (allowance + bank)*

| # | F | M | Daily streak | Week streak | Block earning | Freeze bank | Miss budget | User sees |
|---|:-:|:-:|---|---|---|---|---|---|
| **A1** | ✅ | ✅ | **Survives** (preserved, not extended) | Intact | **Dead** | −1 | −1 | "Your freeze covered today" |
| **A2** | ✅ | ❌ | **Survives** | **Breaks** → save-eligible | **Dead** | −1 | 0 | Freeze held, week lost |
| **A3** | ❌ | ✅ | **Resets to 0** | Intact | **Dead** | 0 | −1 | **Comeback surface** — daily gone, week alive |
| **A4** | ❌ | ❌ | **Resets to 0** | **Breaks** → save-eligible | **Dead** | 0 | 0 | **Comeback surface** — worst case, memento only |

**These four rows are the prototype's three states.** A1 precedes the "Day 14 · at risk" state, A3 is "Day 15 · lost it", A4 is "14-month · 8 days".

## B · A new user's first two weeks — worked sequence

*Opening state: daily 0, freeze bank **1**, miss budget **4** (1 allowance + 3 bank), block 1 active*

| Day | Event | Daily | Freezes | Miss budget | Block 1 | Case |
|---|---|:-:|:-:|:-:|---|---|
| 1–2 | Complete | 2 | 1 | 4 | alive | — |
| 3 | **Miss** | **2** (frozen) | **0** | **3** | **dead** | A1 |
| 4 | **Miss** | **0** | 0 | **2** | dead | **A3 — surface fires** |
| 5 | Complete | 1 | 0 | 2 | dead | — |
| 6 | **Miss** | **0** | 0 | **1** | dead | A3 — *fires again?* |
| 7 | **Miss** | 0 | 0 | **0** | dead | A3 — week goal **met at exactly the margin** |
| — | *Week 1 closes* | 0 | 0 | — | dead | **Week streak = 1.** No banking (allowance was used) |
| 8 | *Week 2 opens* | 0 | 0 | **1** | dead | **The day-8 cliff: 4 → 1** |

**Two recorded risks, demonstrated concretely.** A user can miss **4 of 7 days** in week 1 and keep their week streak — the "near-unfailable week 1" concern. And budget drops fourfold at day 8 for the user least likely to have formed a habit.

## C · Boundaries and caps

| # | Event | Result |
|---|---|---|
| **C1** | Week closes, **0 misses used** | Miss bank **+1**, capped at 3 |
| **C2** | Week closes, **1+ misses used** | No banking that week |
| **C3** | Week closes at **bank cap 3**, 0 misses used | Unused allowance **lost** |
| **C4** | Block closes (28 days), **0 misses** | Freeze bank **+1**, capped at 7 |
| **C5** | Block closes with **any** miss — frozen or not | **No freeze earned** |
| **C6** | Freeze earned or seeded while **at cap 7** | **Lost.** Recommend notifying — one user's recorded reaction to silent discarding was anger |
| **C7** | Week closes with budget exceeded and **no save attempted** | Week streak → 0, restarts next week |

## D · Last-gasp save

*All confirmed 2026-09-16.*

| # | Question | Answer |
|---|---|---|
| **D1** | When does the 7-day run start? | On the **first completed lesson after opting in.** Unambiguous, and forgiving of a user who opts in late at night |
| **D2** | Can the run cross a week boundary? | **Yes**, by design |
| **D3** | Can it cross a **block** boundary? | Yes, and it is immaterial — the block is already dead (C5). Stated explicitly so nobody assumes otherwise |
| **D4** | Does a successful save restore the daily streak? | **No.** It preserves the **week streak only** |
| **D5** | Does it revive block earning? | **No** |
| **D6** | Failed attempt | Does **not** consume one of the four |
| **D7** | Four per "account year" — from when, for existing users? | **From launch**, consistent with re-anchoring |

## E · Completion cases

| # | Event | Result |
|---|---|---|
| **E1** | Complete on a due day | Daily **+1**; no miss consumed; block progress continues |
| **E2** | Complete the day after a reset | Daily **= 1** |
| **E3** | Complete the 60-second comeback lesson | **Counts as that day's lesson.** Nothing else due. Daily +1 from 0 |

---

## Six cases the table surfaced — five now closed

| # | Case | Status |
|---|---|---|
| 1 | **Block earning is unprotectable and invisible.** Any miss kills it (C5), and no progress meter ships, so a user 27 days into a perfect block loses it without ever seeing what they lost | **Open.** The only one left. A design question rather than a spec gap — but it is the harshest thing in the mechanic and nobody has decided to accept it |
| 2 | Existing users seeded 3 freezes while new users got 1 | **Closed** — seeded down to 1, following the block counter. Same ramp for everyone (§2.2) |
| 3 | Miss bank for existing users at launch | **Closed** — 3, matching new accounts |
| 4 | Comeback surface frequency within a week | **Closed** — at most once per rolling 7 days |
| 5 | Last-gasp save "account year" for existing users | **Closed** — from launch |
| 6 | Scope of a successful save | **Closed** — week streak only; not the daily streak, not block earning (D4, D5) |

**On the one that's left:** the two decisions producing it were each sensible in isolation. A frozen day shouldn't count as perfect, or you could freeze your way to earning more freezes. And no progress meter ships, because a "day 19 of 28" counter would be a second streak with a harsher reset. Together they mean a user can lose 27 days of invisible progress to a single missed day and never be told it happened.

Three ways out if you want one: make the block tolerate one frozen day; show progress after all and accept the loss-shaped counter; or notify on block failure so at least it isn't silent. **No recommendation — this one is genuinely a judgment call and it is Lena's register question in a different costume.**
