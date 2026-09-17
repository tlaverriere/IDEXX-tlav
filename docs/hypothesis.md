# Learning Synthesis & Hypothesis

*2026-09-16 · Trevor Laverriere · **revision 2***
**Sources:** `../01-orient/change_log.md` (111 entries, 2026-09-14 → 16) and `../02-research/decision-brief.md` rev 5, plus the research and competitive artifacts they draw on.

**What changed in rev 2:** the pre-emptive trigger was added to the Comeback surface, and role-playing Amara against it produced the most worrying signal in the project so far. Two new assumptions surfaced — one of them sits *beneath* the entire design rather than beside it — and the primary hypothesis has been split, because one component is now actively predicted to backfire.

---

## 1 · What we know

Verified from primary sources. These survive scrutiny.

| # | | Source |
|---|---|---|
| 1 | **Day-7 retention is 39% against a 48% baseline.** | Retention dashboard. The only genuinely verified number in the project |
| 2 | **The content is not the problem — the mechanic is.** Every piece of praise across 3 interviews and 10 verbatims targets the lessons or the first-week experience; every complaint targets the streak system. No user criticised the lessons, tracks, or five-minute format. | Interviews + NPS, consistent across both |
| 3 | **The absence of a way back drives disengagement.** Corroborated across three independent sources, including external voice: *"lost it and haven't opened the app since. Why would I, all my hard work is lost?"* | Top NPS theme (4/10), Tom, Hacker News / Clozemaster |
| 4 | **Five of five direct competitors ship a missed-day mechanic; we ship none.** The only app in our scan that resets on a first miss is Lumosity — included as the do-nothing control. | Primary-source competitive scan |
| 5 | **Dormant users respond to a personal reason to return.** Duolingo's June 2026 revival drew **15.4M revivals, ~8M from users with no active streak**, and they publish internal work on "resurrected users" — the space is **open, not empty**. | Duolingo shareholder letter + their own blog |
| 6 | **Early acknowledgment correlates with return.** Elevate's first milestone lands **day 3**; Duolingo measured milestone animations at **+1.7%** on 7-day return. | Primary sources, both companies |
| 7 | **Option C was approved 2026-09-16** — Comeback Screen + Freeze + Weekly Streak — with the **release gated on Query 1**, not assumed by it. | Marcus, Thursday's meeting |
| 8 | **For any user who accumulates freezes, the week streak breaks before the daily streak does.** Seven freezes means eight missed days; the weekly goal tolerates at most four in a week, so it fails in week two. | Arithmetic on our own rules. Not an opinion |

---

## 2 · What we assume

Directional or unvalidated, and **acted upon anyway**. Each is load-bearing for a decision already taken.

| # | Assumption | Status |
|---|---|---|
| **0** | **That the streak is a motivator users care about intrinsically.** | ***New in rev 2, and it sits beneath the whole design rather than beside it.*** Every mechanic we have built assumes this. One user with an external goal — a trip in six weeks — described the streak as **overhead**: *"The streak is your goal, not mine."* Useful for three days, then a second thing to manage. n=1, never examined, and if it is wrong then the entire design is optimising the wrong unit |
| 1 | **That the loss concentrates in users who break a streak in week 1.** | The most load-bearing *testable* assumption. Rests on Raj's unreviewed figure. Query 1 tests it |
| 2 | **Two consecutive misses → ~2x churn.** | One evening of unreviewed analysis. Our most persuasive number and our least tested |
| 3 | **That the reset reads as punishment, and that this is the mechanism.** | Documented qualitatively (Lena + n=3). Can never be *proven* from data — honest ceiling is "consistent with" |
| 4 | **That week-1 harm precedes any break.** | **n=1.** Least tested, most consequential single claim we hold |
| 5 | **Every number in the design** — 1 miss/week, bank cap 3 (= seed), freeze cap 7, 3 freeze seeds, 7-day save run, 4 saves/year, and no frequency cap on the pre-emptive prompt. | None derived from our data. All are placeholders that were never replaced |
| 6 | **That a second currency satisfies the need users described in streak terms.** | Two independent sources asked for a **freeze by name**. We are betting the week streak answers the underlying need instead |
| 7 | **That the drift path is material** — churn with no break at all. | Two sources. Directional. Scope decision still open |
| 8 | **That "your first missed day costs nothing" is the right property to build for.** | The design's central claim. Never tested on a user |
| **9** | **That warning a user before the loss helps rather than harms.** | ***New in rev 2, and already contested by the persona it was built for.*** Amara: *"Strip the manners off and it's the app telling me I have until midnight."* The trigger has the right timing and, on her read, the wrong emotional register |

