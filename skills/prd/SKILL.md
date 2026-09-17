---
name: prd
description: Write a one-page PRD grounded in the project's own research files, with Problem Statement, User, Goals, Non-Goals, Success Metrics, User Stories and Open Questions — every claim attributed to a source and every open question assigned to the person who must answer it. Use whenever the user asks for a PRD, a product requirements doc, a spec, a feature brief, a requirements write-up, or says "write this up for engineering and design" / "turn this into a spec." Trigger even when the user does not say the word "PRD."
---

# PRD — one page, grounded

Write a PRD an engineer and a designer can act on. The audience is the squad, not
leadership: they need precision and acceptance criteria, not persuasion.

## Read before writing

**Never write a PRD from memory or from the conversation alone.** Read the research
files first, then write. A PRD's whole value is that every claim in it is traceable.

1. **Ask which files to read, or take the list the user gives.** If they name files,
   use their list.
2. **Verify each path exists before citing it.** If a path is wrong, find the real
   one and say so in your reply. Do not silently substitute.
3. **If a named source does not exist, say so in the document.** One line in the
   sources block: what was requested, that it does not exist, and what stands in
   its place. A phantom file in a source list makes every other citation
   untrustworthy.
4. **Read the stakeholder profiles for the named readers if they exist.** They
   determine what level of detail each section needs. If there are no profiles, ask
   who the readers are before calibrating.

## Output format

Seven sections, in this order. Do not add sections.

```
Problem Statement
User (who, job to be done)
Goals
Non-Goals
Success Metrics
User Stories
Open Questions
```

Open with a two-line header: **Scope** (what this PRD covers and what is specified
elsewhere) and **Sources** (the files read, with their confidence in parentheses).

### Problem Statement

Four to six bullets. **Every bullet carries its source inline** — a respondent ID, an
interviewee name with a verbatim quote, a named document, or a figure with its
provenance. A bullet with no source does not go in.

Close with what is **not established**. If causality is assumed anywhere, name it
and say correlation is all there is.

### User

**Who** — one sentence. State the lifecycle stage, and if the evidence is
stage-mixed, say so.

**Job to be done** — one sentence in the user's voice: *When [situation], I want to
[motivation], so that [outcome].*

**Then: who this explicitly does not serve.** Two or three bullets, each with
evidence. This is the section most often skipped and the one that prevents the most
rework — a surface that fires on a trigger cannot reach users who never hit it, and
saying so upfront stops that being discovered in QA.

### Goals

Numbered, five maximum. Each states an observable product behaviour, not an
aspiration. "Acknowledge the break explicitly" is a goal; "delight the returning
user" is not.

### Non-Goals

A two-column table: **what is out of scope**, and **where it lives**.

Every exclusion routes somewhere: another spec, a separate track, a dated decision
that cut it, or an explicitly acknowledged coverage gap. **An exclusion with no
destination reads as a dismissal and will be relitigated.** When something was cut
by a decision, cite the date.

### Success Metrics

A table: primary, supporting, guardrails — each with a reference point so the reader
knows what "good" would look like.

**The check that matters: does this feature own the metric you just assigned it?**
A component feature must not borrow the program's headline metric. If the audience
for this surface sits outside the window the metric measures, attributing it here
makes the feature unfalsifiable. Say which layer owns the headline number instead.

Guardrails are mandatory. At least one should be a metric that would reveal the
feature doing harm, not just failing.

### User Stories

Three to five, as a table: story, then **acceptance criteria**. Criteria state
observable conditions — what renders, from which data source, and what the state is
after the action.

**Include the hard cases, not just the happy path.** At least one empty or degraded
state, and at least one repeat/frequency case. **Where a story depends on something
that does not exist yet, say so in the criteria** — "requires a break counter, which
does not exist" is the single most useful sentence you can hand an engineer.

### Open Questions

**Split by who must answer them.** Lead with anything that gates the release, then a
block per named reader.

Each question is answerable — it names the decision, not the topic. "Rollback path"
is a topic; "what is the revert for this surface and the counters it writes" is a
question.

**Close with an evidence-status paragraph.** State plainly what has and has not been
tested, the real n, and whether any input is a persona exercise rather than user
research. Never present roleplay output as "what users told us."

## Writing rules

Plain declarative sentences. Subject, verb, object.

**No opinions.** A PRD records decisions and their sources. Cut "I recommend," "we
should probably," "the elegant solution is." Where a decision has been made, state
it and cite where. Where it has not, it belongs in Open Questions.

