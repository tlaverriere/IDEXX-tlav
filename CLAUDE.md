# CLAUDE.md — Persistent Memory

> The file Claude Code reads at the start of every session. Short, true, current — the difference between Claude building blind and building with context.

## The Product

**Streakly** — a consumer habit + micro-learning app. Users pick a track and do a five-minute daily lesson; the streak is the core habit loop. Four years old, Series B ($42M), 2.1M registered users, 340K MAU, growing 28% YoY on MAU.

**Core metric: Day-7 retention.** This is the north star, which makes the current situation urgent rather than a slow leak.

**Current focus.** Day-7 retention is 39%, down from 48% following the v2 streak redesign. The loss is *believed* to concentrate in users who break a streak in week 1 — **unvalidated**, and precisely what Query 1 tests. Working hypothesis: breaking a streak reads as failure — the counter resets, the app doesn't acknowledge it, and the "you lost your streak" push lands at peak quit risk — so users go passive with no graceful way back.

**Phase, as of 2026-09-16:** direction approved, release gated on Query 1. Design, copy, instrumentation groundwork and both fast tracks proceed; **production streak-accounting changes hold** until Query 1 lands.

## Me and the Squad

**Me:** Group PM / Director of Product. I own the area and run the working sessions, including the Thursday problem-alignment meeting.

**Marcus:** greenlights what gets built. Called the retention meeting and asked for the problem write-up. My alignment with him is the real gate on anything shipping.

**Raj:** data/engineering. Produced the "two consecutive missed days → ~2x churn" finding; confirmed the Comeback concept is buildable with existing data sources.

**Lena:** design/research. Owns the user research on streak-reset-as-punishment; sketched the Comeback screen concept.

*(Raj's and Lena's exact titles are inferred from their contributions, not confirmed.)*

## The Tension I'm Navigating

*Shifted 2026-09-16.* The old tension — a tangible solution competing with an unvalidated problem — resolved when Marcus approved Option C. The replacement is narrower and sharper: **the direction is approved and the problem is still unvalidated.**

Query 1 could still show the 9-point loss sits with users who never established a streak at all, in which case **none of the three approved features addresses it.** My job now is making sure that query actually runs, and that the gate holds if the answer is inconvenient. An approved direction creates pressure to treat a gate as a formality.

Still true: every number in the design is an assumption, and the full squad is committed this quarter.

## The Decision — resolved

**Thursday resolved it.** Marcus approved the recommendation as written: **Option C as the direction** — Comeback Screen + Freeze + Weekly Streak — with **validation funded and the release gated on Query 1**, not assumed by it. Recorded 2026-09-16.

**Still open, and all four were needed at that meeting:**

- **Owner and date for Query 1** — the gate the release now depends on.
- **Owners for the two fast tracks.**
- **A recovery target.** Still no number and no timeframe.
- **Whether to instrument for attribution**, given all three features ship together.

None of these is captured anywhere. Treat them as gaps, never as settled.

## Standing Constraints and Context

