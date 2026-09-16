# QA — Comeback Surface

*2026-09-16 · Trevor Laverriere · assessed against `prototype/index.html` (992 lines) and `docs/spec-readiness.md`*

> **Framing that matters for reading §2.** The prototype cannot block a launch — it isn't the build. A defect in it matters for one of two reasons: it would **mislead implementation** if engineers use it as the reference, or it **reveals a requirement the spec never stated.** Both are classified that way below.

---

# 1 · Edge cases

## 1.1 Empty states

| # | Case | Why it matters |
|---|---|---|
| E1 | **User has never held a streak.** Best-ever is 0 or null | The hero has nothing live *and* nothing to remember. **No state in the prototype models this**, and it is the Day-7 cohort |
| E2 | **Best-ever is 1.** Streak of one day, broken | *"Your best ever: 1 day"* is worse than showing nothing. Needs a floor below which the stat is suppressed |
| E3 | **Existing user was already broken at launch.** Best-ever seeds from a current streak of 0 | Per spec §2.3, the field seeds from current streak. For an already-lapsed user that seeds zero, permanently |
| E4 | **No lessons available in their track** — track completed, or a content gap | The primary CTA is *"do a 60-second lesson."* If there is no lesson, what does the button do? |
| E5 | **Track never selected / onboarding incomplete** | Can a user break a streak they never started? Does the surface fire at all? |
| E6 | **True null state:** daily 0, week 0, best 0, freezes 0, spare days 0 | Every number on the screen is zero. Unspecified |
| E7 | **Week streak alive but daily streak never existed** | Possible for a user who misses their first day, banks nothing. What leads? |

## 1.2 Edge data conditions

| # | Case | Expected per spec |
|---|---|---|
| D1 | Daily streak of exactly **1**, broken | Reset to 0; best-ever becomes 1 (see E2) |
| D2 | **Broke twice in one week** | Surface shows **once per rolling 7 days** (spec §2.1) |
| D3 | **Freeze already used this block** | No protection; daily streak resets. Truth table A3/A4 |
| D4 | **Freeze bank at cap 7 when another is earned** | Overflow is **lost**. Spec does not say whether the user is told — recorded as a trust risk |
| D5 | **Miss bank at cap 3 when a clean week closes** | Unused allowance lost (truth table C3) |
| D6 | **Exactly at margin** — 4 misses in a week | Week goal **met.** Week streak survives |
| D7 | **Fifth miss in a week** | Week goal fails → save-eligible |
| D8 | **Last-gasp save in progress when the week rolls over** | Run may cross week boundaries (D2 in the truth table) |
| D9 | **Save attempted and failed** | Must **not** consume one of the four |
| D10 | **All four saves used in the account year** | No save offered. Unspecified what the user sees instead |
| D11 | **One miss consumes a freeze *and* a weekly allowance** | Both. This is the double-draw and it is correct per spec |
| D12 | **Block killed by a frozen day** — streak alive, earning dead | Correct per spec, and **invisible to the user.** The one open design question |
| D13 | **Existing user re-anchored mid-streak** | Does the existing daily streak carry over or reset? **Not stated in the spec** |
| D14 | Very large best-ever (428, 1000+) | Layout. The prototype renders 428 without breaking |
| D15 | Streak cannot go below zero | Guard against negative values on repeated resets |

## 1.3 Timing

| # | Case | Risk |
|---|---|---|
| T1 | **Missed 1 day vs 2 vs 8 vs 60** | Prototype covers 2 and 8. Nothing for 1, nothing for very long absences |
| T2 | **Timezone change mid-streak** — user flies | Day boundary moves. Habitica reconciles three timezone sources for exactly this; we have not specified ours |
| T3 | **Completion at 11:59pm local** | Which day does it count for — device local or server? |
| T4 | **Custom day-start**, if we support one | Unspecified whether we do |
| T5 | **DST transition** | A 23- or 25-hour day. Does the week boundary drift? |
| T6 | **Surface shown too late** — user returns after 60 days | Is a comeback prompt still the right thing, or is it re-onboarding? |
| T7 | **Surface shown too early** — same day as the break, before midnight | Should not be possible if the trigger is post-reset, but worth asserting |
| T8 | **Week rollover during an active session** | Counters change under the user mid-session |
| T9 | **Block rollover (day 28) during an active session** | Freeze may be granted mid-session |
| T10 | **Rolling launch** — user in the 50% who don't have it yet | Must see current behaviour, with no partial UI |
| T11 | **Holdout crossover** | A user must never move between arms. Assert it |

## 1.4 Permission states

| # | Case | Risk |
|---|---|---|
| P1 | **Notifications off entirely** | **The prototype's only entry point is a notification.** If push is off, the surface is unreachable. No in-app fallback exists |
| P2 | Push permission never granted | iOS and Android 13+ both prompt. A meaningful share never grant it |
| P3 | Permission revoked after being granted | Same as P1, arrived at differently |
| P4 | **Background refresh off** | Does the freeze still apply? It should, if the evaluation is server-side — but the *user* may not know that, and will assume it didn't |
| P5 | Do Not Disturb / Focus mode | Notification delayed or suppressed. Is a delayed comeback prompt still correct? |
| P6 | **Device offline when the freeze would apply** | See the PR comment in §3 — this is the one I would raise before merge |
| P7 | Logged out / token expired | Streak state stale on reopen |
| P8 | Low-data mode | Lesson content may not load behind the CTA |

