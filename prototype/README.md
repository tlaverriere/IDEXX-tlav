# Comeback Screen — Prototype

*Built 2026-09-16. Single file, no dependencies, no build step.*

**To run it:** open `index.html` in any browser. That's it — no server required.

---

## The PM Brief

**Approval context.** Option C was approved by Marcus on 2026-09-16 — Comeback Screen + Freeze + Weekly Streak, shipped together. **The release is gated on Query 1, not assumed by it.** Design work, including this prototype, is explicitly in the "proceeds" column; production streak-accounting changes hold. Query 1 still has no owner.

**User.** A 24-year-old who hit a 12-day streak, missed two days, and has not opened the app since.

**Job to be done.** Get back in without feeling they lost everything.

**Feature.** The Comeback screen as approved: best-streak stat and one 60-second comeback lesson, shown when the daily streak breaks. *The original concept's one-tap streak-freeze offer no longer exists — freezes are earned-only and auto-applied, so there is nothing to offer on tap.*

**Constraint.** Use data Streakly already has. No new integrations.

### The user's actual state under the approved design

| | Value | Note |
|---|---|---|
| Daily streak | **0** | Reset on the second consecutive miss |
| Best-ever daily streak | 12 | |
| Freeze bank | 0 | The seeded freeze absorbed the first miss; the second broke the streak |
| **Week streak** | **2 — intact** | The miss bank absorbed both misses, so the weekly goal was met |
| Miss bank | 2 remaining | |

**He has not lost everything — he has lost one of two things.** That is the entire basis of this screen.

---

## Key decisions from the interview

### 1. Lead with the surviving week streak, not the best-streak stat

The approved spec names only the best-streak stat. But that's a **memento** — a number from the past that says *"here's what you had."* The week streak is a **live asset**: intact right now, with two spare days left, saying *"here's what you still have."*

A memento acknowledges loss. A live asset contradicts it. Since the job is "didn't lose everything," the live asset is the stronger hero and the best-streak stat became supporting context.

*Cost:* this goes slightly beyond the literal approved spec.

### 2. The lesson resumes, it doesn't restore — and it counts as that day's lesson

Completing the 60-second lesson **counts as today's lesson. Nothing else is due that day.** The daily streak restarts at 1, and nothing is given back.

The screen says this explicitly (*"That counted as today's lesson. Nothing else due today."*) and the home screen reflects it — daily streak 1, today's lesson marked done, and no prompt to start another one. A user who does the comeback lesson and then gets asked for their real lesson would have been asked to pay twice for coming back.

This was the closest call in the interview, because our own research sits on both sides:

- **For restoring:** Duolingo's 2026 event drew 15.4M revivals, ~8M from users with no active streak — and the durable finding was that what worked was *your own progress restored.*
- **Against:** the 500-day user in external voice — *"A streak freeze devalues impressive streaks… I didn't deserve that 500 day streak."* And `strategy.md` names the line to defend: protection must never be gifted to an established user.

Resuming holds the line. The payoff is more modest, and that trade was made knowingly.

### 3. Dismissible, shown once

A clear *"Not today"* lands him on the home screen with the week streak still visible. He isn't shown the comeback screen again.

The alternative — re-showing until he completes a lesson — would convert more, but *"the reminder just started to feel like nagging"* is already an NPS complaint, and Amara's exit was pressure (*"a chore instead of a game"*). A screen that blocks a user who already went dark once reproduces the failure it's meant to fix.

### 4. Single state only

Just the brief's persona. No state switcher.

---

## Design decisions made without asking

- **The reset is rendered in neutral slate (`#4b5563`), never red.** Alarming colour would dramatise the loss this screen exists to de-dramatise. Verified in the browser.
- **Tone is permission, not rescue** — Brilliant's register from the competitive matrix. No guilt, no exclamation marks, no "don't break the chain."
- **The screen is honest about what broke.** *"Wednesday — no freeze left / Streak ended"* is stated plainly rather than hidden. Softening the reset would undercut the daily streak's meaning, which is what keeps the devaluation risk resolved.
- **It shows the app was paying attention** — the breakdown names which day the freeze covered and which day broke the streak. Research says the app currently "acts like nothing happened," and NPS R7 complained the home screen looks identical either way.
- **Lesson content is placeholder and visibly labelled.** The brief doesn't specify the user's track, so nothing was invented.
- **No Streakly brand assets exist in the repo**, so the palette is restrained and neutral.

---

## The four states

| | View | What it does |
|---|---|---|
| 0 | **Lock screen** | **Entry point.** A push leading with what survived, or with what today keeps. Added 2026-09-16 — see below |

### Four states

**Added 2026-09-16: `Day 5 · first week`** — the cohort the success metric measures, and the state Lena blocked sign-off on.

A day-5 user has no live daily streak and a best-ever of 2 days, so the design's usual hero — *lead with what survived* — has nothing to lead with. **What is alive is the week itself:** two misses against a budget of four means the weekly goal is still reachable.

> **"Your first week is still on track."** · First week · **2 spare days left**
> *Two missed days came out of your spare days, so the week still counts. You have two left.*
> CTA: **Keep the week going**

Two copy decisions worth flagging for review: the best-ever row reads **"Best so far — 2 days"** rather than "your best ever," because a lifetime-record framing on a 2-day number is faintly absurd. And the CTA is *"keep the week going"* rather than *"pick it back up"*, because there is nothing accumulated to pick back up — the live thing is the week.

**Copy in this state is a first draft for Lena to replace.** Per `docs/design-review.md`, the hero framing is hers to own.

### Notes for implementation

