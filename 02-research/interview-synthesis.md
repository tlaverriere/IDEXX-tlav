# Interview Synthesis — Streak Mechanic, Three-Stage Sample

*Last updated: 2026-09-14*

## Source and confidence

Three user interviews, one per lifecycle stage: Priya S. (retained, 14-month streak), Tom R. (churned at ~5 weeks after breaking a 12-day streak), Amara L. (new, day 4).

**Confidence: directional only.** n=3, one user per stage, so every theme below rests on one or two voices. Source coverage is marked per theme. Nothing here is validated; two of the five themes are single-source. Treat as hypothesis generation, not evidence of prevalence.

Quotes are verbatim from the excerpts. Interpretation is labeled as inference where it appears.

---

## Top 5 Themes

### 1. The streak flips from reward to liability — loss aversion is the engine and the hazard

*Coverage: all three users.*

> "After that I did not want to lose it." — **Priya**

> "I don't want to lose everything I've built after four days." — **Amara**

The same psychological mechanism reads as commitment in Priya and as dread in Amara. It is one mechanic producing opposite outcomes depending on how much the user has banked.

### 2. Week 1 is maximum pressure, minimum payoff — the habit forms around week 3

*Coverage: Priya, Amara.*

> "it took me about three weeks to get there, and I think most people quit long before the habit forms" — **Priya**

> "the pressure is starting to feel like a chore instead of a game" — **Amara**

Priya names the timeline and the dropoff in the same breath. Amara, at day 4, is living the gap. *Inference:* the streak applies full stakes from day 1 while delivering its payoff around day 21, so week-1 users carry the cost of a mechanic whose benefit they have not yet reached.

### 3. The break is terminal — no recovery path, and competitors have set a forgiveness expectation

*Coverage: Tom only (single-source).*

> "There was no way to recover it, nothing. So I gave up." — **Tom**

> "I switched to Duolingo, at least there a missed day doesn't wipe everything, and a streak freeze feels forgiving" — **Tom**

Tom's exit was caused by absent recoverability, not absent motivation. His comparison also establishes that forgiveness is a category norm he expected and did not find. Both points come from one interview and need corroboration.

### 4. The app acknowledges accumulation but not loss

*Coverage: Priya, Tom.*

> "the app actually celebrating it, that little moment of 'look what you built'" — **Priya**

> "The app sent me this 'you lost your streak' notification that just made me feel bad." — **Tom**

The only two moments either user describes the app *speaking* to them are a celebration on success and a reprimand on failure. *Inference:* acknowledgment is the mechanism that converted Priya's effort into commitment, and the same channel is what injured Tom.

### 5. Lesson content is working; the streak system is what is failing

*Coverage: all three users.*

> "The first few lessons were genuinely fun." — **Amara**

> "I really wanted it to work." — **Tom**

No user criticized the lessons, the tracks, or the five-minute format. Priya built a daily ritual around it. This scopes the problem away from content and onto the retention mechanic — useful for ruling out an expensive direction.

---

## Contradictions and Tensions

**The mechanic that retains Priya is the one that expelled Tom.** Softening the stakes to relieve Amara risks removing Priya's stated reason for staying. There is no version of "make the streak gentler" that is free.

**Priya's success is survivorship, and she says so herself.** She is the strongest evidence the current design works, and she volunteers that "most people quit long before the habit forms." The retained user testifies against the generalizability of her own experience.

**Amara is disengaging without having broken anything.** She has not missed a day. Her stated harm comes from the *anticipated* penalty. This cuts against the working hypothesis in `strategy.md`, which locates the failure at the moment of reset — Amara's damage precedes any reset.

**Tom and Amara are failing for different reasons at different stages.** Tom had a 12-day streak and was "proud of it," so the mechanic worked on him for five weeks before the break killed him. Amara is straining at day 4 with no break. One intervention is unlikely to serve both cases.

**Priya's first celebration landed at day 30 — three weeks after the Day-7 measurement window closes.** Whatever acknowledgment the product currently offers arrives long after the users we are trying to retain have already decided.

---

## The Single Most Important Insight for Week-1 Retention

**In week 1 the streak creates anxiety before it creates attachment, so the week-1 loss is driven by the anticipated penalty — not by an actual reset.**

The sample supports this structurally: no interview locates a week-1 *break* as the churn trigger. Tom's break came at week 5. Priya's first reward moment came at day 30. The only week-1 voice, Amara, is losing interest at day 4 with her streak still intact, describing pressure and "a chore instead of a game."

**Two consequences for the current plan:**

1. A Comeback screen triggers *on* a break. By construction it cannot reach the Amara case, which is the only week-1 case in this sample. It may well be the right fix for the Tom case — that is a week-5 problem, not a Day-7 problem.
2. The first acknowledgment moment appears to sit at day 30. Pulling an earlier one inside week 1 is a candidate intervention this research surfaces and the current hypothesis does not cover.

**Load-bearing caveat:** this insight rests on one week-1 interview. It is the least-tested and most consequential claim in this document, and it should not carry a frame until more week-1 users are talked to. Stated as the sharpest available hypothesis, not a finding.

---

## Open Questions This Raises

1. Do more week-1 users report pre-emptive streak anxiety without having missed a day? (Directly tests the insight above; currently n=1.)
2. When does a new user first receive any acknowledgment from the app? If day 30 is accurate, is that a deliberate choice or an artifact?
3. Does Raj's "two consecutive misses → ~2x churn" finding hold for week-1 users specifically, or is it carried by later-stage users like Tom?
4. Did v2 change the stakes, the notification, the celebration schedule, or all three? Needed before any causal claim.
5. Is there a design that lowers early stakes without devaluing a long streak for users like Priya?
