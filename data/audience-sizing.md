# Audience Sizing — Breakers-Through-Protection

*2026-09-17 · Trevor Laverriere · answers the objection in `../docs/objection-log.md` M2*

## The answer, up front

**I cannot produce this number from the data we hold, and I am not going to estimate
it.** What I can produce is the exact definition, a hard bound, the shape of the
answer, and the single query that closes it — which **Raj has already run most of.**

| | |
|---|---|
| **Bound** | Between **0% and 36.2%** of new signups |
| **Why the range is that wide** | The bound depends entirely on how many misses a breaker has, and that distribution is not in any file we hold |
| **What closes it** | One segment on historical activity: week-1 users by **count of missed days**. Days of work on data we already own |
| **Who has already touched it** | **Raj.** His *"~2x churn after two consecutive missed days"* finding is defined on this exact cohort. He has the segment; we never asked him for the count |

---

## 1 · What the question means precisely

The Comeback screen fires when the **daily streak** breaks. Under the approved
design a week-1 user holds **one seeded freeze**, which absorbs their first missed
day. So:

> **The daily streak breaks on the second missed day, not the first.**
> Addressable audience = new users who miss **≥2 days** in their first 7.

And the design's premise is *lead with what survived*, which needs the **week
streak** alive. Week 1 tolerates 1 allowance + 3 banked = **4 misses**. So the
audience splits three ways:

| Misses in week 1 | Daily streak | Week streak | What they see |
|---|---|---|---|
| 0–1 | **Protected** by the freeze | Alive | **Nothing.** No Comeback screen fires |
| **2–4** | **Broken** | **Alive** | **The Comeback screen working as designed** |
| 5+ | Broken | **Dead** | The **memento fallback** — the thing the design was built to avoid |

**This is the definition the objection needs answered, and none of it required data.**
It is derived from the approved rules in `../01-orient/strategy.md`.

## 2 · Why the data cannot answer it

| Check | Result |
|---|---|
| Observable session window | **Days 0–4 only.** Week 1 needs days 0–6 |
| Users with any observable week-1 session | 420 of 500 |
| `broke_streak_week1` flagged | **190 of 500 (38%)** |
| Observable session gap in the log | **7 of 500** |
| **Flag and log agreeing** | **4 users** |

Counting *misses* requires per-day activity across all seven days. We have five
days, for 420 of 500 users, from a log that corroborates the break flag for **4 of
190 flagged breakers.** The flag carries the signal and the log cannot be used to
decompose it.

**One arithmetic that is not evidence, stated so nobody rediscovers it as a
finding:** taken at face value the log shows 36 of 500 users (7.2%) with ≥2 missed
days inside days 0–4. That happens to land near the bottom of the range in §3. It is
a coincidence, not a corroboration — the same log disagrees with the break flag for
186 of the 190 flagged users, so it has no standing here.

## 3 · What is derivable: the bound and the sensitivity

Break rate under current rules — *"missed ≥1 day in week 1"* — from the untreated
cohorts:

| Cohort | Break rate |
|---|---|
| Week 1 | 26% |
| Week 2 | 39% |
| Week 3 | 45% |
| Week 4 | 35% |
| **Weeks 1–4 combined** | **36.2%** (145/400) |

Since everyone who breaks through protection must first have missed a day:

- **Upper bound 36.2%** of new signups — if every current breaker missed 2+ days
- **Lower bound 0%** — if every current breaker missed exactly one day, the seeded
  freeze absorbs all of them and **the audience is empty**

**The lower bound is not a rhetorical device.** The tolerance layer is explicitly
designed to prevent this event. If most week-1 breaks are single missed days, Option
C's own Freeze feature removes the Comeback screen's entire audience — which is what
our decision brief meant by *"B shrinks the Comeback Screen's audience."*

### Sensitivity