---

## 3 · What we still do not know

| # | Open question | Why it matters |
|---|---|---|
| 1 | **Where the nine points actually sit.** | **Query 1.** If the loss is users who never established a streak, this is an onboarding problem and **none of the approved features addresses it.** Days of work on existing data. **Assigned to Raj 2026-09-17, due Wednesday 2026-09-23.** |
| 2 | Whether v2 caused the decline. | Not established. Deliberately demoted — a randomised forward test doesn't need the answer |
| 3 | **Whether the design is legible.** Six concepts, seven with the pre-emptive prompt. | Top recorded design risk from the beginning. **Never concept-tested.** The freeze alone took seven bullets to explain in plain language |
| 4 | **Whether the pre-emptive prompt is net positive or net negative.** | Built to serve Amara; she rejects it. **See §4 — this is why it now needs its own experimental arm rather than inclusion in the primary claim** |
| 5 | **Whether reassurance and warning can live on one surface.** | Amara had *two opposite reactions to the same product* — relieved by the rules page, alarmed by the save prompt. We currently ship both and assume they compose |
| 6 | **Whether protection should be visible or hidden.** | Priya's read says hide until needed; Amara's says show on day 1. The *same* persona gave opposite answers under two profile variants — **roleplay cannot settle this** |
| 7 | **What the screen shows when the week streak is dead too.** | Known fact 8 makes this the case for **every** long-tenured user. The fallback is a memento — the exact thing the design was built to avoid leading with |
| 8 | Whether a perfect 4-week block is achievable at all. | **Q5b.** If under ~10% ever manage it, the earning half of the freeze is decorative and protection effectively ends at day 84 |
| 9 | The size of the day-8 cliff. | Week 1 permits 4 misses; week 2 permits 1 once the bank is spent |
| 10 | **Whether the notification is a prerequisite rather than a parallel track.** | Tom: the surface is unreachable without a notification he'll tap. Fast track 1 may gate the whole feature |
| 11 | **What success means.** | **No recovery target. No number, no timeframe.** See §4 — this is not bookkeeping |
| 12 | **Whether any of our qualitative evidence bears on Day-7 at all.** | Nothing we hold is segmented to week 1. The structural weak link between our evidence and our metric |

---

## 4 · The hypothesis

### Why it is now split

The pre-emptive prompt was added on the reasoning that it acts *before* the loss — the one thing nothing else in the design did. Role-playing the persona it was built for produced the opposite conclusion: it acts before the loss **as a deadline**, and she predicted it would make her more likely to leave.

**A component that one source actively predicts will backfire cannot sit inside the primary claim.** Bundling it means a null result is uninterpretable — we would not know whether the tolerance worked and the prompt undid it, or neither worked. So it gets its own arm.

That is the same attribution discipline applied earlier in this project, and it applies more sharply here because we have a specific prediction of harm rather than an absence of evidence.

### Primary hypothesis — tolerance

> **We believe that** a weekly consistency goal with pre-granted tolerance — one permitted miss per week plus a bank of three, and a freeze that absorbs the first missed day, both visible from day 1 — **will deliver** a recovery in early retention toward the 48% baseline **for Streakly users in their first 7 days, as measured by Day-7 retention rate.**

**Mechanism.** A new user's first missed day currently zeroes their only counter. Under this design it costs nothing visible: the freeze protects the daily streak and the bank absorbs the weekly goal. The moment our research identifies as the quit trigger stops being a loss event.

### Arm 2 — the pre-emptive prompt, tested separately

> **We believe that** telling a user on the last day they could still save a streak **will deliver** a further improvement **for Streakly users in their first 7 days, as measured by Day-7 retention rate** — and we are testing it separately because one source predicts the opposite.

**Guardrail specific to this arm:** notification opt-out rate. If it rises, we have traded our main re-engagement channel for a warning.

