# Comeback Screen — Results Memo

*2026-09-17 · Trevor Laverriere · for Marcus · one page*

> **Send this as the Slack covering line, so the ask lands before he opens the doc:**
>
> *"Marcus — headline: the surface change is working and the retention number
> isn't, and they're separable. Recommendation is to keep building and stop
> quoting the +30 pp. I've assigned Query 1 to Raj for Wednesday rather than wait
> — say now if you'd rather it sat elsewhere. Memo is one page."*

---

# Part 1 · The memo

## Situation

We analysed the week-5 instrumented cohort — 50 users shown the Comeback surface
against 50 held back — to test the claim the approval rested on: that a graceful
route back after a broken streak improves Day-7 retention. Two questions were on
the table. Does the surface change behaviour, and does that behaviour reach Day-7.

**Provenance, stated up front:** this extract carries no observable activity past
day 4, so its `day_7` and `day_30` flags are asserted rather than measured, and
its figures do not reproduce our live 39%. It is good enough to tell us what to
build and what to measure. It is not good enough to substantiate a target.

## Evidence

- **The surface works, and this is the solid result.** Every treated user returned
  the next day — **50/50 against 7/50** held back. Among users who had actually
  broken a streak, **20/20 came back against 4/25**. For comparison, the current
  "you lost your streak" notification has a **0% action rate across 141 sends.**
  We have never had a mechanism that brought lapsed users back. This is one.

- **The +30 pp Day-7 lift does not hold, and I would not repeat it upward.**
  Decomposed, **17.6 of the 30 points come from users who never saw the screen**,
  8.8 from the users it targets, and 3.6 from the two groups having different break
  rates to begin with. At 50 per arm the study could only ever detect a swing of
  +28 pp or larger. Under a third of the headline is attributable to the feature.

- **The decline we are fixing is mostly not break-shaped.** Of a 10-point drop
  across cohorts, **more users breaking streaks accounts for 1.7 points**; the
  other 8.3 is users who kept their streaks and left anyway. Separately, starting
  a streak barely predicts Day-7 at all — non-starters retain at 33.8%, starters
  at 32.8%. **Query 1 is now more load-bearing than when you gated on it, not less.**

## Recommendation

Keep building the Comeback surface on the strength of the return-visit result,
withdraw the +30 pp retention claim until week 5 is re-run with a closed
measurement window at roughly 700 per arm, and treat Query 1 as the live gate it
was approved as rather than a formality.

## Ask

1. **Query 1 is assigned to Raj, due Wednesday 2026-09-23. I need you to object now
   if you want it elsewhere.** It sat unowned for four days while the release stayed
   gated on it, so I stopped waiting for the assignment and made it. Raj is the only
   defensible owner — he produced the finding the gate exists to test and already
   holds the data cut it needs. **This was previously framed as your call, and I am
   telling you rather than asking**, which is a change you should have the chance to
   reverse before Wednesday.
2. **Confirmation at Thursday's meeting (2026-09-24) that >50% Day-7 in 4 weeks
   still stands** as the target, given that nothing we now hold substantiates it.
   If it stands, it is a commitment made on judgement rather than evidence, and I
   want that on the record as such.
3. **Agreement that the +30 pp does not leave this team** — including in board
   material — until it survives a powered re-run.

## Risk if we wait

Until Wednesday we are still spending squad capacity on three features aimed at a
problem statement our own decomposition suggests explains under a fifth of the
decline — and I still cannot tell you what the leak costs in acquisition spend,
which is the third time you have asked and is now Query 1c.

---

# Part 2 · Skeptical Marcus — the three hardest questions

*My prep, not for sending. Ranked by how hard they are to answer well.*

## 1 · *"Fifty people. Half of whom you're telling me couldn't see the thing. What can I actually say about this in a board meeting?"*

**Why it's hard:** it is the correct question and the honest answer is "very little
about retention." He is not asking about statistics, he is asking what survives
contact with an audience that will not read a caveat.

