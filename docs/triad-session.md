# Triad Working Session — Comeback Surface

**Who:** Trevor, Raj (eng), Lena (design) · **30 minutes** · *2026-09-16*

> **This is a working session, not a review.** The direction is already approved — Marcus signed off Option C on 2026-09-16 with the release gated on Query 1. We are not re-opening that. We are here to get three things owned.

---

## Before the session — prerequisite

> ### ✅ Done 2026-09-16 — Lena has been told, and she is on board.
>
> She knows the concept changed: freeze affordance removed, concept parked and un-parked, pre-emptive trigger added. She accepts it. No surprise waiting in the room, which is what this was protecting against.
>
> **But note what that does to the session.** She agreed *before* Amara's objection was put to her. Early consensus on the one genuinely contested question is a risk, not a win — it removes the session's main source of friction on the thing most likely to be wrong.
>
> **So don't spend her eight minutes asking whether she agrees. She already does.** Spend them asking her to argue the against case. She owns the streak-reset-as-punishment research, which makes her the best-placed person in the company to say whether a pre-break warning reads as pressure. Her agreement is worth far more if it survives the objection being stated out loud.

---

## Agenda

| Time | What | Why it's here |
|---|---|---|
| **0–3** | **Frame.** What's decided, what isn't, what we need from each of you by the end. | Prevents the session drifting into re-litigating the direction |
| **3–10** | **Prototype — three states only.** See below | The comparison does the explaining |
| **10–18** | **Lena: the register question.** Is the pre-emptive trigger support or pressure? | The live contested question, and a design judgment only she can make |
| **18–25** | **Raj: Query 1 ownership plus two feasibility questions.** | The release is gated on Query 1 and it has no owner |
| **25–30** | **Read back owners and dates.** Out loud, by name. | The difference between a working session and a conversation |

---

## What to show — and what to skip

**Show three states, in this order:**

1. **Day 14 · at risk** → **Day 15 · lost it.** The same user one day apart. This comparison *is* the pitch — it shows exactly what intercepting a day earlier buys. Spend most of the demo time here.
2. **14-month · 8 days.** The failure case: both streaks gone, and the surface falls back to a memento. This is the state that needs design input, because the design was specifically built to avoid leading with a trophy.
3. **How it works** tab, briefly. It is the legibility artifact and the first time all the mechanics exist in plain language.

**Skip:** the full lesson flow, the completion screen, the dismissal path. They work, they are not what you need input on, and they will eat the clock.

---

## Questions to ask

### For Lena — the register

*She is already on board. These are framed to get past that, not to confirm it.*

1. **"Our day-4 persona read this as a deadline with good manners — *'strip the manners off and it's the app telling me I have until midnight.'* Make that case as strongly as you can. Where is she right?"**
   The single most valuable eight minutes available. If Lena can build that case convincingly, the copy is not the fix and the trigger needs rethinking. If she can't, we have something much better than agreement.
2. **"Can one surface carry both reassurance and a warning, or do those need to be separate places?"**
   We currently ship both and assume they compose. Nobody has checked.
3. **"When both streaks are dead, the surface has only a memento to offer. Is there a better answer, or is that the honest ceiling?"**

### For Raj — ownership and two cheap unlocks

1. **"Will you own Query 1, and by when?"** ← *the one that cannot slip*
   Spec is written and handoff-ready: `../05-decide/counterfactual-replay.md` and `../01-orient/validation-plan.md`. Days of work on existing data. **The release is gated on it and it has no owner**, so the gate currently has nothing behind it.
2. **"Was v2 A/B tested before launch, or rolled out in stages?"**
   Thirty-second question with a large payoff. If either is true, a causal answer already exists in the data and the causality question stops being hard. Nobody has asked.
3. **"Are signup-anchored weeks computable over history, or is that expensive?"**
   Flagged in the replay spec. If it's costly it changes the *design*, not just the analysis.

---

## Decisions to walk out with

### Must — do not let this one slip

- **Query 1 has a named owner and a date.** Everything downstream waits on it, including the release.

### Should

- **A verdict on the pre-emptive trigger's register:** ship as drafted, revise the register, or hold it for testing as a separate arm.
- **Go / no-go on the day-1 reassurance state** — currently proposed, not built. Two personas have asked for it from opposite ends of the lifecycle, which is the strongest signal we have on anything untested.

**If time runs out**, take Query 1 and schedule the other two. The reverse is the wrong trade.

---

## What not to do in the room

- **Don't re-open the direction.** Marcus decided it. Disagreement goes in the alignment doc, not the session.
- **Don't design the day-1 state live.** Capture the decision to build it; design it after.
- **Don't defend the numbers.** Every parameter — 1 miss/week, bank cap 3, freeze cap 7 — is an admitted placeholder the replay should set. If either of them challenges one, agree and write it down.
- **Don't claim the prototype tests anything.** It shows the design. No user has seen it.

---

# Post-Session Alignment Doc — template

*Fill in within an hour, while it's fresh. Short enough that it actually gets filled in.*

## Decisions made

| Decision | Who decided | Consequence |
|---|---|---|
| | | |

## Owners and dates

| What | Owner | By when |
|---|---|---|
| **Query 1** | | |
| | | |

## Disagreements recorded

*Preserve these rather than smoothing them. A disagreement that gets resolved silently comes back later as a surprise.*

| Who | Disagreed with | Their reasoning |
|---|---|---|
| | | |

## What changed as a result

*Design, scope or sequence changes that came out of the room — and what file each needs to land in.*

- 

## Still open after this session

| Open item | Blocks | Next step |
|---|---|---|
| | | |

## Anything that turned out to be wrong

*Assumptions the room corrected. These matter more than the decisions — write them down even when they are embarrassing.*

- 
