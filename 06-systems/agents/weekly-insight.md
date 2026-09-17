# Weekly Insight Agent — Streakly

*2026-09-17 · Trevor Laverriere · fills the "Weekly insight" row in `../systems.md`*

## Path and scope, stated up front

Same normalization as the other two agents: built at **`06-systems/agents/weekly-insight.md`**,
not the literal `agents/weekly-insight.md` requested, to stay in the one folder the whole
stack already lives in.

**Gaps carried over, same three as `metric-pulse.md` and `anomaly-diagnosis.md`:** no live
production data connection, no scheduler, no Slack connector. The report is a real file on
disk; the "post to Slack" step writes the message that would post, to a file, and says so.

**New to this agent, stated rather than glossed over:** of the three sources, two are pulled
**mechanically and for real** below — the retention join and the NPS theme parse. The third,
condensing `change_log.md`'s rows into exactly **3** "Done this week" bullets, is **judgment**,
the same honest split `anomaly-diagnosis.md` drew around its hypothesis text. A change log
entry is often a paragraph of reasoning; deciding which three matter most and phrasing them
as one-line bullets is not a thing regex should be doing. The script surfaces every real
candidate headline from this week's rows as an audit trail; a human — or, in the real
deployment, an LLM call reading the same rows — picks and phrases the final three.

---

## 1 · The agent script

`weekly-insight.ps1`, in this folder.

| Source | How it's pulled | Real or judgment |
|---|---|---|
| Retention metrics (`data/*.csv`) | Same join as `metric-pulse.ps1` — `users.csv` × `retention.csv` by channel and cohort week | **Real.** The paid-channel Day-7 number in every output below is computed, not typed in. |
| Top NPS theme (`research/nps-analysis.md`) | Regex against the file's own ranked table, row `#1` | **Real.** Pulls the actual current top theme; if the table's format ever changes, the script says so instead of guessing. |
| Sprint completions (`change_log.md`) | Regex extracts every row dated this week and the first bolded span in each — a real, complete candidate list | **Candidates are real; the final 3 are judgment.** 60 rows were dated today in this run; 54 headlines were extracted; 3 were selected and phrased for the report. |

