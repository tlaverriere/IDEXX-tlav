# Module 6 · Systematize — Build Your Systems & Agent Stack

> How do I make this stick, and run while I sleep?

Build a durable workspace and skills worth keeping, then layer on an autonomous agent stack — metric pulse, weekly insight, anomaly-to-hypothesis — wired into one connected system. Finalize the capstone repo.

## Workspace + Three Skills

*What's worth keeping, and the skills that make it durable.*

1. ___
2. ___
3. ___

## Agent Stack

| Agent | Trigger | Output | Boundaries |
|-------|---------|--------|------------|
| Metric pulse | Nightly, delivers Monday 8am | Digest: Day-7 retention + streak-break rate, channel breakdown, alert if either moves ≥2pt week over week | Flags where to look, never a cause. No live data connection, scheduler, or delivery channel yet — spec-level, proven against sample data. Spec: `agents/metric-pulse.md` |
| Weekly insight | Own weekly clock (not chained) — real-world slot is Friday 4pm | 3-2-1 digest: Done this week (3) / Changed this week (2, metrics or signals that moved) / Watch next week (1) — saved to `reports/YYYY-MM-DD.md`, 3-2-1 posted to Slack | Retention join and NPS-theme pull are real and mechanical; the 3 "Done" bullets are judgment over `change_log.md`, not regex — script surfaces every real candidate, doesn't pick for you. No live data, Slack, or scheduler yet. Spec: `agents/weekly-insight.md` |
| Anomaly → hypothesis | Chained from Metric pulse's alert only — never runs standalone on a schedule | Ranked hypotheses (confidence-scored) + SQL to confirm the top one + Slack draft, gated through a decomposition and a confidence floor | Never invents a hypothesis outside its rule table; a low-confidence result withholds SQL rather than attaching a query to a guess. No live data, Slack, or scheduler yet. Spec: `agents/anomaly-diagnosis.md` |

## Connected System — "Comeback Coach"

*Added 2026-09-17, closing "wired into one connected system" above.* The three agents in
the table are registered together, with their real interfaces and open owner question, in
[`agents/registry.md`](agents/registry.md) — including the actual connection from Metric
Pulse's alert into Anomaly → Hypothesis, and the one built this pass, Anomaly →
Hypothesis's `outcome-log.md` into Weekly Insight. The self-review loop that reads that same
log and proposes (never applies) a heuristic update to `CLAUDE.md` is at
[`agents/learning-loop.md`](agents/learning-loop.md). Where this goes next, one agent per
month, each tied to a gap already named somewhere in this repo, is
[`roadmap.md`](roadmap.md).

## Final Presentation

Generated from this repo with the Module 6 Final Presentation Generator, and committed to [`final-presentation.html`](final-presentation.html): what you shipped (Streakly Comeback experience), the Day-7 retention impact, and what's next. Submitted alongside your repo URL.
