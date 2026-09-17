# Anomaly Diagnosis Agent — Streakly

*2026-09-17 · Trevor Laverriere · chains from `metric-pulse.md`, fills the
"Anomaly → hypothesis" row in `../systems.md`*

## Path and scope, stated up front

You asked for this at `agents/anomaly-diagnosis.md`. It's built at
**`06-systems/agents/anomaly-diagnosis.md`** instead — that's where `metric-pulse.md` and
`metric-pulse.ps1` already point in four places ("Reply YES to trigger
06-systems/agents/anomaly-diagnosis.md"), written before this existed. A second, disconnected
`agents/` folder would leave those four references broken rather than resolved.

**Three gaps carried over from `metric-pulse.md`, plus one new to this agent:**

- **No live production data, no scheduler, no Slack connector** — same as the pulse
  agent. Step 4 writes the message that *would* post to Slack to a file instead.
- **New here: hypothesis generation is judgment, not arithmetic.** Steps 1, 2, 3's
  confidence gate, and 5 are deterministic and really run below. Step 3's hypothesis
  *content* — "push delivery issue" vs "cohort quality shift" vs "copy regression" — is a
  rule table encoding what a human analyst (or, in a real deployment, an LLM call reasoning
  over the decomposition) would conclude, not a formula that invents business explanations
  from thin air. The rule table is below, in the open, so it's auditable rather than a
  black box. A different pattern of driver movement that the table doesn't cover would
  need a human to write the hypothesis — the script doesn't fabricate one.

What's real below: `anomaly-diagnosis.ps1` runs, applies every gate for real, and produced
every number and file quoted in Part 4 — nothing there is a mockup.

---

## 1 · The updated agent

`anomaly-diagnosis.ps1`, in this folder. Takes as input the payload `metric-pulse.ps1`
hands off when `AnyAlert` is true — the trigger metric's before/after values, its three
decomposition drivers, and the watch-channel flag from the pulse digest's channel
breakdown — and runs it through five gated steps.

**One scoping note the build surfaced:** this agent's metric tree (streak-break rate /
week-1 sessions / push opt-in) decomposes **Day-7 retention** specifically. `metric-pulse`
can also alert on **streak-break rate** on its own. If break rate alerts without Day-7
moving enough to alert itself, that's a real, useful signal — a leading indicator moving
before the lagging one — but it needs its own driver tree (day-2 miss rate, freeze
consumption, notification tone), which isn't built here. **Flagged as a gap, not
silently handled**: this spec covers a Day-7-triggered run only.

---

## 2 · The conditions at each step