**No jargon.** Reject: leverage, align, circle back, synergy, bandwidth, robust,
seamless, delightful, low-hanging fruit, double-click, level-set, socialize,
learnings, ideate, operationalize, frictionless, best-in-class.

**Numbers carry their confidence.** Never harden a directional figure. Write
"4 of 10 NPS respondents, directional — no scores in the set" rather than "40% of
users." Label sample sizes at the point of use, not only in the sources block.

**Quote users verbatim.** A paraphrase loses the evidence. Short quotes beat
summaries.

## One page

Target **900–1,000 words of prose.** Tables compress on the page, so table content
sits outside that budget — but 20 table rows is a practical ceiling.

When over, cut by this order:
1. Repeated evidence for a point already made
2. Background the readers already hold
3. Secondary competitive detail
4. **Never** cut source attribution, acceptance criteria, or the evidence-status note

If it still will not fit, say so in your reply rather than claiming one page. A
reader who is told "this is a full page, not a comfortable one" trusts the rest of
the document more.

## Streakly context

This skill assumes the current situation. **Update this section when the situation
changes** — check it against `CLAUDE.md` before relying on it.

- **Readers:** Raj (engineering) and Lena (design/research). Profiles in
  `stakeholders/` — local only, gitignored, never quote them into a shared doc.
- **Raj needs:** acceptance criteria, edge cases upfront, a definition of done, and
  a rollback plan for anything touching the streak or notification pipeline. Bullets
  over paragraphs. He does not like being surprised in standups — open questions for
  him must reach him in writing first.
- **Lena needs:** every point tied to real user evidence, the empty state defined,
  and copy identified as placeholder where a PM wrote it. She pushes back on
  cognitive load and on copy that reads like a PM wrote it. **She owns the research
  and the design**, so misrepresenting a persona exercise as a finding costs more
  with her than with anyone else.
- **Core metric:** Day-7 retention, 39% against a 48% pre-v2 baseline. Target >50%
  within 4 weeks of launch.
- **Standing constraint:** the release is gated on Query 1, which decomposes the
  9-point decline. It is still unowned. Any PRD for a streak feature names it as the
  gate.
- **Research files, with their real paths and confidence:**
  `02-research/interview-synthesis.md` (n=3, one per lifecycle stage, directional) ·
  `02-research/nps-analysis.md` (10 verbatims, **no scores — no NPS figure can be
  derived**) · `02-research/competitive-matrix.md` (**read §6 "do not quote" before
  using any number**) · `02-research/decision-brief.md` (what Marcus approved) ·
  `docs/hypothesis.md` (what we know / assume / do not know) ·
  `docs/spec-readiness.md` (truth table, scope cuts) · `data/metric-findings.md` and
  `data/metric-diagnosis.md` (**synthetic data — direction only, never a rate**).
- **Note:** people sometimes write `research/` for `02-research/`, and
  `docs/decision-brief.md` for `02-research/decision-brief.md`. A
  `competitive-reddit.md` has been requested more than once and **has never
  existed** — Reddit was unobtainable, and the external-voice layer is Hacker News /
  Clozemaster inside the competitive matrix.

## Worked examples of the four moves that matter

**1 · Grounding.** Not the claim — the claim with its receipt.

> ✗ Users are frustrated that there is no way to recover a broken streak.
>
> ✓ **Absence of a recovery path is the most-mentioned NPS theme** — 4 of 10 (R3,
> R5, R6, R8). Tom, who churned at week 5 after a 12-day streak: *"There was no way
> to recover it, nothing. So I gave up."*

**2 · Non-goals that route.** The second column is the whole point.

> | Not in scope | Where it lives |
> |---|---|
> | Pre-emptive "last day to save" trigger | **Cut 2026-09-16** in spec review — contested by the persona it was built for, and needs a server-side evaluator that may not exist |
> | Notification tone, timing, volume | **Fast track 1** — addressed by none of the three approved features |

**3 · The metric check.** The catch that keeps a feature falsifiable.

> **Primary: return rate among users whose daily streak has broken.** This surface
> is measured on reactivation, **not** Day-7, because that audience largely sits
> outside the Day-7 window. **The >50% Day-7 target belongs to the tolerance
> layer** — attributing it here would make this feature unfalsifiable.

**4 · Acceptance criteria that name the gap.**

> | **No streak history:** I am not shown an empty trophy. | Defined behaviour when
> best-ever is 0 or null — stat suppressed below a floor rather than rendering
> *"Your best ever: 1 day."* **Unbuilt, and blocking design sign-off.** This is the
> Day-7 cohort |

The reference implementation is `docs/prd.md`.