### Secondary hypothesis — the Comeback Screen, post-break state

> **We believe that** a designed return session showing what survived plus one 60-second lesson **will deliver** increased reactivation of lapsed users, **as measured by return rate among users whose daily streak has broken** — *not* by Day-7 retention, which that audience largely sits outside.

**Stated dependency:** its reach is capped by whether users open the notification that precedes it, which makes Fast track 1 a plausible prerequisite.

### The blank is now filled — and these became falsifiable

> **Target, set 2026-09-16: Day-7 retention above 50%, within 4 weeks of launch.**

For the whole project this section read *"no recovery target has ever been set"* and concluded that none of these hypotheses was falsifiable — "a recovery in early retention" could be claimed on any positive movement including noise. **That is no longer true.** Substitute the number into the statements above and each becomes a clean pass or fail.

**Three things follow that are worth stating precisely:**

1. **The bar is above the old baseline, not a return to it.** The decline was 48% → 39%. Reversing it lands at 48%; >50% is two points past the best Streakly has ever performed. **A result of 47% reverses the decline and misses the target.** The spec must carry one number, because "reverse the decline" and ">50%" render opposite verdicts on the same outcome.
2. **It is only measurable via a new-signup split.** Day-7 retention is a new-user metric. The agreed 50/50 split on *existing* users is a safety guardrail, not a measurement of this goal — existing users have no day 7. **Without a split on new registrations there is no way to substantiate the number**, and that split is not yet confirmed.
3. **The read cannot be trusted before week three.** Rollout completes day 7; cohorts registering days 7–21 produce readable Day-7 figures inside the 28-day window. Roughly 14 days of clean cohorts. Power is fine; anyone asking at day 10 is looking at noise.

### What would falsify this

- **Query 1 shows the loss sits with users who never established a streak.** The mechanism is aimed at the wrong population entirely.
- **Q5b shows almost nobody completes a perfect 4-week block.** The earning half of the freeze is decorative.
- **Day-7 improves while days-active falls.** The "anxiety down, habit down" failure mode — we made week 1 pleasant and prevented the habit forming. This is why the days-active guardrail is required, not optional.
- **The counterfactual replay shows most week-1 churners missed 5+ of their first 7 days.** No tolerance setting saves them and tolerance was never the problem.
- **Arm 2 raises notification opt-outs, or underperforms the primary arm alone.** Amara's prediction, made explicit and testable.
- **Users with external goals retain no better than control.** Assumption 0 — if the streak is overhead rather than motivation, streak mechanics cannot move them whatever we do to the tolerance.

---

## 5 · What would move this from assumption to knowledge

In priority order. The first two are days of work on data we already hold.

1. **Query 1** — decompose the nine points by week-1 behaviour. Can invalidate everything above. **Assigned to Raj 2026-09-17, due Wednesday 2026-09-23.**
2. **Q5b** — what share of users ever complete 28 consecutive perfect days. One number.
3. ~~Set a recovery target.~~ **Done 2026-09-16 — >50% Day-7 within 4 weeks.** Replaced by: **confirm the new-signup split**, without which the target cannot be measured.
4. **8–12 week-1 interviews**, including users who never broke a streak — and **at least some with an external goal**, to test assumption 0. Also fixes the n=1 problem on assumption 4.
5. **Concept-test the day-1 view in isolation.** The only way to test legibility, still entirely unexamined.
6. **Build and test the day-1 reassurance state** — *proposed, not built.* Move the user's first contact with the tolerance system from the warning to the reassurance. Requested by Amara across two roleplays and implied by Priya's *"why didn't you tell me?"* — **both personas asking for the same change from opposite ends of the lifecycle**, which is the strongest signal available on something untested.

---

## The honest summary

The design is finished, well-reasoned and internally consistent. It is also built on **ten assumptions** — one of which sits underneath the whole thing and has never been examined — aimed at a problem whose location is unconfirmed, and pointed at an outcome we have not defined.

**And rev 2 adds a category of evidence we did not have before.** Every earlier finding came from users explaining why they *already* left, which we read backwards into a cause. Amara has not churned, and she predicted the feature would make her more likely to go. That is a forward-looking signal about harm we would cause, and it is a different and worse class of evidence than anything else in the file.

The gate exists precisely because all of this is true at once.
