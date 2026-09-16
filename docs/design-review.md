# Design Review — Comeback Surface

*2026-09-16 · Trevor Laverriere*

> **Sharing note.** **Part 1 is written to be sent to Lena.** Parts 2 and 3 are my own prep and ownership thinking. `stakeholders/lena.md` is internal working notes and should not be shared — it profiles how she reviews, which is a reasonable thing for me to think about and not a reasonable thing for her to read.

---

# Part 1 · Review doc — shareable

**Reviewed:** `prototype/index.html` (lock-screen entry, three trigger states, "How streaks work") against `02-research/interview-synthesis.md` (Priya, Tom, Amara — n=3, directional).

**Reviewers:** Trevor, Lena · **Status:** one change agreed, one open item blocking sign-off.

## What the prototype answers, with the evidence for each

| User need | Source | How the prototype answers it |
|---|---|---|
| A route back after a break | **Tom** — *"There was no way to recover it, nothing. So I gave up."* | The surface exists and offers a 60-second lesson that counts as that day's lesson |
| Not returning to nothing | **Tom** — *"missed two days, and came back to a big fat zero"* | Week streak shown alive at 2, with 2 spare days remaining |
| A notification that doesn't wound | **Tom** — *"The app sent me this 'you lost your streak' notification that just made me feel bad."* | Lock-screen entry leads with what survived, at the exact surface he named |
| Forgiveness for a missed day | **Tom** — *"a streak freeze feels forgiving"* | Freeze applies automatically, and the breakdown names it: *"Tuesday — covered by your freeze / Saved"* |
| An answer to "what if I miss?" | **Amara** — *"I keep thinking, what happens if I miss a day?"* | "How streaks work" states it plainly: one miss a week, three spare days, a freeze |
| Acknowledgment that something happened | **Priya** — *"the app actually celebrating it, that little moment of 'look what you built'"* | The completion state acknowledges the return, with both counters visible |

## What it does not yet answer

| Gap | Source | Why the prototype doesn't reach it |
|---|---|---|
| The answer arrives after the fear | **Amara** — *"I'm already stressed about the streak"* | She has not missed a day, so she never sees this surface. The answer sits in a tab she must go looking for |
| Pressure itself | **Amara** — *"the pressure is starting to feel like a chore instead of a game"* | Nothing here reduces weight for a user who has broken nothing. It adds counters |
| The three weeks before a habit forms | **Priya** — *"most people quit long before the habit forms"* | Every acknowledgment fires on a break or a recovery. A week-1 user doing everything right sees nothing new |
| The fear that was the engine | **Priya** — *"After that I did not want to lose it."* | Making protection visible may preserve that motivation or defuse it. Untested either way |
| Reaching someone already gone | **Tom** — *"I really wanted it to work."* | He stopped opening the app. The notification is the only path in, and whether he taps it is untested |

## Where the review landed

**1 · Does "your week streak is still going" read as reassurance or as moving the goalposts?**

Resolved, on a better argument than the one I opened with. Those two weeks are **not a number we invented for Tom — he earned them by showing up.** Duolingo's revival data found that what pulls dormant users back is *their own progress restored*, and this is exactly that. The copy rationale is "you undercounted yourself," not "we take feedback seriously."

**2 · Is the itemised breakdown forgiving, or a receipt?**

The principle holds: rewarding people who haven't done the work is how a streak stops meaning anything — consistent with our own finding from a long-streak user who said a freeze meant he *"didn't deserve"* his record. **The objection is weight, not honesty.** Four rows with two failures stacked vertically dwells on loss longer than the truth requires. Same facts, one line: *"Tuesday was covered. Wednesday ended it."* **Lena's to fix.**

**3 · What does a week-one user see? — OPEN, and blocking sign-off**

A day-3 breaker has a best-ever of 2 days and no live daily streak. The design's premise is *lead with what survived*, and for that user nothing did — so the surface falls back to a memento, which is the thing it was built to avoid.

**But by our own rules their first week is still on track.** One miss out of seven against a bank of three means the weekly goal is intact. So the hero for a week-one user isn't a streak at all:

> **"Your first week is still on track — three spare days left."**

**That is the right answer and it is not in the prototype.** Three states exist — twelve-day, fourteen-month, and nothing for the cohort our success metric actually measures.

**Agreed next step:** build a **fourth state** for the week-one user. Not a variant — a state that proves the hero works when the numbers are small, because that is the hard case and we have only designed the easy ones.

---

# Part 2 · The single highest-impact change for week-1 retention

**It is not the week-one Comeback state. It is a day-1 reassurance moment.**

Lena's ask is correct — for design coherence. It is not the biggest week-1 retention lever, and the difference is audience arithmetic:

| Change | Who it reaches in week 1 |
|---|---|
| Week-one Comeback state | Only week-1 users who **break** — and breaking requires two misses, since the first is frozen |
| **Day-1 reassurance** | **Every new user, on day 1** |

**Why the evidence points here rather than at the break:**

- **Amara is our only week-1 voice, and she never broke a streak.** She is disengaging at day 4 with her counter intact — *"I don't want to lose everything I've built after four days."* The Comeback surface cannot reach her in any state, because it fires on a break she hasn't had.
- **Priya tells us why it matters:** *"it took me about three weeks to get there, and I think most people quit long before the habit forms."* The window we need to survive is week 1, and right now a week-1 user doing everything right sees nothing at all.
- **The fix is the same sentence Amara asked for, moved earlier.** On day 1: *"You've got three spare days and a freeze. Life happens."* Then quiet. Both she and Priya have asked for this from opposite ends of the lifecycle — Amara wants it early, Priya's complaint was *"why didn't you tell me?"*

**The caveat, stated honestly:** n=1 for week 1. This is the sharpest hypothesis available, not a finding, and it rests on one interview.

**Do both.** But if only one ships before launch, ship the day-1 moment — it reaches the whole cohort, and the Comeback state reaches a subset of a subset.

---

# Part 3 · Product decision vs Lena's to own

**The dividing principle: the mechanic is mine, the meaning is hers.** What the system *does* versus what a user understands it to *mean*.

### Mine — product

- **Whether the week streak exists at all.** The two-currency model is a strategy call, already approved
- **Every number** — 1 miss/week, bank cap 3, freeze cap 7, seeds, the 7-day save run. These get set by the counterfactual replay, not by taste
- **Whether we stay honest about the reset.** This is a trust-and-values call tied to the devaluation risk, and it constrains her copy rather than being a copy choice
- **Scope** — which states ship in v1
- **The success metric and measurement design** — >50% Day-7, the two splits
- **Whether block earning stays unprotectable.** A mechanic decision with a user cost. Informed by her, decided by me

### Hers — design

- **All copy. Every word.** Including the sentence the whole feature rests on. It is currently PM-written and that is a temporary state, not a decision
- **Information hierarchy and visual weight** — the breakdown-as-receipt fix is hers, not a compromise I granted
- **The hero for each state** — *"your first week is still on track"* is a design judgment about what matters most to a user in that moment
- **Empty and degraded states** — including what a user with nothing to show sees
- **The register** — whether a prompt reads as support or pressure. Already assigned to her, and she owns it because she owns the research the question came from
- **Whether six concepts can be made legible.** Progressive disclosure is a stated design constraint and its execution is hers

### Needs both, explicitly

| Item | Split |
|---|---|
| **The week-one fourth state** | *Whether it ships* is mine. *What it says* is hers |
| **Block earning invisibility** | Three exits: tolerate one frozen day (mechanic — mine), show progress (design — hers), notify on failure (design — hers). **I pick the category, she designs the answer** |
| **The day-1 reassurance moment** | I own that it exists and where it fires. She owns what it says and how loudly |

**Where this has gone wrong before, so it doesn't again:** her concept changed three times without her in the room. The freeze affordance was removed from her sketch by a mechanic decision that was mine to make — but the removal was communicated late. **The decision was legitimate; the sequencing was not.** Mechanic changes that alter her surface get told to her before they get written down.