**How I'd answer:** two sentences and a boundary. *Say the surface brought every
lapsed user back the next day against 14% of the control — that holds, it is the
first mechanism we have ever had for the return visit, and it is the thing worth
saying out loud. Say nothing about Day-7 until the re-run.* The +30 pp is not a
small number with wide error bars, it is a number whose majority share comes from
users the feature cannot reach — that is a composition problem, not a sample-size
problem, and more users would not fix it. What fixes it is ~700 per arm with the
window closed, which is one cycle.

**What I must not do:** offer the +30 pp with a caveat attached. He will drop the
caveat by the time it reaches the board, and he will be right to — a caveat that
survives two retellings was never load-bearing.

## 2 · *"In the original thread I asked whether the problem was the reset or the notifications. You've just shown me the notification change works and the reset change doesn't. Are we building the wrong half?"*

**Why it's hard:** because it is his own unanswered question coming back with our
data behind it, and the honest answer is *possibly.* His profile flags this exact
risk — we took a de facto position by splitting notifications into Fast track 1
and never stated it. This is where he notices.

**How I'd answer:** concede the shape, then separate the two claims. The result
that held is a **messaging** result — we changed what the notification says and
lapsed users came back. The result that did not hold is the **retention** claim,
which is where the streak-accounting work sits. That does not mean the reset work
is wrong; it means we have evidence for the cheap half and none yet for the
expensive half. **The correct consequence is sequencing, not cancellation:** ship
the notification and surface change now, and hold production streak-accounting
behind Query 1 — which is exactly the proceeds/holds split he already approved. I
should say plainly that the split was implicit and should have been stated.

**Where I'd give ground:** if Query 1 shows drift rather than breaks, Fast track 1
stops being a fast track and becomes the main line. I should say that before he
does.

## 3 · *"You assigned my gate for me. What else have you decided on my behalf?"*

*Rewritten 2026-09-17. This slot used to read "I approved a direction gated on a
query that still has no owner" — that question is no longer available to him,
because the gate is now owned and dated. **The assignment answered one objection and
created a sharper one.***

**Why it's hard:** it is about authority rather than data, and he is partly right.
The gate was on the record as the reason his approval was sound, and I staffed it
without asking him.

**How I'd answer:** concede the framing was mine to correct and say what the
distinction actually is. **Query 1 and both fast tracks sit inside my squad — that
was capacity and prioritisation, which is mine.** Calling it his call was my error,
and it is the error that kept the gate unstaffed for four days while the release
stayed gated on it. **The CAC input is genuinely his**, because finance is outside
the squad, and that is the one name I am asking for. So the honest answer to *what
else* is: nothing — three of four were mine and I should have made them sooner, and
the fourth is the one in front of him.

**What I should not do:** apologise for the decision or offer to unwind it as a
gesture. **The offer to reverse it is real and it is in ask #1** — if he wants Query
1 elsewhere there is still time before Wednesday. But treating a correct call as an
overstep invites the next one to wait four days too.

**And still true regardless of who owns what:** the decomposition is not reassuring.
It is the clearest signal yet that the problem statement may be too narrow, and he
should hear it as that.

---

### He will also ask, for the third time: *"What is the cost of waiting another quarter?"*

Still unquantified, and I should stop presenting the qualitative version as an
answer. The shape is known — MAU growing 28% YoY masks a 9-point Day-7 decline at
the top line while quietly raising the acquisition spend needed to hold flat. The
number is not. **Raj now owns it as Query 1c**, and he can produce
the *volume* half — users lost per week to the 9 points — from the same data in the
same pass. **The unit cost is not ours**: blended or per-channel CAC has to come from
finance. **Now added to the plan as Query 1c** rather than carrying as a separate
open question for a fourth week. One query plus one request closes it — and it is
worth being precise that it is two inputs, not one, because promising it as a
byproduct is how it slips again.
