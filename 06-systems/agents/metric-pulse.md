# Metric Pulse Agent — Streakly

*2026-09-17 · Trevor Laverriere · fills the "Metric pulse" row in `../systems.md`*

## Gap, stated up front

This is a **script proven against the local sample data**, not a deployed agent. Three
things this project does not currently have, so none of them are faked here:

- **A live connection to Streakly's production database.** The 39% Day-7 baseline in
  `CLAUDE.md` is real and verified; nothing below can compare against it directly, because
  there is no query path to production from this environment. The script runs against
  `data/users.csv` + `data/retention.csv` — the same synthetic sample used throughout
  `data/metric-findings.md` and `data/metric-diagnosis.md`.
- **A scheduler.** "Run nightly, deliver Monday 8am" is a schedule spec, not a running
  cron job or n8n workflow — §4 covers how it would actually get one.
  **Clarified 2026-09-17, while wiring `anomaly-diagnosis.md`:** "nightly" has to mean the
  alert check (`AnyAlert`) runs every night, not just the human-readable digest — an
  anomaly worth chaining to a diagnostic loop doesn't wait for Monday. "Deliver Monday
  8am" describes when the *formatted* digest goes out on a normal week, not a limit on
  how often the underlying comparison runs. The script already supports this — `AnyAlert`
  is evaluated on every invocation regardless of which weeks are passed in — this note
  just corrects the schedule description, which read as weekly-only.
- **A Slack (or email) connector.** The digest is a file on disk. "Reply YES to trigger"
  is a written interface contract for whatever eventually delivers this, not a live button.

What *is* real: the script runs, reads real files, computes real numbers, and writes a
real digest — §5 is an actual run, not a mockup.

---

## 1 · The agent script

`metric-pulse.ps1`, in this folder. Reads `data/users.csv` (channel) joined to
`data/retention.csv` (day_7 flag, break flag) on `user_id`, grouped by `cohort_week` —
the sample data's stand-in for calendar week, same mapping used in `metric-diagnosis.md`.

**What it computes, for `CurrentWeek` vs `PreviousWeek`:**
- Day-7 retention rate, overall and by `acquisition_channel` (organic / paid / referral)
- Streak-break rate, same breakdown
- Week-over-week delta on each
- **Alert** if either headline metric moves ≥ `AlertThresholdPts` (default 2pt) — the two
  metrics are checked independently, so a break-rate move can alert even if Day-7 doesn't
- **Watch channel** — whichever channel's Day-7 delta has the largest magnitude, only
  labelled when an alert has fired

**Parameters:**

| Param | Default | Meaning |
|---|---|---|
| `DataDir` | `..\..\data` | Where `users.csv` / `retention.csv` live |
| `OutDir` | `.\digests` | Where the digest file lands |
| `CurrentWeek` / `PreviousWeek` | `4` / `3` | Which `cohort_week` values to compare |
| `Baseline` | `39.0` | The live Day-7 figure, carried through for display only — **not compared against**, since this data source can't reach it |
| `AlertThresholdPts` | `2.0` | Per the spec |

**One implementation note:** the script's own text output uses `|down|` / `|up|` / `|flat|`
instead of arrow glyphs. This project hit real PowerShell parse failures earlier from
smart quotes and em-dashes embedded in generated scripts — arrows are safer than those, but
the plain-text markers cost nothing and remove the risk entirely. The **rendered digest**
(§5, and whatever the real delivery channel produces) uses proper arrows and the emoji from
your sample; only the intermediate script output stays ASCII-safe.

---

## 2 · The digest template

```
📊 Streakly Retention Pulse, [Day] [Mon DD]

Day-7 retention: [XX]% (↓/↑/→ [N]pt vs last week) [⚠️ ALERT if ≥2pt]
Streak-break rate: [XX]% (↓/↑/→ [N]pt vs last week) [⚠️ ALERT if ≥2pt]

By channel (Day-7):
Organic: [XX]% (↓/↑/→ [N]pt)
Paid: [XX]% (↓/↑/→ [N]pt) [← watch this, if largest-magnitude mover]
Referral: [XX]% (↓/↑/→ [N]pt)

Top signal: [one sentence naming the channel or metric that moved most, and what to check]

Next: run anomaly diagnosis? Reply YES to trigger 06-systems/agents/anomaly-diagnosis.md.
```

**Rules that generate it, not just describe it:**
- Both headline metrics are checked against the 2pt threshold **independently** — the
  digest can show one ALERT, two, or none.
- The `← watch this` tag only appears on a channel line when an alert fired somewhere
  and that channel has the largest-magnitude Day-7 move. No alert → no tag, even if a
  channel moved.
- "Top signal" always names a channel or states plainly that no single channel explains
  the move — it never states a *cause* (campaign change, cohort quality, etc.). This
  agent flags where to look; it doesn't diagnose. That's the next agent's job.
- The "Next: run anomaly diagnosis" line **only appears when `AnyAlert` is true.** A
  clean week's digest ends at "Top signal."

---

## 3 · Running it manually to verify output

From `06-systems/agents/`:

```powershell
powershell -File .\metric-pulse.ps1 -CurrentWeek 4 -PreviousWeek 3
```

- Prints the digest to the console.
- Writes it to `digests\pulse-wk4-vs-wk3.txt` (plain-text, ASCII-safe version).
- Re-run with different `-CurrentWeek`/`-PreviousWeek` values to check other week pairs
  in the sample data (valid range: 1–5, though week 5 is the pilot cohort and mixes
  treatment/control — see the caveat in §5 before comparing into or out of it).