- **Capacity:** full squad — engineering, design, data — committed this quarter to retention.
- **Build constraint:** the Comeback concept requires no new data sources. Targeting logic and streak-freeze rules are unbuilt.
- **Evidence confidence tiers, to be respected in any document:**
  - *Verified:* Day-7 at 39% vs. 48% baseline (retention dashboard).
  - *Documented, qualitative:* streak reset reads as punishment (Lena's research).
  - *Directional only, unvalidated:* two consecutive misses → ~2x churn (Raj, one evening of analysis). Most persuasive number we have and the least tested. Do not let it carry a frame.
  - *Not established:* that v2 caused the decline. Correlation in time only; confounds unexamined.
- **No target set** for recovery — neither a number nor a timeframe. Treat as an open question, never as assumed.

## How I Want Claude to Work With Me

- **Interview first:** ask clarifying questions before building. One at a time when the goal is understanding what I actually need.
- **Tone:** direct and concise. If a word can come out and the point survives, take it out.
- **Defaults:** concise with section headers. Name decisions needed, next steps, risks, and dependencies explicitly. Assume an executive audience. Label evidence by confidence rather than flattening it. Distinguish what I said from what was inferred.
- **Never:** invent details to fill a gap — say the gap exists. Never let a solution get treated as settled while the problem underneath is open. Never harden a directional number into a fact.
- **Prompt me to save:** when a session produces something that belongs in a tracked file, say so before the session ends — don't wait to be asked. Triggers: a decision gets made or reversed (→ `change_log.md`), the hypothesis or its confidence tiers shift (→ `strategy.md`), phase/squad/stakeholders/capacity change (→ `project.md`), an open question gets answered or a new one opens, or we create a new artifact that future sessions will need. Name the file, name the change, ask before writing. This applies to any file we add later, not just the three core ones.

## Tracked Files

| File | Holds |
|------|-------|
| `CLAUDE.md` (root) | Always-on context: product, squad, tension, open decision, constraints, working preferences. |
| `01-orient/project.md` | What Streakly is, goal, bet, not-doing, current phase, squad and stakeholders. |
| `01-orient/strategy.md` | The retention hypothesis, confidence tiers, what must be true, parked interventions. |
| `01-orient/change_log.md` | Running decision log, newest first, plus unassigned items pending owners. |
| `01-orient/problem-brief.md` | **Historical as of 2026-09-16.** Was Thursday's pre-read. Body kept unedited; the banner records that none of its four questions came back answered. Useful as the record of what was asked before the decision, not as current state. |
| `01-orient/validation-plan.md` | How we validate the *problem* (the replay validates the solution). Splits the problem statement into four claims, specifies three data queries plus an interview plan, pre-registers kill conditions, and sets an achievable bar. Query 1 — decomposing the 9-point decline — was not captured anywhere before this. Proposed, unassigned. |
| `01-orient/orientation.md` | Course module map. Points to the files above; holds the parked PRD skeleton. |
| `02-research/interview-synthesis.md` | Three-stage user interviews (retained / churned / week-1). Five themes, tensions, and the week-1 insight that harm may precede any reset. n=3, directional. |
| `02-research/nps-analysis.md` | 10 NPS verbatims coded by theme and ranked. Findings report written to share with Marcus. Verbatims only — no scores, so no NPS figure can be derived. |
| `02-research/competitive-matrix.md` | Primary-source scan of Duolingo, Babbel, Elevate, Brilliant, Finch, plus Lumosity as the do-nothing control. Two white-space gaps. Section 6 is a "do not quote" list of unverified figures — read it before using any number. |
| `docs/pm-brief.md` | PM brief for the Comeback screen prototype, with the approval context and the persona's actual state under the approved design. |
| `docs/hypothesis.md` | **Revision 2.** Learning synthesis — what we know / assume / don't know — plus the hypothesis, now split into arms because the pre-emptive prompt is actively predicted to backfire. Carries assumption 0: that the streak motivates users intrinsically, never examined and sitting beneath the whole design. |
| `docs/codebase-summary.md` | Study of the Habitica open-source repo as the closest production analogue to Streakly. **Reference only** — contributions paused, non-standard licence, nothing liftable. Key findings: no scheduler for day rollover (threatens our pre-emptive trigger), best-ever streak cannot be derived after the fact, and their streak is per-task where ours is per-user. |
| `docs/triad-session.md` | 30-minute triad working-session agenda (Trevor / Raj / Lena) and the post-session alignment template. The Lena 1:1 is a stated prerequisite, not an agenda item. |
| `prototype/index.html` + `README.md` | Clickable Comeback-surface prototype: lock-screen entry, three trigger states, and a "How streaks work" explainer. README carries the interview decisions and the persona findings. No user has seen it. |
| `02-research/decision-brief.md` | Pre-read for Marcus, **revision 5** — deliberately ordered problem-first, solutions-second, recommendation-last, because that is what he asked for. Part 1 is findings + evidence status + the one query that could invalidate everything; Part 2 is the three features, a coverage matrix and options A/B/C. Recommends **C as the direction with the release gated on Query 1**, and names exactly what proceeds vs holds meanwhile. Notes that Reddit was unobtainable and the user-voice layer is Hacker News / Clozemaster, not Reddit. |
| `05-decide/counterfactual-replay.md` | Handoff-ready analysis spec for Raj. Replays **both** layers of Candidate 3 — daily streak + freeze bank, and weekly goal + miss bank — against historical activity. Six queries, pre-registered kill conditions, and a priority order if time is short. Gates the candidate. Proposed, unassigned. |
| `05-decide/experiment-26of30.md` | **Superseded 2026-09-14** — specifies a 2×2 factorial with a freeze arm that no longer exists, against a quota since redesigned. The staged ladder (counterfactual replay → concept test → painted door → A/B), guardrails and falsification conditions are still sound; the arms are not. Needs rewriting as a two-arm test of Candidate 3. |
| `skills/weekly-status/SKILL.md` | The weekly leadership update skill. Raw notes in; Shipped / In Progress / Blockers / Next Week out, 3 bullets max per section. Streakly assumptions isolated under "Streakly context" — update that section when audience, metric, or phase changes. |
| `skills/weekly-status.md` | Pointer to the above. Don't edit; edit the SKILL.md. |

## Glossary (my product's words)

| Term | Meaning |
|------|---------|
| Streak | Consecutive days with a completed lesson. The core habit loop. |
| Track | The skill path a user selects and progresses through. |
| Fast track | *Process term, unrelated to Track above.* A work item deliberately run ahead of the Thursday problem-validation gate. Qualifies only if it is cheap, evidence-backed, and **independent of whether v2 caused the decline** — so it can move without resolving the open causal question, and presumes neither candidate. Two exist: notification quality, and an acknowledgment moment inside week 1. Both listed in `01-orient/strategy.md`, both unassigned. |
| Streak reset | Counter returning to zero after a missed day. The suspected failure point. |
| Drift path | Churn with no streak break — a user fades out or forgets the app rather than losing a streak. A second, distinct failure mode alongside streak reset, and one that break-triggered fixes cannot reach by construction. Directional: two independent sources (a day-4 interviewee with her streak intact, two NPS respondents). Not established as material in week 1. |
| Streak freeze | Protects the daily streak from a single miss. **Only ever earned — never bought, never gifted** — one per perfect 4-week block (signup-anchored, zero misses). Auto-applied, with a notification so it is never spent silently. Protects the daily streak **only**: the day still counts as a miss against the weekly goal, and a frozen day does **not** count as perfect for earning. *History: eliminated outright on 2026-09-14, then reintroduced the same day in this earned-only form. A purchasable or gifted freeze is what the devaluation risk in `01-orient/strategy.md` rules out — that is the line to defend.* |
| Freeze bank | Where freezes accumulate. **Cap 7**, sized to absorb a week-long absence. **One freeze is seeded at the start of each of the first 3 blocks** — days 1, 29, 57 — on top of anything earned; then seeding stops. A perfect user caps on day 113. Seeds buy three buffer days across 12 weeks rather than removing the cliff, and **a new cliff appears at day 85**: a user who has not managed 28 perfect days by then drops to zero protection until they do. Anything earned or seeded at cap is lost. **No progress meter ships** — the rule is discoverable and the award celebrated, but progress toward it is never displayed. |
| Comeback screen | Lena's concept: best-streak stat + 60-second comeback lesson, shown when a streak breaks. **Amended 2026-09-14 — the one-tap freeze was removed** along with the freeze itself. Parked pending problem validation. Candidate 1 in `strategy.md`. |
| 26-of-30 goal | **Superseded 2026-09-14** by the monthly goal below. Was a quota over a fixed first-30-days window sitting alongside the freeze. Kept so older entries stay readable; do not scope from it. |
| Weekly goal | Finish the week having missed **at most 1 day**, plus anything drawn from the miss bank. Weeks are **signup-anchored** (days 1–7, 8–14…), so week 1 maps exactly onto the Day-7 window and no partial weeks exist for anyone. Always stated to users as an allowance — *"miss up to 1 day a week"* — never as "6 of 7". Visible from day 1. Part of Candidate 3. Replaced the monthly version on 2026-09-14 because a weekly payoff lands on day 7, inside our core metric. **Every number in this layer is an assumption, not a finding.** Trade-off accepted: signup-anchored weeks don't align across users, so weekly leaderboards or leagues are off the table. |
| Miss bank | Unused weekly misses accumulate, **cap 3**, auto-applied. **New accounts start with a full bank of 3**, so week 1 has 4 misses available. Seed equals cap, so it is one number, not two: *start fully protected, re-earn protection by showing up.* Converts tolerance from granted permission into earned savings, and covers clustered absence — travel, illness — for consistent users. Because seed equals cap, this single number fixes both week-1 protection and the size of the day-8 cliff. |
| Week streak | Consecutive weeks in which the weekly goal was met. The second of two currencies: the daily streak measures perfection, the week streak measures consistency. |
| Last-gasp save | Opt-in recovery for a failed week: complete **7 consecutive days** and the week streak is preserved. A failed attempt does **not** consume one. **Four per account year** (12 months from signup), available from the first week. Earned by performing the run rather than stockpiled in advance — which is why it devalues nothing. |
| Day-7 retention | Share of new users still active on day 7. Core metric. |
| v2 redesign | The streak redesign that shipped before the decline. Causal role unconfirmed. |