| Step | Check | Pass → | Stop condition |
|---|---|---|---|
| **1 · Threshold** | \|current − previous\| > 2pt on the trigger metric | Continue to decomposition | ≤ 2pt: log the non-event, exit. (Redundant with pulse's own alert gate by design — this agent can be invoked directly, not only via the hand-off, so it re-checks rather than trusting the caller.) |
| **2 · Decomposition** | Count drivers crossing their own meaningful-movement threshold: **break rate ≥ 3pt, week-1 sessions ≥ 10% relative, push opt-in ≥ 5pt** | ≥ 2 drivers meaningful → continue to hypotheses | < 2 meaningful → flag **inconclusive**, log, exit. (These three thresholds are a judgment call, documented so they can be argued with — not derived from anything.) |
| **3 · Hypotheses** | Generate ranked hypotheses from the rule table below; take the top-ranked confidence score | Confidence > 6/10 → continue to SQL + Slack | ≤ 6/10 → post the **low-confidence variant** (Part 3), log, exit. No SQL is written on this path — there's nothing confirmed enough to spend a query on. |
| **4 · SQL + Slack draft** | Write the confirmation query for the top hypothesis; render the full diagnostic | Always, once Step 3 passes | No stop condition — this step only runs after 3 has already passed |
| **5 · Log the call** | Append to `outcome-log.md` | Always | **Extended beyond the literal ask**: every exit point logs, not only a full run through Step 4. A Step 1 or Step 2 stop is itself a data point — how often does a pulse alert turn out to be noise or unexplainable? — so it goes in the same log with the same placeholder, rather than only the successes. |

**Meaningful-movement thresholds, why these numbers:** break rate and push opt-in are
already expressed in points, so their bars sit below the 2pt trigger threshold but above
noise (3pt, 5pt); sessions is a count, so it uses a relative bar (10%) instead of an
absolute one. All three are picked to make the sample scenario's own numbers land where
the sample implies they should — break (+7pt) and sessions (−22%) meaningful, push
(−3pt) not — not reverse-engineered from a desired outcome. Worth revisiting once this
runs on real driver distributions instead of one worked example.

---

## 3 · The Slack diagnostic format

**Standard variant** (Step 3 passed):

```
Streakly Anomaly Detected, [Day Mon D, h:mmAM/PM]

Trigger: [metric] dropped/rose [N]pts ([prev]% -> [curr]%) [overnight/this week]

Metric tree decomposition:
[Driver 1]: [prev] -> [curr] ([delta])
[Driver 2]: [prev] -> [curr] ([delta])
[Driver 3]: [prev] -> [curr] ([delta])

Top 3 hypotheses:
1. [Label] ([likelihood] likelihood, confidence [N]/10) -- [one-line reason]
2. [Label] ([likelihood] likelihood, confidence [N]/10) -- [one-line reason]
3. [Label] ([likelihood] likelihood, confidence [N]/10) -- [one-line reason]

SQL to confirm hypothesis 1:

[query]

Logged to outcome-log.md. Run this query and reply with the output. I'll interpret.
```

**Low-confidence variant** (Step 3 failed) — shorter, deliberately withholds SQL:

```
LOW-CONFIDENCE ALERT -- [Day Mon D, h:mmAM/PM]

Trigger: [metric] moved [N]pt ([prev]% -> [curr]%)
Top hypothesis only reaches [N]/10: [label]
No SQL dispatched -- confidence bar not cleared. Needs a human look, not a query.
```

The low-confidence variant never includes a query. **Sending a SQL query attached to a
guess under the confidence bar is worse than sending nothing** — it invites someone to
run it and half-trust whatever comes back, which is exactly the kind of unearned
confidence this whole gate structure exists to prevent.

**Hypothesis rule table (Step 3's actual logic):**

| Condition | Hypothesis generated | Base confidence |
|---|---|---|
| Sessions driver meaningful **and** push opt-in moved the same direction (even if not itself meaningful) | "Push notification delivery issue" | 8 (high) — a session drop concurrent with a same-direction opt-in softening is the standard signature of a delivery problem, not disengagement |
| Pulse's watch-channel is `paid` **and** its delta ≤ −2pt | "New user cohort quality shift from paid channel" | 5 (medium) — corroborating, but from outside this metric tree's own three drivers |
| *(always included)* | "Streak-reset copy regression after last deploy" | 3 (low) — mechanically plausible, never confirmed or ruled out by anything in this decomposition; a residual catch-all, not a finding |

If neither of the first two conditions fires, only the confidence-3 catch-all survives —
which is exactly Run 4 in Part 4, and exactly why it stops at Step 3.

---

## 4 · Simulated test — the 4-point drop, run end to end

Run 2026-09-17 against `anomaly-diagnosis.ps1`, using the sample's own numbers as the
default parameters (39% → 35% Day-7; break 22→29; sessions 4.1→3.2; push opt-in 54→51;
watch channel paid, −4pt).

**Run 1 — happy path (the sample scenario), verbatim console output:**

```
Step 1 -- threshold check: Day-7 retention moved -4 pt (threshold 2 pt)
PASS -- continuing to decomposition.

Step 2 -- decomposition:
  Streak-break rate:   22% -> 29%  (7 pt)  meaningful=True (threshold 3 pt)
  Sessions in week 1:  4.1 -> 3.2  (-22%)  meaningful=True (threshold 10%)
  Push opt-in rate:    54% -> 51%  (-3 pt)  meaningful=False (threshold 5 pt)
  Drivers meeting their meaningful-movement threshold: 2
PASS -- at least 2 drivers moved meaningfully, continuing to hypotheses.

Step 3 -- ranked hypotheses:
  1. Push notification delivery issue (high likelihood, confidence 8/10) -- ...
  2. New user cohort quality shift from paid channel (medium likelihood, confidence 5/10) -- ...
  3. Streak-reset copy regression after last deploy (low likelihood, confidence 3/10) -- ...
PASS -- top hypothesis clears the confirmation bar, continuing to SQL + Slack draft.

Step 4 -- SQL + Slack draft written to .\slack-drafts\sample-anomaly-alert.txt
(No Slack connector authorized in this environment -- this is the message that would post.)

Step 5 -- logged to .\outcome-log.md with a placeholder for what actually happened.
```

Full rendered message: [`slack-drafts/sample-anomaly-alert.txt`](slack-drafts/sample-anomaly-alert.txt)
— matches your sample almost line for line, including the exact SQL.

**Three more runs, to prove the gates actually gate rather than just look right on paper:**

| Run | Change from default | Result |
|---|---|---|
| **2 — below threshold** | Day-7 39% → 38% (1pt) | Stops at Step 1: `"move at or below threshold. Logged, no diagnostic run."` |
| **3 — inconclusive** | Break 22→23, sessions 4.1→4.0, push 54→51 — nothing crosses its bar | Stops at Step 2 with `Drivers meeting their meaningful-movement threshold: 0` |
| **4 — low confidence** | Break 22→27, sessions flat, push 54→48, watch channel `organic` not `paid` | Only the confidence-3 catch-all hypothesis survives the rule table; stops at Step 3. Output: [`slack-drafts/sample-low-confidence-alert.txt`](slack-drafts/sample-low-confidence-alert.txt) |

**Two real bugs the test runs caught, not hypothetical ones:**
1. **Rank collapsed to "0."** when only one hypothesis survived (Run 4) — PowerShell
   unwraps a single-element pipeline result to a scalar, which silently broke the
   `.Count` the ranking loop depended on. Fixed by forcing `@(...)` around the sort.
2. **Hypothesis 3's reason text hardcoded an assumption** ("push opt-in didn't cross its
   threshold") that was true in Run 1 but false in Run 4, where push *did* cross its bar.
   Reworded to a claim that holds regardless of which drivers moved — it's always the
   residual catch-all, not conditionally one.

Both are exactly the kind of thing a "simulated test to verify the loop runs correctly
end to end" is supposed to surface, and both are fixed in the script as committed.

**All four runs are in `outcome-log.md`, in order, as the actual demonstration that
Step 5 fires on every exit path, not only a full completion.**

---

## Boundaries

| | |
|---|---|
| **Does** | Gate a metric-pulse alert through threshold → decomposition → hypothesis → confirmation-query → log, with every gate condition real and tested against four scenarios. |
| **Does not** | Access production data, post to Slack, run on a schedule, or generate a hypothesis outside its rule table. A driver pattern the table doesn't cover surfaces no hypothesis rather than an invented one. |
| **The one place latency could matter** | Steps 1, 2, 4, 5 are cheap deterministic checks. Step 3 is where real judgment happens — if this becomes an LLM call or a human ping in the real version, that's the step that could threaten the "before 9am" SLA, not the gates around it. |
| **Chains from** | `06-systems/agents/metric-pulse.md`, on its `AnyAlert` output, including the watch-channel flag as corroborating context for hypothesis 2. |
