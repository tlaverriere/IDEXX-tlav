# Speaker Notes — Quarterly Review

*2026-09-17 · Trevor Laverriere · read with `presentation.md`*

**Say this before slide 1 goes up, while it is still on the title:**

> "Before I walk the problem, here is where I land, so you can listen for whether I
> earn it. We should ship the notification and the Comeback surface now and hold the
> production streak changes for a properly powered test. Query 1 is assigned to Raj
> for Wednesday — it sat unowned for four days and I stopped waiting, so tell me if
> you want it elsewhere. And I want to withdraw a number I put in front of you — it
> doesn't hold up, and I'd rather say that in the room than have you find it."

*That covers his preference for the recommendation first, and clears the deck to run
problem-first the way he asked. It also front-loads the withdrawal, which is the
only way it reads as candour rather than as something I got caught on.*

---

## Slide 1 · The problem

Day-7 retention is at 39%, down from 48% since the streak redesign shipped, and that
is the one number in this deck I would defend without a caveat — it comes straight
off the retention dashboard. The more useful finding sits underneath it: across three
user interviews and ten NPS verbatims, **not one person criticised the lessons, the
tracks, or the five-minute format.** Every piece of praise we have is about the
content and every complaint is about the streak system. What I want you to take from
this slide is that we have already ruled out the expensive direction — this is not a
content problem, and we do not need to spend a quarter rebuilding curriculum to fix
it. One thing I am deliberately not claiming: that the v2 redesign caused the
decline. We have correlation in time and we have never examined the confounds.

## Slide 2 · Why now

What changed this quarter is that we stopped guessing where the nine points went.
Two findings, and the second one is uncomfortable: day-1 activation is flat at 90 to
93% across every cohort, so users are arriving and then leaving inside days two to
six — but when we decomposed a ten-point decline, **more people breaking their
streaks accounted for only 1.7 points.** The other 8.3 came from users who kept
their streaks intact and left anyway. That matters because the three features you
approved all act on the break, so on this evidence they address the smaller share of
the problem — which is exactly what Query 1 exists to confirm or kill. The reason
this is urgent rather than interesting is that MAU is still growing 28% year over
year, so a nine-point retention leak is invisible at the top line while it quietly
raises what we have to spend to stay flat. You have asked me three times what that
costs us in acquisition spend and I still do not have the number — I am not going to
estimate it in front of you, and I have written it into the Query 1 brief as Query
1c so it stops being a standing question — though I should be straight that it needs
two inputs and we only own one, because the users-lost half comes out of Query 1 and
the cost per user has to come from finance.

## Slide 3 · The proposal

This is Option C exactly as you approved it on the 16th — Comeback Screen, Freeze,
Weekly Streak — and the property the whole design turns on is that a week-1 user's
first missed day costs them nothing visible. What is new on this slide is the split:
the notification and the Comeback surface ship now because they are reversible and
touch no streak state, and the production streak accounting holds until the full test
reads out, because that one migrates 2.1M users' streak history and a revert does not
un-corrupt it. I have also put what this is *not* on the slide, because three of
those four have already come back at me as questions: the freeze is only ever earned
and never bought or gifted, notification quality is Fast track 1 rather than part of
this, none of the three features reaches a user who simply drifts away, and the
pre-emptive warning was cut from scope on the 16th. What I want you to take away is
that this is not a change of direction — it is the proceeds-and-holds split you
already approved, applied to the first real decision it touches.

## Slide 4 · Evidence

Two things happen on this slide and I want to do the harder one first. **I am
withdrawing the +30 percentage point Day-7 result.** When we decomposed it, 17.6 of
those 30 points came from users who never saw the screen, the day-7 outcome was never
actually observed in the data, and the study was only ever able to detect an effect
of 28 points or larger — so it found one. What does hold is the return visit: every
treated user came back the next day against 14% of the control, and among users who
had genuinely broken a streak it was 20 out of 20 against 4 out of 25. Set that
beside the fact that our current "you lost your streak" notification has a **zero
percent action rate across 141 sends** — there has never been anything to act on —
and beside Tom, who told us "there was no way to recover it, nothing, so I gave up."
The honest frame is that we have good evidence we can bring lapsed users back and no
trustworthy evidence yet that it holds them to day seven. And you should know that
**no user has seen the prototype** — the reactions we have been designing against are
persona exercises, our week-1 interview evidence is a single person, and the five
real usability sessions that fix that are being scheduled now with three confirmed.

## Slide 5 · The plan

Two tracks and one gate. The surface work proceeds immediately with a kill switch in
scope; the full test is specified and powered — five points minimum detectable
effect, 80% power, about 1,568 users per arm with streak-breakers pre-registered as
the primary population — and the streak accounting, the schema migration and any
external commitment all hold until Query 1 lands. Query 1 itself is days of work on
data we already have, and it is the only item on this slide with nobody assigned to
it. Three risks worth your attention: Query 1 could come back showing the loss sits
with users who never established a streak, in which case none of the three features
touches it; the Comeback screen's audience is shrunk by the other two features
because they are designed to prevent the break it responds to, and **nobody has sized
what is left**; and the surface's only entry point is a notification, with no in-app
fallback for a user who has turned push off. One honest gap in the timeline — fitting
the test into eight weeks requires at least 1,120 new signups a week, and because
Day-7 is a new-signup metric our 85,000 weekly actives are not the enrolment pool, so
I need that figure from Raj before I commit to the date.

## Slide 6 · The ask

One thing to reverse if you want to, and two to confirm. **Query 1 is assigned to Raj
and due Wednesday the 23rd** — it is the gate your approval rests on, it had nobody on
it for four days, and rather than keep asking I made the call, so if you want it
somewhere else say so now while there is still time to move it. Second, I need you to
confirm that above 50% Day-7 within four weeks still stands as the target, because
nothing we currently hold substantiates it — and if it stands, I want it on the record
as a commitment made on judgement rather than on evidence, so we are not surprised by
our own bar later. Third, I would like us to agree that the +30 points does not leave
this team, board material included, until it survives a powered re-run. The gate you
asked for on Thursday did its job — it is why I can tell you the number is wrong
before we built anything on it — and it is now owned and dated rather than waiting on
either of us.

---

## If he pushes — the three most likely and where the answers live

- **"Fifty users? What can I say about this at board?"** → Say the return visit, say
  nothing about Day-7 until the re-run. It is a composition problem, not a
  sample-size one; more users would not have fixed it. Full answer in
  `objection-log.md` M1.
- **"I asked whether the problem was the reset or the notifications. You've shown me
  the notification change works and the reset change doesn't. Are we building the
  wrong half?"** → Concede the shape. The evidence supports the cheap half and is
  silent on the expensive half, so the consequence is sequencing rather than
  cancellation — which is this deck's proposal. `objection-log.md` question 2.
- **"Then why fund the Comeback screen at all, if it isn't measured on Day-7?"** →
  **This is the one that can cut the feature, and the answer is a number I do not
  have.** Do not defend the scope. Offer to produce the breakers-through-protection
  figure from the counterfactual replay and bring it back before the build decision.
