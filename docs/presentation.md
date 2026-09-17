# Narrative Structure — Quarterly Review, 6 slides

*2026-09-17 · Trevor Laverriere · backbone: `recommendation-memo.md` + `../data/metric-findings.md`*

## The spine

**One sentence:** *Retention is leaking in week 1, we have built the thing that
brings lapsed users back, the number we thought proved it does not hold, and the
gate that decides whether we are solving the right problem still has nobody on it.*

**Arc:** problem → what we learned → what we are shipping → what the evidence does
and does not support → the plan → the ask.

**Two constraints from `../stakeholders/marcus.md`, and they pull against each other:**
he asked for *the problem before the solution*, and he wants *the recommendation in
the first sentence.* Resolve it the way the decision brief did — **say the
recommendation out loud in the opening 20 seconds, then let the deck run
problem-first.** The slides stay in order; the voice leads.

**Tone discipline:** he notices when he is being sold to. The withdrawal of the
+30 pp goes on the **evidence slide**, not in an appendix. Leading with the thing
that did not work is what buys the rest of the deck.

**Density:** he pushes back on anything needing more than a page. One assertion per
slide, five lines maximum on the page. Everything else lives in the notes.

---

## Slide 1 · The problem

**Assertion:** Day-7 retention fell 9 points, and the mechanic is the cause — not the content.

**On the slide**
- **39%** Day-7 retention, down from **48%**
- One line: *every complaint targets the streak system; every piece of praise targets the lessons*

| Number | Source |
|---|---|
| 39% vs 48% baseline | Retention dashboard — **the only fully verified number in the project** |
| 3 interviews + 10 NPS verbatims, no user criticised the lessons, tracks or 5-minute format | `interview-synthesis.md` theme 5, `nps-analysis.md` §2 |

**Must not say:** that v2 caused the decline. Correlation in time only, confounds unexamined.

---

## Slide 2 · Why now

**Assertion:** This quarter we learned where the loss is — and that it is mostly not the shape we assumed.

**On the slide**
- Day-1 activation is **flat at 90–93%** across every cohort. The loss sits in **days 2–6**
- Of a 10-point decline, **more users breaking streaks accounts for 1.7 points.** The other 8.3 is users who kept their streaks and left anyway
- **5 of 5** direct competitors ship a missed-day mechanic. We ship none

| Number | Source |
|---|---|
| Day-1 flat 90–93%, loss in days 2–6 | `metric-findings.md` Q1 — synthetic data, direction only |
| 1.7 pp mix / 8.3 pp within-group | `metric-findings.md` Q2 decomposition — synthetic, directional |
| 5 of 5 competitors; Lumosity resets on first miss and is our design at maturity | `competitive-matrix.md` — primary sources, verified |
| MAU +28% YoY masks the leak at the top line | `CLAUDE.md` |

**Say out loud and do not dress up:** *the cost of the leak in acquisition spend is
still unquantified.* It is his question, asked three times, and naming it unanswered
is better than a number we do not have.

---

## Slide 3 · The proposal

**Assertion:** Ship the part the evidence supports now; hold the part that touches 2.1M users' streak state.

**On the slide — what it is**
- **Option C, as approved 2026-09-16:** Comeback Screen + Freeze + Weekly Streak
- The property that matters: **a week-1 user's first missed day costs nothing visible**
- **Ships now:** notification and Comeback surface — reversible, no streak-state migration
- **Holds for the full test:** production streak accounting

**On the slide — what it isn't**
- Not a purchasable or gifted restore. Freezes are **only ever earned**
- Not a notification-quality fix — that is Fast track 1, addressed by none of the three features
- Not a fix for drift. Weak across all three, by construction
- Not the pre-emptive warning — **cut from scope 2026-09-16**

**Must not say:** that this is a change of direction. It is the proceeds/holds split
he already approved, applied.

---

## Slide 4 · Evidence

**Assertion:** The surface works. The retention number does not — and I am withdrawing it.

**On the slide — what holds**
- **Return visit: 100% vs 14%.** Among users who actually broke a streak, **20/20 returned vs 4/25**
- The current "you lost your streak" push has a **0% action rate across 141 sends**
- Tom: *"There was no way to recover it, nothing. So I gave up."*
- NPS R7: *"The home screen looks the same whether I'm on a 2-day streak or coming back after two weeks away."*

**On the slide — what does not hold**
- The **+30 pp Day-7 result is withdrawn.** 17.6 of the 30 points come from users who never saw the screen; day-7 was never observed in the data; the study could only detect an effect of 28 pp or larger

| Number | Source |
|---|---|
| 100% vs 14%; 20/20 vs 4/25 | `metric-diagnosis.md` §3 — matched window, synthetic |
| 0% action across 141 sends | `metric-findings.md` Q4 |
| 17.6 / 8.8 / 3.6 decomposition; MDE ±27.9 pp | `metric-diagnosis.md` §3 |
| Quotes | `interview-synthesis.md`, `nps-analysis.md` |

**State the evidence tier on the slide:** interviews n=3, NPS 10 verbatims with no
scores, experiment data synthetic. **And say plainly: no user has seen the
prototype.** 5 usability sessions are being scheduled, 3 confirmed.

---

## Slide 5 · The plan

**Assertion:** Two tracks, one gate, and one number I do not have yet.

**On the slide**

| | Milestone | Status |
|---|---|---|
| Now | Notification + Comeback surface | Reversible, no migration. Kill switch in scope |
| **Gate** | **Query 1** — decomposes the 9 points by week-1 behaviour | **Raj, due Wed 2026-09-23** — so the answer is in this room, not promised in it |
| Then | Full test: MDE **5 pp**, 80% power, **1,568 per arm**, breakers pre-registered | ~3 weeks if the eligible pool is 85,000 WAU |
| Hold | Streak accounting, schema migration, external comms | Until Query 1 lands |

**Risks — three, named**
1. **Query 1 could show the loss sits with users who never established a streak.** None of the three features addresses that case
2. **The Comeback screen's audience is shrunk by the other two features and has never been sized.** Our own brief says so
3. **Reachability** — the surface's only entry point is a notification, and there is no in-app fallback

**The open dependency:** 8 weeks requires **≥1,120 new signups per week**, and we do
not hold that figure. Day-7 is a new-signup metric, so WAU is not the enrolment pool.

---

## Slide 6 · The ask

**Assertion:** One thing to reverse if you want to, and two to confirm.

**On the slide**
1. **Query 1 is assigned to Raj, due Wednesday 2026-09-23** — if Query 1 has landed by this meeting, this slide reports the finding instead. **It sat unowned for four days, so I made the call rather than wait. Reverse it now if you want it elsewhere**
2. **Confirm >50% Day-7 in 4 weeks still stands** — nothing we now hold substantiates it. If it stands, it is a commitment made on judgement, and that should be on the record
3. **Agree the +30 pp does not leave this team**, including board material, until a powered re-run

**Still unassigned, and named so they are not mistaken for covered:** the CAC input
for Query 1c (finance, not Raj), owners for both fast tracks, and the 8–12 week-1
interviews.

**Close on:** *the gate did its job — it made this checkable, and it is now owned
and dated. What it needs from you is nothing, unless you disagree.*
