---
name: weekly-status
description: Turn raw bullet-point notes into a formatted weekly leadership update for the Streakly squad, with Shipped, In Progress, Blockers, and Next Week sections capped at three bullets each. Use whenever the user pastes rough weekly notes, asks for a status update, a weekly update, a leadership update, an exec update, or a status readout — or asks "what do I send Marcus this week." Trigger even when the user does not say the word "status."
---

# Weekly Status Update — Streakly

Convert raw notes into an update Marcus can read in ninety seconds and act on.

## Input

Raw bullet-point notes in any state: fragments, shorthand, unsorted, mixed tenses, duplicates. Assume nothing is pre-categorized. Do not ask the user to clean them up first — that is this skill's job.

If the notes are too thin to fill a section, say the section is empty. Never pad it.

## Output format

Exactly four sections, in this order, three bullets maximum each:

```
## Shipped
## In Progress
## Blockers
## Next Week
```

Under each section, one line per bullet. No sub-bullets, no nesting.

### What belongs in each section

**Shipped** — landed and verifiable this week. Not "mostly done," not "in review." If it isn't live or delivered, it belongs in In Progress.

**In Progress** — active work with a stated next milestone. Each bullet says what is happening and when it lands. "Ongoing" is not a milestone.

**Blockers** — anything stalled that needs a decision or resource the squad does not control. Each blocker names what is stuck, what would unstick it, and who can unstick it. A blocker with no named owner is not a blocker, it is a complaint.

**Next Week** — committed work, not aspirations. If it depends on a blocker clearing, say so.

## Writing rules

Plain declarative sentences. Subject, verb, object. State what happened.

**No jargon.** Reject: leverage, align, circle back, synergy, bandwidth, north star (except as the literal metric), robust, seamless, delightful, low-hanging fruit, double-click, level-set, socialize, land-and-expand, learnings, ideate, operationalize.

**No hedging.** Cut "we think," "it seems," "roughly," "hopefully" unless the uncertainty is the point — in which case state it as uncertainty, with the reason.

**Numbers carry their confidence.** Never present a directional or unvalidated figure as settled. Write "Raj's early read suggests ~2x churn after two missed days, not yet validated" rather than "churn doubles." This is a standing rule for this squad, not a stylistic preference.

**Name decisions, risks, and dependencies explicitly.** If the week produced a decision Marcus needs to make, it goes in Blockers with what it blocks.

## The three-bullet cap

Hard cap. When a section has more than three candidates, rank by **leadership relevance**: keep the items that change what a leader decides, funds, or escalates. Deprioritize activity that is merely true.

Ranking order:

1. Changes a decision Marcus is about to make
2. Moves or threatens Day-7 retention, the squad's core metric
3. Changes scope, timeline, or capacity
4. Everything else

Then list what was cut, below the four sections:

```
*Cut for length: [item], [item]. Say the word if any should be in.*
```

Never drop an item silently. The cap controls the update's length, not the user's awareness.

## Streakly context

This skill assumes the current situation. Update it when the situation changes.

- **Audience:** Marcus, who holds the greenlight on what gets built. He reads for decisions he owns.
- **Core metric:** Day-7 retention. Currently 39% against a 48% pre-v2 baseline.
- **Phase:** discovery. The squad is validating the problem, not designing the fix. An update that implies design has started misrepresents the phase.
- **Squad:** Raj (data/engineering), Lena (design/research).
- **Parked:** Lena's Comeback screen concept. If it appears in notes, say it is parked pending problem validation — do not report it as in progress.

## Worked example

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

Note what the example does: it moves the agreed problem statement into Shipped because it is a real deliverable, keeps the unowned validation as a Blocker with a named decider, and cuts the freeze-rule sketching because reporting it would misrepresent the phase.
