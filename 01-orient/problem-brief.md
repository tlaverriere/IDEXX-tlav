# Problem Brief — Day-7 Retention Decline

> ## Historical — superseded 2026-09-16
>
> This was the pre-read for Thursday's problem-alignment meeting. **Kept unedited below as the record of what was asked.**
>
> Thursday happened and **Marcus approved Option C** — Comeback Screen + Freeze + Weekly Streak — with the release gated on Query 1. For current state see `project.md` (phase), `strategy.md` (design and live risks), and `../02-research/decision-brief.md` (what was approved, and on what evidence).
>
> **None of the four questions below came back answered:**
>
> | Question | Status, 2026-09-16 |
> |---|---|
> | 1. Did the redesign cause this? | **Open.** Later demoted to *"attempted, abandoned if unanswerable"* — deliberately, since a randomised forward test doesn't require the answer |
> | 2. Does Raj's churn finding survive scrutiny? | **Open.** Still unreviewed, still unassigned |
> | 3. Reset, notification, or both? | **Never answered explicitly, but acted on** — notifications split off as Fast track 1, and the approved features address the reset-and-recovery half. A de facto position without a stated one |
> | 4. What are we targeting? | **Open.** No recovery number, no timeframe |
>
> The closing line — *"Design starts after that, not before"* — did not hold. The design was completed and approved with all four questions outstanding. The **Query 1 gate** is the safeguard that replaced this document's intent, and `validation-plan.md` is its successor.
>
> Two details in the body are also out of date: the Comeback screen is no longer parked, and its *"one-tap streak freeze"* component no longer exists — freezes are earned-only and auto-applied.

**Pre-read for Thursday.** Purpose of the meeting: agree on what is actually broken. We are not selecting a solution.

---

## The problem

Day-7 retention is 39%, down from 48%. The decline began after the v2 streak redesign shipped.

The loss is concentrated in users who break a streak during their first week. Our working read is that breaking a streak currently reads as failure rather than a setback: the counter returns to zero, the home screen is unchanged, the app does not acknowledge that anything happened, and the "you lost your streak" notification lands at the moment the user is most likely to quit. Documented research shows users describe the reset as a punishment and see no route back in.

If that read is right, the problem is not that users lose motivation. It is that we remove their accumulated progress at the exact point they need a reason to return, and we offer nothing in its place.

That framing is a hypothesis, not a finding. The point of Thursday is to test it.

## What we know, and how well we know it

**Verified.** Day-7 retention at 39% against a 48% pre-redesign baseline. Sourced from the retention dashboard.

**Documented, qualitative.** Users experience the streak reset as punitive and perceive no graceful re-entry. From Lena's user research write-up. Reliable as a description of how users feel; it does not establish how many users are affected or size the revenue impact.

**Directional only — treat as a hypothesis.** Users who miss two consecutive days churn at roughly double the rate of other users. This came from a single evening of analysis and has not been reviewed or validated. It is the most persuasive number we have and the least tested, which is exactly the combination that gets a team into trouble. It should not carry the frame until someone confirms it.

**Not established.** That the v2 redesign *caused* the decline. We have a correlation in time. We have not ruled out other changes shipped in the same window, cohort composition shifts, or seasonality.

## Questions Thursday needs to answer

**1. Did the redesign cause this?**
Everything downstream depends on the answer. What else shipped in that window? Does the decline hold when we control for acquisition mix? Until this is settled, every problem statement we write — including this one — is provisional.

**2. Does Raj's churn finding survive scrutiny?**
Who validates the two-consecutive-misses figure, and by when? If it holds, the week-1 streak break is our intervention point. If it does not, we are looking at a broader retention problem and the framing above is too narrow.

**3. Is the problem the reset mechanic, the notification, or both?**
Raj's instinct is both, with the post-break experience mattering more. These imply different owners and very different cost profiles. We should not leave the room without a position, even a provisional one.

**4. What are we actually targeting?**
No goal or timeframe has been set. Is the aim recovering the 48% baseline, arresting the decline, or something else? Without this we cannot judge whether any solution is worth building.

## Explicitly out of scope for Thursday

Lena's Comeback screen concept — best-streak stat, a 60-second comeback lesson, one-tap streak freeze — is a credible response to the problem as framed above, and Raj has confirmed it is buildable with existing data sources. It is parked on purpose.

Two reasons. It only addresses the post-break half of the problem, which question 3 has not yet resolved. And it presumes the causal story in question 1, which is unverified. Discussing it Thursday would let us feel aligned on a solution while the problem underneath is still open.

The concept is preserved in the PRD skeleton in `orientation.md` and loses nothing by waiting one meeting.

## What I need from the room

Agreement on the problem statement, or a better one. Owners and dates for questions 1 and 2. A provisional position on question 3. A target for question 4.

Design starts after that, not before.