| Share of breakers missing ≥2 days | Audience, % of new signups | At 1,120 signups/wk | At 2,000/wk |
|---|---|---|---|
| 20% | 7.2% | 81 | 145 |
| 30% | 10.9% | 122 | 218 |
| 40% | 14.5% | 162 | 290 |
| 50% | 18.1% | 203 | 362 |
| 60% | 21.8% | 244 | 435 |
| 80% | 29.0% | 325 | 580 |

*Signup rates are illustrative — **we do not hold our weekly new-signup volume
either**, and 1,120/week is the threshold from `experiment-design.md`, not a measured
figure. Percentages are the durable column.*

## 4 · Three structural findings that need no data

**1 · The audience is a curve, not a number.** The freeze bank grows — one seeded on
day 1, then one per perfect 4-week block, cap 7 — so protection deepens and the
population breaking through **shrinks through the first 12 weeks.** Seeding stops
after block 3, and `strategy.md` already records a **new cliff at day 85** for users
who never manage 28 perfect days. So "breakers per week" falls, then rises. Any
single number is a snapshot of a moving quantity.

**2 · The well-designed state is concentrated in week 1, and degrades for tenured
users.** The Comeback screen's best case needs the daily streak broken *and* the week
streak alive — which means **freeze-poor and week-streak-rich.** That is precisely a
week-1 user with one seeded freeze. For a freeze-rich user the arithmetic inverts:
`hypothesis.md` known fact 8 shows seven freezes means eight missed days, but the
weekly goal tolerates four in a week, so **the week streak dies first** and the
screen falls back to the memento.

**This cuts both ways and both directions matter.** The feature's good state lands
squarely in the cohort Day-7 measures — an argument *for* it. And the feature
degrades into the thing it was built to avoid for exactly the tenured users whose
quotes justified building it. **Tom, eight days absent, gets the memento.**

**3 · Audience is not event volume.** The surface fires at most once per rolling 7
days, so a repeat breaker counts once per week. Any build estimate sized off break
events will overstate the load.

## 5 · The query that closes this — and who already has it

**One segment, on data we own:**

> For new registrations in a representative window, count **distinct missed days in
> the first 7 days per user**, and report the distribution: 0, 1, 2, 3, 4, 5+.

That single distribution yields every number in §1 and §3 at once, plus the
memento-fallback share, plus the day-8 cliff size.

**And it is not a new analysis.** Raj's finding — *"once someone misses two days in a
row, churn is almost double"* — is **defined on the ≥2-miss population.** He built
that segment in one evening. His cut was ≥2 *consecutive*; the freeze absorbs any
single miss regardless of adjacency, so we need ≥2 *total*, which is a looser filter
on the same query.

**We have been arguing about the size of a cohort our engineering lead has already
isolated. Nobody asked him for the count.** Per `../stakeholders/raj.md` he is
unlikely to defend the 2x figure and may welcome it being validated — so this lands
as *"your query, one more column"* rather than as new work.

**Fold it into the Query 1 brief.** Query 1 already decomposes week-1 behaviour into
broke / didn't break / never established; adding *miss count* to the breakers bucket
is one more `GROUP BY` on a query that has to run anyway.

## 6 · What I would say to Marcus

> "You asked what this reaches. The honest answer is between nothing and a third of
> new signups, and the reason the range is that wide is that our own Freeze feature
> is designed to delete this feature's audience. I am not going to guess where in
> that range it sits. Raj has already isolated the cohort — his two-missed-days
> finding is built on exactly this population — so what I need is a count he can
> produce from a query he has already written. It goes into the Query 1 brief and
> comes back with it. **If it lands at the bottom of that range, the right answer is
> your own alternative: ship B, then size A before paying to build it.**"

**Recorded plainly:** this analysis makes descoping the Comeback screen *more*
defensible than it was this morning, not less. The number is worth producing even
though it may kill the feature — and if it does, the tolerance layer keeps the part
the evidence actually supports.
