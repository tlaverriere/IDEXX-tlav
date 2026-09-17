---
name: weekly-status
description: Turn raw bullet-point notes into a weekly update, calibrated to its audience — a leadership update for Marcus (Shipped / In Progress / Blockers / Next Week, three bullets each, one page) or a squad update for Raj and Lena (a block each, matched to how they read). Use whenever the user pastes rough weekly notes, asks for a status update, a weekly update, a leadership update, an exec update, a team update, a status readout, or asks "what do I send Marcus this week" / "what do I tell the team." Trigger even when the user does not say the word "status."
---

# Weekly Status Update — Streakly

Convert raw notes into an update the reader can act on. **The same notes produce two
different documents** — leadership reads for decisions they own, the squad reads for
what is theirs to do.

## Input

Raw bullet-point notes in any state: fragments, shorthand, unsorted, mixed tenses,
duplicates. Assume nothing is pre-categorized. Do not ask the user to clean them up
first — that is this skill's job.

If the notes are too thin to fill a section, say the section is empty. Never pad it.

## Which update to write

- Asked for a **leadership / exec / Marcus** update → **Format A** only.
- Asked for a **team / squad / Raj and Lena** update → **Format B** only.
- Asked for a weekly update with no audience named → **write both**, A first. They
  are cheap together and the difference between them is the point.

## Pre-flight check — run this before writing anything

**Verify every "Shipped" claim against the repo.** Raw notes carry aspirational and
half-remembered items, and a status update is the worst possible place to discover
that. For each shipped line, name the artifact that proves it. **If there is no
file, it is not shipped.**

Three failure modes, all observed in practice:

1. **Work that never happened.** A source that was requested, turned out to be
   unobtainable, and got remembered as done. *Do not report it. Say the gap exists.*
   Known instance: a Reddit sentiment analysis. Reddit was unobtainable; the
   external-voice layer is Hacker News / Clozemaster inside
   `02-research/competitive-matrix.md`. A `competitive-reddit.md` has been asked for
   repeatedly and has never existed.
2. **Roleplay reported as research.** "Tested with users" when it was personas.
   **This costs more with Lena than with anyone else**, because she owns the
   research and will discount everything around it once she finds one instance.
3. **Understated items.** Notes say 70%; the artifact is complete. Correct upward
   too — accuracy runs both directions.

State any correction to the user in your reply. Do not silently fix a shipped item
and move on.

---

# Format A · Leadership update, for Marcus

Exactly four sections, in this order, three bullets maximum each:

```
## Shipped
## In Progress
## Blockers
## Next Week
```

One line per bullet. No sub-bullets, no nesting. **Precede it with a Slack covering
line** carrying the headline and the ask — his profile wants the recommendation
first, while the document stays problem-first.

### What belongs in each section

**Shipped** — landed and verifiable this week. Not "mostly done," not "in review."
If it isn't live or delivered, it belongs in In Progress.

**In Progress** — active work with a stated next milestone. Each bullet says what is
happening and when it lands. "Ongoing" is not a milestone.

**Blockers** — anything stalled that needs a decision or resource the squad does not
control. Each blocker names what is stuck, what would unstick it, and who can
unstick it. **A blocker with no named owner is not a blocker, it is a complaint.**

**Next Week** — committed work, not aspirations. If it depends on a blocker
clearing, say so.

### The three-bullet cap

Hard cap. When a section has more than three candidates, rank by **leadership
relevance**: keep the items that change what a leader decides, funds, or escalates.
Deprioritize activity that is merely true.

1. Changes a decision Marcus is about to make
2. Moves or threatens Day-7 retention, the squad's core metric
3. Changes scope, timeline, or capacity
4. Everything else

Then list what was cut, below the four sections:

```
*Cut for length: [item], [item]. Say the word if any should be in.*
```

Never drop an item silently. The cap controls the update's length, not the user's
awareness.

### Rules specific to Marcus

- **One page. Hard.** He pushes back on anything needing more than a page.
- **Connect each item to Day-7, or say why it does not connect.** He pushes back on
  data that does not connect to a business outcome.
- **Do not sell. He notices.** Report what did not work before what did. If a number
  we previously quoted has weakened, say so before he asks.

---

# Format B · Squad update, for Raj and Lena

Two readers with opposite intake preferences. **Do not write one generic block** — a
shared state section, then a block each.

