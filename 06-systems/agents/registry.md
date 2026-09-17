# Agent Registry — Comeback Coach

*2026-09-17 · Trevor Laverriere · the three agents built this course, registered as one stack*

## Path note

Same normalization as the other three specs: built at **`06-systems/agents/registry.md`**,
not the literal `agents/registry.md` requested, to stay in the one folder the whole stack
lives in and that every cross-reference already points to.

## Open item this registry surfaces rather than fills in

**No agent below has a confirmed production owner.** "Owner" in the table is a
**recommendation**, not an assignment — the same distinction this project has held since
Query 1: an owner without a name, or a name without a real yes, is not an owner. The
recommendation follows the same logic Query 1 used (whoever already holds the underlying
work owns the automation of it), but neither Raj nor Trevor has said yes to this specifically.
Flagged here rather than assumed, and worth a real assignment before any of these three
actually runs unattended.

---

## 1 · Registry

| | Metric Pulse | Anomaly → Hypothesis | Weekly Insight |
|---|---|---|---|
| **Name** | Metric Pulse Agent | Anomaly-to-Hypothesis Agent | Weekly Insight Report |
| **Trigger** | Time-based | **Event-based** — chained from Metric Pulse's `AnyAlert`, never runs standalone on a schedule | Time-based |
| **Trigger schedule** | Nightly (alert check) · Monday 8am (digest delivery) | Immediately on trigger — no schedule of its own | Friday 4pm |
| **Data sources** | `data/users.csv` × `data/retention.csv`, real join, by channel and cohort week | The alerting metric's before/after values, its 3 decomposition drivers, and the watch-channel flag — **handed off by Metric Pulse, not re-derived** | `data/*.csv` (retention join), `01-orient/change_log.md` (sprint completions), `research/nps-analysis.md` (top theme), **and — new this pass — `outcome-log.md`** (see §2) |
| **Output format** | Digest: headline Day-7 + break-rate deltas, channel breakdown, alert flags, named watch-channel | Ranked hypotheses (confidence-scored, from an explicit rule table) + SQL to confirm the top one, **or** a shorter low-confidence variant that withholds SQL | 3-2-1 digest: Done this week (3) / Changed this week (2) / Watch next week (1) |
| **Delivery channel** | File on disk (`digests/*.txt`) — would be Slack once a connector exists | File on disk (`slack-drafts/*.txt`) — would be Slack; every run also appends to `outcome-log.md` | `reports/YYYY-MM-DD.md` (versioned, one file per week) + a Slack-draft file |
| **Owner (recommended, not confirmed)** | **Raj** — it's a data join over metrics he already produced the underlying finding for | **Raj** — same reasoning; the confirmation SQL is his to run regardless | **Trevor** — it's a PM-facing digest, and the judgment step (picking 3 "Done" bullets) is PM work, not data work |

---

## 2 · Connection plan

### Metric Pulse → Anomaly-to-Hypothesis (built, real)

**Interface contract**, exactly as implemented in `metric-pulse.ps1` / `anomaly-diagnosis.ps1`:

```
Metric Pulse computes AnyAlert = |delta| >= 2pt, independently for Day-7 and break rate.
  If true, it hands off:
    - TriggerMetric, CurrentValue, PreviousValue      (the alerted metric)
    - WatchChannel, WatchChannelDeltaPts               (from its own channel breakdown)
  Anomaly-to-Hypothesis re-checks the threshold itself (Step 1) rather than trusting the
  caller — it can be invoked directly, not only via this hand-off — then decomposes,
  generates hypotheses, and logs every exit to outcome-log.md.
```

**One gap named, not solved:** this only covers a Day-7-triggered run. Metric Pulse can also
alert on break rate alone; that needs its own driver tree (day-2 miss rate, freeze
consumption, notification tone), not built yet — see the roadmap, month 2.

### Anomaly-to-Hypothesis → Weekly Insight (not built until this pass — built now)

This connection **did not exist** before this request. `weekly-insight.md`'s own Boundaries
section flagged it as a named gap: *"a natural one exists ... not built here."* Building it:

**What changes:** `weekly-insight.ps1` gains a fourth real source — it now parses
`outcome-log.md` for entries and reports, as context, how many anomaly runs fired this week,
how many are still unresolved, and the earliest unresolved call. **This is mechanical, like
the retention join and the NPS parse** — counting entries and checking whether a placeholder
is still `[ ]` requires no judgment.

**What it feeds, and what it deliberately doesn't:**
- It does **not** silently become a fourth "Changed this week" bullet or override "Watch
  next week" — the current Watch bullet (Query 1, Wednesday) is a real, more urgent thing to
  watch, and this connection existing shouldn't crowd it out by default.
- It **does** surface as its own context line, the same way the NPS theme already does —
  visible every week, promoted into an actual Watch candidate once there's something worth
  watching (an unresolved call, or a pattern across several).
- **The real payoff isn't this week's digest — it's the learning loop (§4 in the main
  request, `learning-loop.md`).** Once outcomes get filled in, this same parse is what a
  weekly self-review reads to score hit/miss/partial. Wiring the pull now means the loop has
  something to read the day it's turned on, instead of a second integration project later.

**Built and run, not just described** — `weekly-insight.ps1` now parses `outcome-log.md` for
real. Two bugs surfaced in the process, both fixed in the committed script: the status regex
tried to match `^...$` across a whole multi-line block, which can never succeed without a
Singleline/Multiline flag, so every entry silently read as "no status" (fixed by matching
the header's first line in isolation); and the unresolved count only checked fully-completed
runs, undercounting — the "inconclusive" and "low-confidence" *stops* also carry a real
placeholder and belong in the count, since whether a stop was the right call is exactly what
the learning loop needs to check.

**Result, checked by running it:** `outcome-log.md` currently has 4 entries. **3 carry a
trackable placeholder and all 3 are unresolved** — the below-threshold stop has nothing to
track (nothing happened), so it's correctly excluded. The report surfaces the earliest of
the three by name: *"Push notification delivery issue" — still awaiting what-actually-happened.*
That's a true, useful signal (a real backlog of un-followed-up diagnoses), not an empty
feature.

---

## 3 · Roadmap

See [`../roadmap.md`](../roadmap.md) — six months, one agent added per month, each tied to a
gap already named somewhere in this project rather than invented for the exercise.