- **The home screen's streak values are state-driven** as of 2026-09-16 (`dailyBefore` / `dailyAfter` per state). An earlier version hardcoded them to `0`/`1` and contradicted the completion screen in the `save` state. If you are reading this file as a behavioural reference, that is the one place it previously lied.
- **The screen-reader announcement is per-state** (`doneAnnounce`). It was previously one hardcoded string that asserted "week streak still 2 weeks" even in states where the week streak was zero.
- **Entry is via notification only.** There is no in-app entry point. A user with push disabled cannot reach this surface — that is an open spec question, not a prototype omission.

### Trigger states

The surface fires on two different triggers, shown as three states in the harness:

| State | Trigger | What it shows |
|---|---|---|
| **Day 5 · first week** | Post-break, week 1 | No daily streak, best of 2 days — **the week itself is the live asset** |
| **Day 14 · at risk** | **Pre-emptive** — last day a streak can still be saved | Daily streak **12, alive**. Freeze already spent on yesterday |
| **Day 15 · lost it** | Post-break | Daily streak gone, **week streak alive at 2** |
| **14-month · 8 days** | Post-break, long tenure | Both streaks gone. Falls back to a memento |

The first two are **the same user one day apart** — that comparison is the point. It shows exactly what intercepting a day earlier buys.

**The pre-emptive trigger is a pressure mechanic**, and pressure is what the research says drives these users away. Tone is therefore the whole feature, and the copy is built accordingly: lead with what the action *keeps* rather than what a miss *costs*, no exclamation marks, no "last chance", and the 60-second lesson kept as the ask so acting stays cheap. All untested.
| 1 | **Comeback** | Acknowledgment → week-streak hero → honest breakdown → best-ever → two actions |
| 2 | **Lesson** | Two-card micro-lesson framed as ~60 seconds, with progress pips and a back path |
| 3 | **Completion** | Daily streak visibly **1**, week streak still **2**. Announced to screen readers via `role="status"` |
| 4 | **Home** | Dismissal target. Week streak still visible, plus *"we won't show you that comeback screen again"* |
| 5 | **How streaks work** | The full rules: daily streak, freezes, week streak, spare days, last-gasp save. Reachable from the **"How it works"** tab above the phone, or from a quiet link on the home screen |

### Why the rules view matters more than it looks

**Legibility has been the top recorded risk of this design throughout** — six concepts (daily streak, freeze, freeze bank, weekly goal, spare days, week streak, last-gasp save) against a population already describing the product as *"a chore instead of a game."* The standing design constraint has been progressive disclosure: a day-1 user should see the daily streak and *"miss up to 1 day a week"* and nothing else.

An opt-in explainer is the escape valve that makes that constraint survivable. The rules can be complete and precise **without** being pushed at anyone. It also partly answers Priya's objection — discoverable, not advertised.

It is also the first place all the mechanics are stated in one piece of user-facing language rather than spec language. Worth reading for that alone: if a rule is hard to write in a sentence here, it is probably too complicated to ship.

---

## What was verified

Run in a browser and checked:

- All eight view transitions, including both entry paths into the lesson and the back path out of it
- The completion state updates both tiles (1 and 2) and sets the screen-reader announcement
- Colour decisions by computed style rather than by eye — alive `#1f7a5a`, ended `#4b5563`
- Layout fits the viewport without the page overflowing, so the secondary action stays reachable
- Home screen state in all four paths — dismissed without the lesson, mid-lesson, after completion, and after reset

**Two bugs found and fixed during verification:**

1. `show()` moves focus to each view's heading for screen readers, which painted a visible focus ring on the headings. Suppressed for `[tabindex="-1"]` headings only, so the announcement behaviour is retained.
2. The home screen reached *after* completing the lesson still showed daily streak **0** and *"Start today's lesson"* — as though the comeback lesson hadn't counted. The home view is now state-aware.

**Not verified:** real touch input on a device, and anything about whether the screen actually works on users.

---

## Change from persona testing — 2026-09-16

All three research personas were role-played against the prototype. They converged on one structural flaw from three directions: **the reassurance arrives too late to do its job.**

**Tom's read decided the change.** *"I haven't opened Streakly since Wednesday. The only way I see this screen is a notification, and last time it said 'you lost your streak' and just made me feel bad. I'm not tapping that again."*

The Comeback screen is gated behind the exact notification research says drove him away — and the prototype was starting at the screen, quietly assuming that problem solved. **The notification is now the entry point**, leading with what survived rather than what was lost.

**Two findings recorded but not acted on**, because they pull in opposite directions:

- **Priya:** *"The reason I kept going was that I didn't want to lose it. That fear was the engine. If you tell me I've got seven freezes in the bank, some of that goes away."* This is a new risk — not the streak being cheapened, but **the fear itself being defused**. Her fix: don't show the safety net until she's falling.
- **Amara:** *"My question was never how do I come back — it was what happens if I miss a day. I only get to read the answer after the thing I'm scared of has already happened."* Her fix: show it on day 1.

**One of them is wrong and we don't know which.** The design currently does what Amara wants. Both are logged as open items in `../01-orient/change_log.md`.

## Known limitations

- **This design is weakest exactly where our metric is.** Its power comes from having something live to show. A user who broke on **day 5** has a best streak of 4 and a week streak of 0 or 1 — almost nothing to surface. That is the cohort Day-7 measures, and this prototype does not cover it. Flagged, not solved.
- **It cannot reach the drift path.** The screen fires on a break, so a user who simply fades without breaking anything never sees it.
- **It does nothing about notification tone**, which is Fast track 1 and a separate piece of work.
- **The numbers on screen are fixed**, not wired to data.
