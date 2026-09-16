# PM Brief — Streakly Comeback Screen

*Written 2026-09-16 · Trevor Laverriere*

## Approval context

**Option C was approved by Marcus on 2026-09-16** — Comeback Screen + Freeze + Weekly Streak, shipped together.

**The release is gated on Query 1, not assumed by it.** Query 1 decomposes the 9-point Day-7 decline by week-1 behaviour; if the loss sits with users who never established a streak at all, this is an onboarding problem and none of the three approved features addresses it. Design work — including this prototype — is explicitly in the "proceeds" column. Production streak-accounting changes hold.

**Query 1 still has no owner.** The gate currently has nothing behind it.

## The brief

**User.** A 24-year-old who hit a 12-day streak, missed two days, and has not opened the app since.

**Job to be done.** Get back in without feeling they lost everything.

**Feature.** The Comeback screen as approved: **best-streak stat** and **one 60-second comeback lesson**, shown when the daily streak breaks.

*Note:* the original concept included a one-tap streak-freeze offer. That component no longer exists — freezes are earned-only and auto-applied, so there is nothing to offer on tap.

**Constraint.** Use data Streakly already has. No new integrations.

## What the user's state actually is

Under the approved design, the persona arrives at this screen with more intact than the brief assumes:

| | Value | Note |
|---|---|---|
| Daily streak | **0** | Reset on the second consecutive miss |
| Best-ever daily streak | 12 | The approved spec's stat |
| Freeze bank | 0 | The single seeded freeze absorbed the first miss; the second broke the streak |
| **Week streak** | **2 — intact** | The miss bank absorbed both misses, so the weekly goal was met |
| Miss bank | 2 remaining | |

**He has not lost everything. He has lost one of two things.** That distinction is the whole basis of the screen.

## Success criteria

Not measurable from a prototype, and recorded here so they aren't confused with it:

- **Primary:** Day-7 retention. No recovery target has been set — still an open question, not an assumption.
- **What this prototype can establish:** whether the screen reads as acknowledgment rather than punishment, and whether the surviving week streak registers as a live asset rather than a consolation.

## Known limitation, carried forward

The design is strongest when the week streak survives. For a user who broke on day 5 — best streak 4, week streak 0 or 1 — the screen has almost nothing live to show. **That is the cohort Day-7 actually measures**, and this prototype does not cover it. Flagged, not solved.
