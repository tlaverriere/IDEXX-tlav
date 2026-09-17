# PRD — Comeback Screen

*2026-09-17 · Trevor Laverriere · for Raj and Lena*

**Scope:** the post-break Comeback surface only. Freeze and Weekly Streak are specified in `../01-orient/strategy.md`.
**Sources:** interview synthesis (n=3, directional) · NPS (10 verbatims, no scores) · competitive matrix · decision brief rev 5 · `hypothesis.md` rev 2 · `spec-readiness.md` · `../data/metric-findings.md`. *A Reddit source was requested and does not exist — Reddit was unobtainable; the external-voice layer is Hacker News / Clozemaster.*

---

## Problem Statement

When a daily streak breaks, the product does not acknowledge it and offers no route back. The counter returns to zero, the home screen is unchanged, and the only message sent reads "you lost your streak."

- **Absence of a recovery path is the most-mentioned NPS theme** — 4 of 10 (R3, R5, R6, R8). Three more name the reset as the direct cause of abandonment (R1, R9, R10).
- **Tom churned at week 5 after a 12-day streak:** *"There was no way to recover it, nothing. So I gave up."* He also said *"I really wanted it to work"* — his exit followed absent recoverability, not absent motivation. On the notification: *"just made me feel bad."*
- **NPS R7 names the defect precisely:** *"The home screen looks the same whether I'm on a 2-day streak or coming back after two weeks away. Nothing acknowledges where I am."*
- **The current notification has a 0% action rate across 141 sends** in the sample data. There is no action to take.
- **Five of five direct competitors ship a missed-day mechanic; we ship none.** The only scanned app resetting on a first miss is Lumosity, included as the do-nothing control.
- **The return visit is unowned as a standing surface.** Duolingo's June 2026 restore event drew 15.4M revivals, ~8M with no active streak. Run time-boxed, and they publish research on resurrected users — the space is **open, not empty**.

**Not established:** that v2 caused the Day-7 decline. Correlation in time only.

## User

**Who.** A registered user whose daily streak has just broken. Stage-mixed by definition; the only lifecycle-labelled instance we hold is Tom, at week 5.

**Job to be done.** *When I miss a day and lose my streak, I want to know what I still have and be given one small thing to do, so that returning costs me less than starting over.*

**Two boundaries on who this serves:**

- **Not the pre-break week-1 user.** The surface fires on a break, so it cannot reach the only week-1 user interviewed. Amara is disengaging at day 4 with her streak intact: *"the pressure is starting to feel like a chore instead of a game."* Recorded at n=1 as the sharpest available hypothesis, not a finding.
- **Not the drift user.** Two NPS respondents faded without breaking anything; one *"forget[s] it exists."*

## Goals

1. Acknowledge the break explicitly rather than presenting an unchanged home screen.
2. Show what survived — best-ever daily streak, live week streak, remaining protection.
3. Offer one action: a 60-second lesson that **counts as that day's lesson**, nothing else due.
4. Restart the daily streak at 1 on completion; leave the week streak untouched.
5. Provide a dismissal path that lands somewhere coherent.

## Non-Goals

| Not in scope | Where it lives |
|---|---|
| **Pre-emptive "last day to save" trigger** | **Cut 2026-09-16** in spec review — contested by the persona it was built for, and needs a server-side evaluator that may not exist |
| Freeze and Weekly Streak mechanics | `strategy.md` |
| Notification tone, timing, volume | **Fast track 1** — addressed by none of the three approved features |
| Reaching drift users | Acknowledged coverage gap; fires on a break |
| Lesson content, tracks, 5-minute format | No user criticised these across 3 interviews and 10 verbatims |
| Purchasable or gifted restore | Freezes are **only ever earned** — stated line to defend |
| Day-7 retention as this surface's metric | See below |

## Success Metrics

**Primary: return rate among users whose daily streak has broken.** Per `hypothesis.md` §4 this surface is measured on reactivation, **not** Day-7, because that audience largely sits outside the Day-7 window. **The >50% Day-7 target belongs to the tolerance layer** — attributing it here would make this feature unfalsifiable.

| | Metric | Reference |
|---|---|---|
| Primary | Return within 48h of the break, treatment vs control | Sample data 100% vs 14%. Synthetic — direction, not a rate |
| Supporting | Prompt open and action rate | Current `streak_lost`: 17.7% open, **0% acted** |
| Supporting | Share of returners holding a live streak ≥1 seven days later | Untested. H1 in `metric-diagnosis.md` |
| Guardrail | **Notification opt-out rate** — must not rise | NPS R4 got three in an afternoon and *"turned them all off"* |
| Guardrail | Days-active per user | Guards the "anxiety down, habit down" failure mode |

## User Stories

| # | Story | Acceptance criteria |
|---|---|---|
| **1** | Streak just broke: I see what survived and one action. | Best-ever daily streak, current week streak and remaining protection render from existing data sources. CTA starts a 60-second lesson. On completion: daily streak = 1, week streak unchanged, nothing further due today, home screen reflects both |
| **2** | **No streak history:** I am not shown an empty trophy. | Defined behaviour when best-ever is 0 or null — stat suppressed below a floor rather than rendering *"Your best ever: 1 day."* **Unbuilt, and blocking design sign-off** (QA E1). This is the Day-7 cohort |
| **3** | **Week streak also dead:** I see an honest fallback. | Renders a memento naming the best-ever figure and stating nothing is running. Reachable for every user who accumulates freezes: 7 freezes = 8 missed days, but the weekly goal tolerates at most 4 in a week, so the week streak fails first |
| **4** | I can decline without penalty. | *"Not today"* exits to home with the week streak still visible. No further prompt that day |
| **5** | I break repeatedly and am not prompted repeatedly. | At most once per rolling 7 days. **Requires a break counter, which does not exist** |

## Open Questions

**Gates the release** — **Query 1**: decomposes the 9-point decline into *broke a streak / didn't break / never established one.* If the loss sits in the third group, none of the approved features addresses it. Days of work on existing data. **Assigned to Raj 2026-09-17, due Wednesday 2026-09-23** — and he raised this shape first: *"What happens if the user has never set a streak?"*

**Raj**

1. **Rollback path.** In the closest production analogue the streak reset sits inside the day-rollover transaction, next to HP loss and a full buff wipe, and a bug there rolls back the user's whole day. What is the revert for this surface and the counters it writes?
2. **Best-ever streak must be written at reset time, before the reset** — it cannot be derived afterwards. Confirm the schema can capture it.
3. **Targeting logic and freeze rules are still unbuilt**, flagged day one. The freeze field is all new storage.
4. **Scheduled evaluator, or does streak state only update when a user appears?** Decides whether any future pre-break work is a screen or a platform project.
5. **Freeze refund on late sync.** A lesson finished offline at 11:40pm and synced at 8am arrives after the boundary: miss recorded, freeze spent. Does the completion clear the miss, and is the freeze refunded?

**Lena**

6. **All copy is currently PM-written, including the load-bearing lines.** Placeholder, not proposed.
7. **What a user with nothing to show sees** — story 2. The premise is *lead with what survived*; for this cohort nothing did.
8. **Register**, your own question turned back: how does a broken streak read as forgiving rather than as a guilt trip? The breakdown currently stacks two failures vertically and reads as a receipt.
9. **Legibility.** Six concepts, never concept-tested; the freeze alone took seven bullets in plain language.

**Evidence status:** no user has seen the prototype. Week-1 evidence is n=1. The Priya, Tom and Amara reactions driving recent design decisions are **roleplays against personas, not user sessions.** What would close this is 8–12 week-1 interviews including users who never broke a streak — proposed, unassigned.