**Why NPS gets a full mechanical pull and change_log doesn't:** the NPS table is small,
structured, and already ranked — extracting row 1 is retrieval. Change_log rows are prose
written for a different reader (a future session auditing a decision), at a different grain
(one row can be a whole feature's pressure test); turning 60 of them into 3 digest bullets is
summarization, a different kind of task.

---

## 2 · Output format

```markdown
# Streakly Weekly Insight, [Day Mon D]

*Sources: retention metrics (`data/`, real join), sprint completions
(`change_log.md`, [N] rows dated [date]), top NPS theme (`nps-analysis.md`, parsed).*

## Done this week
- [bullet]
- [bullet]
- [bullet]

## Changed this week
- [bullet — a metric or signal that moved, with the number and its source]
- [bullet]

## Watch next week
- [bullet — the single thing most likely to matter]
```

The Slack draft is the same three sections, flattened to plain text with a closing "Saved
to [path]" line — the 3-2-1 you asked for.

---

## 3 · Running it manually to verify the output

From `06-systems/agents/`:

```powershell
powershell -File .\weekly-insight.ps1
```

Defaults to today's date and the analyst's current picks for the three judgment bullets.
Prints the three source pulls (with the first 5 change-log candidates, for audit) before
writing `reports/[date].md` and `slack-drafts/weekly-insight-[date].txt`. To check a
different week or override any bullet, pass `-WeekOf`, `-DoneBullets`, `-SecondChangedBullet`,
or `-WatchBullet`.

**This step is not decorative — running it four times in a row is what found four real bugs**,
all fixed in the script as committed:

1. **Candidate extraction grabbed the bolded date, not the headline.** Every change_log row
   looks like `| **DATE** | **Headline...** |`, and the first version of the regex matched
   the *first* bold span on the line — which is the date. Fixed to skip past the first
   pipe-delimited cell before looking for a bold span.
2. **`Get-Content` without an explicit encoding mangled every em dash and arrow** in
   `change_log.md` and `nps-analysis.md` into mojibake (`â€”`, `â†’`). Windows PowerShell 5.1
   doesn't default to UTF-8 for file reads. Fixed with `-Encoding UTF8`.
3. **Fixing #2 broke NPS parsing.** The NPS regex had a literal em dash typed into the
   script source; a `.ps1` file without a BOM is itself parsed with the system codepage, so
   that literal was silently a *different* character than the one now being correctly
   decoded from the file — two wrongs had been cancelling out. Fixed by not requiring an
   exact separator character at all (`.*` instead of a specific dash).
4. **A literal backtick meant as a markdown code-span marker was read as PowerShell's escape
   character.** `` `n `` is the newline escape in a double-quoted string, so
   `` `nps-analysis.md` `` silently inserted a real line break before "nps-" and dropped the
   backticks — visible in the first report as the sources line breaking mid-word. Fixed by
   doubling every literal backtick (`` `` `` = one literal backtick in PowerShell).

None of these four were visible from reading the script. All four were visible in five
seconds of reading the actual output.

---

## 4 · Wiring this in the real world

You named three options and a fixed slot — Friday 4pm. Weighed the same way as the pulse
agent, against a squad already stretched (`docs/fast-track-handoff.md` flags Lena at six
items) and no production data access from here:

| Option | What it buys | What it costs | Fit here |
|---|---|---|---|
| **Python + cron** | Full control; natural fit if the summarization step becomes a real LLM API call, since Python's the common client language for that | Someone owns the box, the retry logic, and — the part that actually matters for this agent — **prompt-and-review discipline for the judgment step**, so a bad LLM summary doesn't ship silently | Reasonable **once** Step 3 (bullet-writing) is handed to an LLM call rather than a human — not before |
| **n8n** | Visual, easy to hand off, has both a cron trigger and Slack/email nodes built in | Someone still has to write the retention-join node and, again, own the judgment step's review | Good fit if n8n is already running `metric-pulse` — one more scheduled workflow, not a new platform |
| **Developer ticket** | Real infrastructure, real monitoring, owned by the team that owns the warehouse | Slowest, and — same as the other two agents — competes with Query 1 for Raj's time | Not now, for the same reason as before |

**Recommendation: same as `metric-pulse` — n8n, if it's already the home for that
agent.** One more scheduled trigger costs little once the retention join exists. **The
real decision isn't the platform, though — it's who reviews the judgment step before Friday
4pm.** A Friday digest with a wrong "Done this week" bullet is a bad update, silently
believed. Whatever wiring is chosen, put a human (or a second model call checking the
first) between the candidate extraction and the post.

---

## 5 · Sample output — Streakly data, real run

Full report: [`../../reports/2026-09-17.md`](../../reports/2026-09-17.md)
Slack draft: [`slack-drafts/weekly-insight-2026-09-17.txt`](slack-drafts/weekly-insight-2026-09-17.txt)

```
Streakly Weekly Insight, Thu Sep 17

Done this week:
- Comeback screen PRD finalized and pressure-tested against three reviewers -- Raj, Marcus, and a churned user (docs/prd.md, docs/objection-log.md)
- Full experiment design specified and pre-registered -- 1,568 users per arm, kill conditions set, no interim efficacy looks (data/experiment-design.md)
- Metric pulse and anomaly-diagnosis agents built and run for real against sample data, not just spec'd (06-systems/agents/)

Changed this week:
- Paid-channel Day-7 dropped 26.5pt week-over-week in the sample data (41.2% -> 14.7%) -- flagged as likely noise at n~34 per channel-week, not a confirmed signal (data/retention.csv via metric-pulse's own join)
- Comeback screen open rate climbed 28% -> 56% across the pilot's four sends -- the one pilot number holding up under scrutiny, unlike the withdrawn +30pt Day-7 claim (data/metric-findings.md)

Watch next week:
- Query 1 lands Wednesday 2026-09-23 (Raj) -- decomposes the 9-point Day-7 decline and decides whether any of the three approved features address it; the release is gated on the answer (docs/query1-handoff.md)

Saved to reports/2026-09-17.md
```

**Two confidence-tier notes carried into the digest itself, not left implicit:** the "Changed"
retention bullet is explicitly flagged as noise-suspect at n≈34 per channel-week (same caution
already on record in `metric-diagnosis.md`), and the "Changed" pilot bullet distinguishes the
open-rate number that holds up from the +30pp figure that's already been formally withdrawn.
**Neither Changed bullet is presented as a finding about live Streakly performance** — both
trace to the sample dataset or the pilot, and say so.

---

## Boundaries

| | |
|---|---|
| **Does** | Compute a real retention signal, parse a real current NPS theme, extract every real change-log candidate for the week, and assemble the 3-2-1 report and Slack draft from them. |
| **Does not** | Decide which 3 change-log headlines matter most, access production data, run on a schedule, or post to Slack. The first is judgment by design; the other three are the same standing gaps as the other two agents in this stack. |
| **Chains from** | Nothing — this is the one agent in the stack that doesn't trigger off another agent's alert. It runs on its own weekly clock. |
| **Chains to** | Nothing built yet, but a natural one exists: if "Changed this week" ever contains a move that would itself have tripped `metric-pulse`'s 2pt alert, the two reports should agree — worth a cross-check once both run on live data instead of two different sample snapshots. |
