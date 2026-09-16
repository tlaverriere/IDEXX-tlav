# project.md — What We're Building and Why

*Last updated: 2026-09-14*

## What Streakly is

A consumer habit + micro-learning app. Users pick a track, complete a five-minute daily lesson, and build a streak. The streak is the core habit loop — it is the product's engine, not a gamification layer on top of it.

Four years old. Series B, $42M raised. 2.1M registered users, 340K MAU, +28% YoY on MAU.

**Core metric: Day-7 retention.** The north star. Currently 39%, down from 48% — a 9-point drop following the v2 streak redesign.

## Goal this quarter

Recover the 9-point Day-7 retention loss. No target number or date has been set — that is an open decision, not an assumption.

## Bet

**Placed 2026-09-16.** Marcus approved **Option C** — ship all three features together:

- **Comeback Screen** (Lena) — best-streak stat plus one 60-second comeback lesson, shown when the daily streak breaks.
- **Freeze** — earned-only, auto-applied, protects the daily streak from a single miss.
- **Weekly Streak** — miss up to 1 day a week, with a miss bank and an opt-in recovery run.

The bet in one line: *the daily streak should stay honest about perfection, and a second currency should carry consistency — so a missed day stops meaning you lost everything.*

**The release is gated on Query 1**, not assumed by it. Full design in `strategy.md`.

## Not doing

- Generic "keep going!" motivation.
- Anything requiring new data sources — all three features are buildable on what exists today.
- Purchasable protection, or protection gifted to established users. Earned-only is the line `strategy.md` says to defend.
- Weekly leaderboards or leagues — signup-anchored weeks don't align across users.

*Removed 2026-09-16: "committing to a solution before the problem is agreed." We have now done exactly that, deliberately, with the Query 1 gate as the safeguard. Leaving the old line in place would be dishonest.*

## Current phase

**Direction approved, release gated.** Design, copy, instrumentation groundwork and both fast tracks proceed. **Production streak-accounting changes hold** until Query 1 lands.

Query 1 decomposes the 9-point decline by week-1 behaviour. If the loss sits with users who never established a streak at all, this is an onboarding problem and **none of the three approved features addresses it.** Spec in `validation-plan.md`; the feature-level replay is `../05-decide/counterfactual-replay.md`.

**Unassigned and needed:** an owner and date for Query 1, owners for both fast tracks, a recovery target, and a decision on attribution instrumentation.

## Squad and stakeholders

| Who | Role | Stake in this |
|-----|------|---------------|
| Me (Trevor) | Group PM / Director of Product | Own the area. Run the working sessions, including Thursday's alignment meeting. Not the greenlight. |
| Marcus | Greenlight on what gets built | Called the retention meeting, asked for the problem write-up. My alignment with him is the real gate on shipping. |
| Raj | Data / engineering *(title inferred)* | Produced the two-consecutive-misses churn finding. Confirmed the Comeback concept is technically feasible today. |
| Lena | Design / research *(title inferred)* | Owns the research on streak-reset-as-punishment. Authored the Comeback screen sketch. |

**Capacity:** full squad — engineering, design, data — committed this quarter to retention. This is a constraint as much as a resource: a committed squad with nothing to build creates pressure to start designing before discovery finishes.