---

# 2 · PM QA checklist against the prototype

Assessed screen by screen against the actual file. **4 pass, 4 fail, 2 cannot determine.**

| # | What to verify | Verdict | Evidence |
|---|---|---|---|
| 1 | **Hero leads with a live asset when one exists; falls back honestly when not** | **PASS** | `save`/`short` render `card-alive`; `long` correctly switches to `card-memento` (line 859) |
| 2 | **The reset is stated plainly, not hidden** | **PASS** | Breakdown rows name it — *"Wednesday — no freeze left / Streak ended"*, *"Daily streak / 0 days"* |
| 3 | **Completion counts as the day's lesson and says so** | **PASS** | `.counted` block states it; `renderHome` switches the lesson card to *"done"* and hides the start button (lines 903–911) |
| 4 | **A dismissal path exists and lands somewhere coherent** | **PASS** | *"Not today"* → home with the week streak still visible |
| 5 | **Home screen reflects the user's actual streak state** | **FAIL — misleads implementation** | `renderHome` hardcodes `lessonDone ? '1' : '0'` (line 890) and ignores `current`. In the **save** state the daily streak is **12 and alive**, but home shows **0**. After completion the done screen says **13** (line 786) while home says **1**. Three surfaces, two contradicting each other |
| 6 | **Screen-reader announcement matches the visible state** | **FAIL — accessibility, and it states a falsehood** | Line 935 is a hardcoded string ending *"Week streak still 2 weeks."* In the **long** state the visible value is **0 weeks**. A screen-reader user is told the opposite of what is on screen |
| 7 | **Back navigation returns the user where they came from** | **FAIL — known issue, shippable** | `lesson-back` at step 0 always calls `show('comeback')` (line 944). A user who dismissed to home, then started today's lesson, then went back, lands on a Comeback screen they never saw |
| 8 | **Empty state for a user with no streak history** | **FAIL — reveals an unstated requirement** | No state models best-ever 0 or null. All three states carry a substantial best (12, 12, 428). This is E1, it is the cohort the metric measures, and it is the gap Lena blocked sign-off on |
| 9 | **Surface fires at most once per rolling 7 days** | **CANNOT DETERMINE** | The prototype has no trigger logic. States are selected manually from the harness. The cap is specified but unrepresented |
| 10 | **Timezone and day-boundary handling** | **CANNOT DETERMINE** | Not modelled. No date logic exists in the file — every value is a literal in the `states` object |

## Blocking vs known issue

**Would block launch — or in the prototype's case, must be fixed before engineers use it as the reference:**

- **#5 — the home/done contradiction.** This is a state-modelling error, not a display bug. If the build mirrors it, the daily streak will be wrong on the home screen for every save-state user.
- **#6 — the hardcoded announcement.** Small in a prototype, a real accessibility defect in production, and the pattern would be copied.
- **#8 — the missing empty state.** Already blocking design sign-off. Also the Day-7 cohort.
- **#P1 — no in-app entry point.** The surface is reachable only via notification. A user with push disabled cannot reach it at all. **This is a spec gap the prototype exposed**, not a prototype bug.

**Can ship as known issues:**

- **#7** back-navigation edge, single tap, recoverable
- Hardcoded lesson timings (*"Done — 38 seconds"*) regardless of actual elapsed time
- Lesson content is a labelled placeholder, by design
- `role="tab"` without `aria-controls` or matching `tabpanel` — harness chrome, not product surface

---

# 3 · PR comment for Raj

> **On the freeze auto-apply — what happens to a late sync?**
>
> One thing I want to understand before this merges, and it's a user-visible case rather than a code concern.
>
> The freeze applies automatically at the day boundary and is consumed irreversibly. What happens if a completion arrives *after* that, out of order?
>
> Concretely: someone does their lesson on the train with no signal at 11:40pm. The device syncs at 8am the next morning. By then the boundary has passed, we've recorded a miss, and the freeze is spent.
>
> Two questions:
>
> 1. Does the late-arriving completion retroactively clear the miss — and if so, **do we refund the freeze?**
> 2. If we don't refund it, what does that user see? Because from where they're standing they *did* the lesson and we took their protection anyway.
>
> I'm asking because that user is the exact person this feature exists for. Our research has someone saying the old behaviour *"just made me feel bad"* — and spending a freeze they'd earned over four perfect weeks, for a lesson they actually completed, is a sharper version of the same feeling.
>
> If refunding is expensive or racy, I'd rather know now and handle it in copy than discover it in a support queue. And if it's already handled, point me at it and I'll close this out.

**Why this one, out of everything in §1:** it is the only case where the system takes something the user earned, in a situation where the user did nothing wrong, and the current spec has no answer. Most edge cases produce a confusing screen. This one produces a justified complaint.