```
## Where we are
[2 lines maximum. State only, no narrative.]

## Raj — what's yours
- [What is decided, what is not, what you need from him.]
- [Answers to anything he has asked before, with the file that holds it.]
- Nothing here should be new to you in standup.

## Lena — what's yours
- [Link the thing to look at, first. Not a description of it.]
- [Evidence labelled honestly: real users vs persona exercise.]
- [What is hers to decide, stated as hers.]

## Open, needs a name
- [Item — and who can unstick it.]
```

**No bullet cap here** — the squad needs completeness, not brevity. Still rank, so
the first bullet in each block is the one that changes their week.

### Rules specific to Raj

- **Bullets, never paragraphs.**
- Name acceptance criteria, edge cases and rollback where they exist, and say
  plainly where they do not. He pushes back on underspecified requirements.
- **Flag anything that would grow scope mid-sprint**, especially dependencies that
  do not exist yet.
- Anything touching the streak or notification pipeline states its rollback path.
- **Answer his standing questions or admit they are still open** — he has asked
  *"how will we know if this is working?"* more than once.
- Everything that will come up in standup goes here first. He does not like being
  surprised in the room.

### Rules specific to Lena

- **Lead with the artifact, not a summary of it.** She prefers to see things rather
  than read about them. Give her the file to open.
- **Label evidence precisely.** *"A persona predicted"* — never *"users told us"* —
  for roleplay output. `"Here is what users told us"` is the framing she trusts, and
  spending it on a persona exercise is how you lose it.
- **Flag PM-written copy as placeholder before she finds it.**
- State what is hers to decide **as hers**, not as a request for input.
- Watch cognitive load. If an update needs six concepts explained, that is itself
  the finding.

---

# Writing rules — both formats

Plain declarative sentences. Subject, verb, object. State what happened.

**No jargon.** Reject: leverage, align, circle back, synergy, bandwidth, north star
(except as the literal metric), robust, seamless, delightful, low-hanging fruit,
double-click, level-set, socialize, land-and-expand, learnings, ideate,
operationalize.

**No hedging.** Cut "we think," "it seems," "roughly," "hopefully" unless the
uncertainty is the point — in which case state it as uncertainty, with the reason.

**Numbers carry their confidence.** Never present a directional or unvalidated
figure as settled. Write "Raj's early read suggests ~2x churn after two missed days,
not yet validated" rather than "churn doubles." This is a standing rule for this
squad, not a stylistic preference. *(That figure has since been questioned —
sample-data analysis on 2026-09-17 put the churn relative risk at 1.24–1.34.
Direction supported, magnitude unsettled. Stop writing "~2x" unqualified.)*

**Name decisions, risks, and dependencies explicitly.** If the week produced a
decision Marcus needs to make, it goes in his Blockers with what it blocks.

---

# Streakly context

This skill assumes the current situation. **Update it when the situation changes** —
check against `CLAUDE.md` before relying on it. *Last refreshed 2026-09-17.*

- **Marcus** — holds the greenlight. Reads for decisions he owns. Pushes back on
  anything needing more than one page, and on recommendations without a clear ask.
- **Raj** (engineering) — async first, bullets over paragraphs, does not like being
  surprised in standups. Needs acceptance criteria, edge cases, a definition of
  done, and a rollback plan for the streak or notification pipeline.
- **Lena** (design/research) — prefers to see things rather than read about them.
  Owns both the research and the design, so she is the only person who can say
  whether a design contradicts the research. Pushes back on PM-written copy and on
  unexplained cognitive load.
- **Stakeholder profiles** are in `stakeholders/` — **local only, gitignored.** Use
  them to calibrate; never quote them into a shared document.
- **Core metric:** Day-7 retention. Currently 39% against a 48% pre-v2 baseline.
- **Recovery target, set 2026-09-16: Day-7 above 50% within 4 weeks of launch.**
  Note this is *above* the old baseline, not a return to it — **a 47% result
  reverses the decline and misses the target.** Never report progress against
  "reversing the decline" and the target interchangeably; they give opposite
  verdicts on the same number.
- **Phase:** *direction approved, release gated.* Marcus approved **Option C** on
  2026-09-16 — Comeback Screen + Freeze + Weekly Streak — with the release **gated
  on Query 1** rather than assumed by it. Design, copy, instrumentation groundwork
  and both fast tracks proceed; **production streak-accounting changes hold** until
  Query 1 lands. An update implying accounting work has started misrepresents the phase.
- **The Comeback screen is no longer parked.** Approved, and a clickable prototype
  exists. **No user has seen it.**
