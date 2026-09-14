# CLAUDE.md — Persistent Memory

> The file Claude Code reads at the start of every session. Short, true, current — the difference between Claude building blind and building with context.

## The Product

**Streakly** — a consumer habit + micro-learning app. Users pick a track and do a five-minute daily lesson; the streak is the core habit loop. Four years old, Series B ($42M), 2.1M registered users, 340K MAU, growing 28% YoY on MAU.

**Core metric: Day-7 retention.** This is the north star, which makes the current situation urgent rather than a slow leak.

**Current focus.** Day-7 retention is 39%, down from 48% following the v2 streak redesign. The loss concentrates in users who break a streak in week 1. Working hypothesis: breaking a streak reads as failure — the counter resets, the app doesn't acknowledge it, and the "you lost your streak" push lands at peak quit risk — so users go passive with no graceful way back.

## Me and the Squad

**Me:** Group PM / Director of Product. I own the area and run the working sessions, including the Thursday problem-alignment meeting.

**Marcus:** greenlights what gets built. Called the retention meeting and asked for the problem write-up. My alignment with him is the real gate on anything shipping.

**Raj:** data/engineering. Produced the "two consecutive missed days → ~2x churn" finding; confirmed the Comeback concept is buildable with existing data sources.

**Lena:** design/research. Owns the user research on streak-reset-as-punishment; sketched the Comeback screen concept.

*(Raj's and Lena's exact titles are inferred from their contributions, not confirmed.)*

## The Tension I'm Navigating

A tangible solution is competing with an unvalidated problem. Lena's Comeback screen is concrete, buildable, and emotionally right — and the causal story beneath it is unverified. My job is holding the room in the uncomfortable place long enough to check whether the v2 redesign actually caused the decline, and whether Raj's churn finding survives scrutiny.

This has a clock on it: the full squad is committed this quarter, and a committed squad with nothing to build creates pressure to start designing. Rigor has to be fast, not just correct.

## The Open Decision

**Thursday must resolve:** does the problem statement hold, and is the problem the reset mechanic, the notification, or both? Owners and dates needed for the causality check and the validation of Raj's number.

**Not yet decided, and not mine:** whether the Comeback screen gets built. That's Marcus's call, informed by Thursday.

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
| `01-orient/problem-brief.md` | Thursday's pre-read. Problem statement + evidence + questions the meeting must answer. |
| `01-orient/orientation.md` | Course module map. Points to the files above; holds the parked PRD skeleton. |
| `skills/weekly-status/SKILL.md` | The weekly leadership update skill. Raw notes in; Shipped / In Progress / Blockers / Next Week out, 3 bullets max per section. Streakly assumptions isolated under "Streakly context" — update that section when audience, metric, or phase changes. |
| `skills/weekly-status.md` | Pointer to the above. Don't edit; edit the SKILL.md. |

## Glossary (my product's words)

| Term | Meaning |
|------|---------|
| Streak | Consecutive days with a completed lesson. The core habit loop. |
| Track | The skill path a user selects and progresses through. |
| Streak reset | Counter returning to zero after a missed day. The suspected failure point. |
| Streak freeze | Proposed one-tap protection for a rebuilt streak. Rules undefined. |
| Comeback screen | Lena's concept: best-streak stat + 60-second comeback lesson + one-tap freeze, shown when a streak breaks. Parked pending problem validation. |
| Day-7 retention | Share of new users still active on day 7. Core metric. |
| v2 redesign | The streak redesign that shipped before the decline. Causal role unconfirmed. |