- To point it at a different data snapshot later, pass `-DataDir <path>` — it only
  requires `users.csv` and `retention.csv` with the same column names.

There's no separate "verify" step beyond reading the output: the script has no side
effects other than writing the one digest file, so re-running it is free.

---

## 4 · How this gets wired in the real world

Three options, weighed against what this project actually has right now — a squad
already stretched (`docs/fast-track-handoff.md` flags Lena at six concurrent items) and
no production data access from this environment.

| Option | What it buys | What it costs | Fit here |
|---|---|---|---|
| **Python + cron** | Full control, runs anywhere, no new platform dependency | Someone has to own the box it runs on, the retry logic, and the alerting-on-failure (a cron job that silently stops is worse than no job) | Reasonable if Raj's team already has a scheduled-jobs pattern — but that's assumed, not confirmed |
| **n8n** (or similar workflow tool) | Visual, easy to hand off, built-in scheduling and Slack/email nodes, no server to babysit | Another tool in the stack; someone still has to write the query node and the alert logic, which is most of the work | Best fit **if** the org already runs n8n for something else — check before proposing a new tool for one job |
| **Developer ticket** (ask data/eng to build it as a proper pipeline) | Gets it onto real infrastructure, with real monitoring, owned by the team that owns the warehouse | Slowest, and competes with Query 1 for Raj's time this week | **Not now** — Query 1 is the gate and due Wednesday; this doesn't outrank it |

**Recommendation: n8n now, ticket later.** This agent's actual logic is small — one join,
two rate calculations, a threshold check. That's a good match for a low-code workflow
tool rather than a maintained Python service, and it doesn't ask for engineering time this
week. Revisit as a proper pipeline once Query 1 lands and there's a real warehouse table
to point it at instead of a CSV export.

**The query this would actually run**, once there's a warehouse table instead of a CSV
(for the developer-ticket path, or an n8n SQL node):

```sql
SELECT
  u.acquisition_channel,
  COUNT(*) AS n,
  AVG(CASE WHEN r.day_7 THEN 1.0 ELSE 0 END) * 100 AS day7_rate,
  AVG(CASE WHEN r.broke_streak_week1 THEN 1.0 ELSE 0 END) * 100 AS break_rate
FROM retention r
JOIN users u ON u.user_id = r.user_id
WHERE r.cohort_week IN (:current_week, :previous_week)
GROUP BY u.acquisition_channel, r.cohort_week
ORDER BY r.cohort_week, u.acquisition_channel;
```

Same shape as the script — one join, one `GROUP BY` — because the metric definitions
don't change when the storage does.

---

## 5 · Test run against the Streakly sample data

Run 2026-09-17, `-CurrentWeek 4 -PreviousWeek 3` (the two most recent pre-pilot weeks in
the sample — week 5 is excluded here because it's the mixed treatment/control pilot
cohort, not a natural production week; comparing into it would attribute the treatment
effect to a week-over-week move it isn't).

**Console output (verbatim):**

```
Streakly Retention Pulse - Week 4 vs Week 3

Day-7 retention: 27% (|down| 4.0pt)  ALERT (>= 2 pt move)
Streak-break rate: 35% (|down| 10.0pt)  ALERT (>= 2 pt move)

By channel (Day-7):
  organic: 29.4% (|flat| flat)
  paid: 14.7% (|down| 26.5pt)  <- watch this
  referral: 37.5% (|up| 15.6pt)

Top signal: paid channel Day-7 moved -26.5 pt week over week. Check for a cause before next Monday.

Baseline on file (live product, CLAUDE.md): 39% Day-7. This run compares sample-data week 3 to week 4, not the live baseline -- there is no production data source wired in yet.

Next: run anomaly diagnosis? Reply YES to trigger 06-systems/agents/anomaly-diagnosis.md.
```

**Rendered digest:** `digests/sample-digest-wk4.md` — the same numbers, formatted the way
a real Monday delivery would look.

**What this run proves:** the join, the two rate calculations, the threshold logic, and
the watch-channel selection all work on real (if synthetic) data, and both alert
conditions fire correctly on a genuine 4pt and 10pt move.

**What this run does not prove, so it isn't claimed:**
- **Nothing about live Streakly performance.** 27% and 39% are not the same number from
  the same system — one is this week's sample-CSV week 4, the other is the real product's
  current Day-7. They happen to differ by 12 points; that's not a finding.
- **That the paid-channel drop is a real signal rather than noise.** `metric-diagnosis.md`
  already flagged these channel cells at n≈34, with paid's worst week a 5-user cell. The
  -26.5pt swing here is the same small-sample pattern repeating, not new evidence of a
  campaign problem. The digest's own "check for a cause" line is the correct level of
  claim — a lead, not a conclusion.
- **That week-over-week is the right comparison window once this runs on live data.**
  Real Day-7 moves slowly; a single bad signup day can swing a small week's rate more than
  a real trend would. Worth revisiting the alert threshold once there's daily-granularity
  production data instead of five discrete cohort weeks.

---

## Boundaries

| | |
|---|---|
| **Does** | Compute two rates, their week-over-week delta, and a channel breakdown, from a real data join. Flag when either crosses 2pt. Name the channel most responsible. |
| **Does not** | Diagnose a cause, access production data, run on a schedule, or deliver anywhere. Those are the three gaps in the header, plus the explicit hand-off to the next agent. |
| **Chains to** | `06-systems/agents/anomaly-diagnosis.md`, built 2026-09-17, on the "Reply YES" line — anomaly diagnosis takes the alerted metric, its direction, magnitude, **and this agent's watch-channel flag** as input, and does not re-derive any of them. |
