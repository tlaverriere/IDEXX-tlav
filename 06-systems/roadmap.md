# Comeback Coach — 6-Month Roadmap

*2026-09-17 · Trevor Laverriere · one agent added per month*

## Ground rule

Every month below closes a gap **already named somewhere in this project** — in an agent's
own Boundaries section, in `registry.md`, or in a file this stack already reads. None of
these are invented for the exercise; the sequencing is the actual judgment call.

---

## Month 1 — Production Data Bridge

**Closes:** the gap every one of the three built agents states in its own header — no live
connection to Streakly's production database. All three run against `data/*.csv`, the same
sample set used since `metric-findings.md`.

**Why first:** it's not a fourth PM-facing agent, it's the thing that makes the other three
stop being "proven against sample data" and start being real. Every later month compounds
on this one — an experiment-readout agent or a CAC agent watching a CSV snapshot is exactly
as fictional as the current three are.

**Risk:** this is an infrastructure ask, not a PM one — it competes with Query 1 and the
full test for Raj's time. **Sequencing argument for doing it anyway:** it's a one-time cost
that every later agent stops paying, versus a recurring cost paid by nobody being able to
trust a single digest from this stack.

---

## Month 2 — Break-Rate Driver Tree

**Closes:** the gap `anomaly-diagnosis.md` names in its own §1 and `registry.md` repeats —
Metric Pulse can alert on streak-break rate independently of Day-7, but the built
decomposition only covers a Day-7-triggered run. A break-rate-only alert currently has
nowhere to go.

**Why second:** it's the cheapest month on this list — same agent, same rule-table pattern,
a second driver tree (day-2 miss rate, freeze-consumption rate, notification tone) instead
of the first one. Doing it before Month 1's data bridge lands means it's provable on sample
data the same way the first tree was, and ready the day real data arrives.

**Risk:** the three-driver pattern from the Day-7 tree may not transfer — break rate's real
drivers might need a field nobody's captured yet (a break counter, named as a gap in
`metric-diagnosis.md` H4). Worth a half-day of "do we have the columns" before committing
the month.

---

## Month 3 — Experiment Readout Agent

**Closes:** a gap that doesn't exist yet but will the day the full test starts — nobody is
watching `data/experiment-design.md`'s three pre-registered leading indicators (daily active
users trend, freeze-consumption rate, drop-off-day distribution) or its pre-registered kill
conditions once real enrollment begins.

**Why third:** timed to the calendar, not to convenience — if Query 1 clears the gate on
schedule and the full test launches, this is the month it would actually be running. An
agent that watches kill conditions weekly is worth far more mid-experiment than built after
the fact.

**Risk:** if Query 1 comes back showing the loss sits with never-started users, the full
test as specified may not run at all, and this agent has nothing to watch. **Named
explicitly rather than assumed away** — this month's build is conditional on the gate
actually clearing in the direction the test assumes.

---

## Month 4 — CAC / Cohort-Quality Agent

**Closes:** Query 1c's still-open half. `docs/cac-request.md` asks finance for paid CAC and
has no named owner as of this pass; once one exists and a number lands, nothing watches
whether it drifts, or whether the paid-channel quality issue this stack's own test runs
kept flagging as noise (`metric-diagnosis.md` cause 3, n≈34 caveat) turns out to be real at
production scale.

**Why fourth:** it's genuinely blocked until Month 1 (real data) and a finance answer exist
— building it earlier means building against another CSV snapshot for a number that's
already flagged as noise-suspect at this sample size.

**Risk:** depends on an external team (finance) supplying an input this project doesn't
control the timeline for — same risk `cac-request.md` already carries, inherited rather than
solved by adding an agent on top of it.

---

## Month 5 — Stakeholder Update Agent

**Closes:** the gap between `skills/weekly-status` (a calibrated, per-stakeholder template
that exists but has to be invoked by hand every week) and Weekly Insight (one aggregate
digest, nobody's voice in particular). The skill already knows how to write for Raj, Lena,
and Marcus differently — nothing runs it on a clock.

**Why fifth:** it's the one month that's pure PM-process automation rather than data
infrastructure, deliberately placed after the data-facing months so it can pull real numbers
into those calibrated formats instead of restating Weekly Insight's own placeholders.

**Risk:** `skills/weekly-status`'s own pre-flight check exists because status updates have
already reported work that never happened (the Reddit analysis) and roleplay as research.
Automating delivery without automating that check would ship the exact failure the skill
was built to catch, faster.

---

## Month 6 — Learning Loop, scheduled

**Closes:** the gap `learning-loop.md` names honestly this pass — the scoring mechanics
exist and are proven against a simulated fixture, but nobody has adopted the `[SCORE:
hit|partial|miss]` tag in the real `outcome-log.md`, and the loop itself isn't on a
schedule; it was run once, by hand, this session.

**Why last:** it's the agent that watches the other five. Running it before Months 1–5 exist
means scoring a stack that's mostly still proving itself against sample data — the loop
needs real outcomes accumulated across real weeks to say anything besides "n too small."
Placing it last is also the honest admission that a system correcting its own heuristics
needs the most evidence before anyone should trust its proposals.

**Risk, stated exactly as `learning-loop.md` does:** this loop proposes, a human approves —
**that rule does not get relaxed just because it's now on a schedule.** A scheduled version
of "propose one heuristic update" is still not a scheduled version of "apply one."

---

## What this roadmap deliberately doesn't include

No sentiment-analysis agent, no generic "engagement" agent, no agent invented because a
6-month roadmap conventionally has one. Every month above traces to a gap a real file in
this project already named. If a 7th month were needed, the honest next step is re-reading
`registry.md` and `learning-loop.md` for what they flag as still open — not brainstorming a
new persona.