- **Query 1 is assigned — Raj, due Wednesday 2026-09-23.** *(Was a standing blocker
  for four days; assigned 2026-09-17.)* The release is still gated on it, so it
  belongs in **In Progress with its date**, not in Blockers — and **it moves back to
  Blockers if the date slips**, because the gate is on the record as the reason the
  approval was sound. Handoff at `docs/query1-handoff.md`.
- **Still genuinely unassigned, and these are the Blockers now:** a CAC input for
  Query 1c (finance, not Raj), owners for both fast tracks, and the 8–12 week-1
  interviews.
- **Do not report the week-5 pilot as a win.** Its +30 pp Day-7 result does not hold
  — 17.6 of the 30 points come from users who never saw the feature, and day-7 was
  never observed in the data. The defensible result is the **return visit**
  (100% vs 14%). See `data/metric-findings.md`.

---

# Worked example · Format A

> **Dated snapshot — these notes are from 2026-09-14**, before Marcus approved
> Option C and before the recovery target was set. Read it for the *transformation*,
> not for current state: the "no recovery target" blocker below was real then and is
> answered now.

**Raw notes in:**

```
- raj pulled the release timeline for the v2 window, found two other
  changes shipped same week, need to untangle
- lena's research writeup is done and circulated
- still no owner for the churn validation, asked twice
- thursday meeting happened, team agreed on problem statement
- need target number from marcus, can't size anything without it
- started sketching freeze rules, paused
- fixed the streak counter timezone bug
```

**Update out:**

```
## Shipped
- Thursday alignment meeting: the squad agreed on the problem statement.
- Lena's research write-up on the streak reset is complete and circulated.
- Fixed the streak counter timezone bug.

## In Progress
- Raj is untangling the v2 release window. Two other changes shipped the
  same week, so the decline cannot yet be attributed to the redesign.
  Read expected next week.

## Blockers
- No owner for validating the two-missed-days churn figure. Asked twice.
  Needs Marcus to assign someone. Until it lands, we cannot confirm that
  week-1 streak breaks are the right intervention point.
- No recovery target set. Marcus's call. Without a number we cannot judge
  whether any fix is worth building.

## Next Week
- Close out the v2 causality read.
- Get the churn figure validated, once an owner exists.

*Cut for length: streak-freeze rule sketching (paused, and the phase is
discovery — reporting it would imply design has started).*
```

What the example does: moves the agreed problem statement into Shipped because it is
a real deliverable, keeps the unowned validation as a Blocker with a named decider,
and cuts the freeze-rule sketching because reporting it would have misrepresented
the phase.

# Worked example · Format B

*Week of 2026-09-17. Note the pre-flight check firing three times — a Reddit
analysis that never happened is dropped, "tested across three personas" is relabelled
as a persona exercise, and a PRD reported at 70% is corrected upward to complete.*

```
## Where we are
Research is done and the PRD first draft is complete — docs/prd.md, scoped to
the post-break surface only. Five usability sessions being scheduled, 3 of 5
confirmed. No user has seen the prototype yet.

## Raj — what's yours
- Freeze data model: the field spec has been ready since Monday in
  01-orient/strategy.md. Per docs/codebase-summary.md it is all new storage.
  What's outstanding is your estimate, not the spec.
- Two PRD stories depend on things that don't exist — the empty state and a
  break counter for the once-per-7-days cap. In the sprint or explicitly
  deferred; if the counter lands mid-sprint that's scope growth.
- Rollback is currently filed as a question to you, which is the wrong way
  round. It should be an acceptance criterion. I'm fixing that.
- Your standing question still has no number: the PRD names the metric
  (return rate among breakers, not Day-7) but sets no threshold. On me.
- Nothing above should be new to you in standup.

## Lena — what's yours
- Look at docs/prd.md first. The empty state is user story 2 because it's
  blocking design sign-off.
- Evidence status: the prototype has been run against three personas. That
  is a persona exercise, not user testing. Week-1 evidence is still n=1.
  The 5 usability sessions change that; 3 are confirmed.
- All copy in the PRD and prototype is PM-written placeholder, including the
  load-bearing lines. Flagging before you find it.
- Yours to decide: the register question — forgiving or guilt trip. The
  breakdown currently stacks two failures vertically and reads as a receipt.

## Open, needs a name
- CAC input for Query 1c. Finance or growth, not Raj.
- Both fast tracks still have no owner.
```

What the example does: gives Raj file paths and scope consequences, gives Lena an
artifact to open and an honest evidence label, and states the register question as
hers rather than asking her to weigh in on it.
