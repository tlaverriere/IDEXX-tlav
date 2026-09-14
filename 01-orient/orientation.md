# Module 1 · Orient — Get Oriented

> How do I make Claude Code know my product, and stop it building blind?

Set up persistent memory so Claude Code knows your product and stops building blind. Run your first real session, learn the interview-first habit, and set up `CLAUDE.md` plus the three core files.

## project.md

*What are we building and why?* → **[project.md](./project.md)**

## strategy.md

*Where does this fit in the bigger picture?* → **[strategy.md](./strategy.md)**

## change_log.md

*Running log of decisions and what changed, and why.* → **[change_log.md](./change_log.md)**

## First Skill

*Name + what it does + when to use it.*

- **Name:** ___
- **What it does:** ___
- **When to use it:** ___

---

# PRD Skeleton — Streakly Comeback Experience

*Source: planning meeting notes (Marcus, Raj, Lena). Drafted at Marcus's request to align on the problem before design. Contains only what was said in the meeting; gaps are marked as open questions.*

## Problem Statement

Day-7 retention has fallen to 39% from 48% since the streak redesign shipped. The drop is sharpest among users who break their streak in week 1: once a user misses two consecutive days, churn roughly doubles.

User research points to why. Users build a streak, miss a day because life gets in the way, and return to a counter reset to zero. The reset reads as punishment, and there is no path back in. The app does not acknowledge the break — same home screen, streak at 0 — and the "you lost your streak" push notification has a harsh tone. Tapping through it drops the user back at day zero with nothing offered.

**Working hypothesis:** users go passive because breaking a streak feels like failure and there is no graceful comeback. Re-engagement needs to give them a reason specific to them and their own progress, not generic encouragement.

## Goals

- Give users a graceful path back after a broken streak, in place of a cold reset.
- Re-engage users with a reason grounded in their own progress rather than generic motivation.
- Recover Day-7 retention lost since the streak redesign.
- Reach team alignment on the problem before solution design begins (before Thursday's meeting).

### Concept under exploration (not yet committed)

A **Comeback screen** shown when a streak breaks, sketched by Lena and assessed as technically feasible by Raj:

- The user's best-streak stat
- One 60-second comeback lesson to rebuild momentum
- A one-tap streak freeze to protect a rebuilt streak

## Non-Goals

- Designing or committing to a solution before the problem is agreed. Marcus asked for the problem write-up first.
- Generic "keep going!" style motivation.
- New data sources or data infrastructure. Raj confirmed the concept is buildable with what exists today.
- *Not addressed in the notes:* scope boundaries beyond the above (platforms, user segments, timeline) remain undefined.

## Success Metrics

- **Primary:** Day-7 retention. Current 39%; pre-redesign 48%. No target was set in the meeting.
- **Secondary (implied by the diagnosis, no targets set):**
  - Churn rate among users who miss two consecutive days (currently ~2x baseline)
  - Retention of users who break a streak during week 1
- **Open:** no measurement plan, target values, or timeframe were discussed.

## Open Questions

1. Is the root cause the streak reset itself, the notification timing and tone, or both? Raj's read is "probably both," with the bigger issue being what happens after the break.
2. Who is eligible to see the Comeback screen? Raj flagged the need for targeting logic.
3. What are the streak-freeze rules — frequency, duration, limits?
4. What should replace the current "you lost your streak" notification tone and content?
5. What are the success targets and the window for hitting them?
6. Who owns the problem write-up ahead of Thursday?
