# Objection Log — Comeback Screen PRD

*2026-09-17 · Trevor Laverriere · pressure-test of `prd.md` against three reviewers in sequence*

**Framing.** Raj and Marcus are reviewing the document. **Tom is not** — he is a
churned user and would never read a PRD, so his two are the questions the *feature*
has to answer for him, voiced as him. Sourced from his interview excerpts in
`../02-research/interview-synthesis.md`.

---

# 1 · Raj — Engineering Lead

## R1 · *"You've told me what to measure and not what counts as working. What's the number?"*

**Why it lands.** This is his standing question — *"How will we know if this is
working after it ships?"* — and his profile records it as still unanswered. The PRD
gets closer than anything before it: it names the primary metric as return rate
among users whose daily streak has broken, and correctly refuses the Day-7 target.
**Then it stops.** The only reference point offered is *"sample data 100% vs 14%"*,
labelled synthetic and explicitly not to be treated as a rate.

So the spec tells him the metric, tells him the one number attached to it is
unusable, and sets no threshold. *"Better than control"* is not a definition of
done — it is satisfiable by noise, which is the precise failure `hypothesis.md`
flagged when it said that without a target, *"a recovery in early retention"* can be
claimed on any positive movement.

**He asked this twice. The PRD is the third time it comes back unanswered in
number form.**

**What would satisfy him:** a return-rate threshold and a window, set the way the
Day-7 target was set — as a judgement on the record, not derived. Something of the
form *"≥X% of breakers return within 48 hours, measured on cohorts from week 3
onward."* It does not need to be defensible from data we do not have. It needs to
exist, because a metric without a bar cannot fail.

## R2 · *"Rollback is in your open questions. It's a requirement. Why am I being asked for it?"*

**Why it lands.** His profile names it directly: he pushes back on *anything touching
the streak or notification pipeline without a clear rollback plan.* The PRD writes
the streak counter — daily streak to 1 on completion, week streak untouched — and
files the revert path under Open Questions addressed to him.

**That inverts the responsibility.** He is being asked to supply a requirement the
spec should have stated as an acceptance criterion. And the stakes are documented:
`codebase-summary.md` found that in the closest production analogue the streak reset
sits inside the day-rollover transaction next to HP loss and a full buff wipe, and a
bug there rolls back the user's whole day.

He will also fold in a second, related point, and it is fair: **two of the five user
stories depend on things that do not exist** — the empty state (story 2) and a break
counter (story 5). The PRD names both honestly, which is better than hiding them,
but names them without an owner or a size. His other recorded pushback is *scope
that grows mid-sprint.* If the break counter lands mid-sprint that is scope growth;
if it does not, story 5 cannot ship and its acceptance criterion is untestable.

**What would satisfy him:** promote rollback to a goal with an acceptance criterion,
and split the two unbuilt dependencies into their own line items so they are either
in the sprint or explicitly deferred. Per his async-first preference, both should
reach him in writing before any kickoff — not raised in the room.

---

# 2 · Marcus — Head of Product

## M1 · *"I approved a program to fix a 9-point Day-7 decline. This PRD says it isn't measured on Day-7. What am I funding?"*

**Why it lands.** It is his own unanswered question — *"How does this affect our
Day-7 retention number specifically?"* — and the PRD answers it in the negative, in
bold: *"The >50% Day-7 target belongs to the tolerance layer — attributing it here
would make this feature unfalsifiable."*

**That is methodologically correct and it creates an accountability gap.** He
approved three features to move one number. If each feature's spec disclaims that
number and points at a different layer, **nobody owns the 9 points.** The
disclaimer that protects this feature from an unfair test also removes it from the
business case that funded it.

He will not read this as rigour. His profile says he notices when he is being sold
to, and he will read a metric substitution as exactly that — the feature quietly
moving to a bar it can clear.

**What would satisfy him:** state program-level metric ownership explicitly.
Something of the form: *the tolerance layer owns the >50% Day-7 target; the Comeback
screen owns reactivation and contributes to Day-7 only for breakers inside their
first seven days, a population sized at N.* One sentence of ownership, one number of
contribution. Without it, the reactivation metric looks like an escape hatch.

## M2 · *"How many users does this actually reach, and what is that worth? Your own brief says the other two features shrink its audience."*

**Why it lands.** His profile pushes back on **data that does not connect to a
business outcome**, and the PRD contains no audience size anywhere. It says who the
feature serves and, carefully, who it does not — but never how many.

**And the argument against is already in our own documents, in my handwriting.**
`decision-brief.md` rev 5, the case against Option C: *"B shrinks the Comeback
Screen's audience — fewer users ever reach a broken streak."* The Freeze absorbs the
first missed day and the miss bank covers four misses in week 1. **The tolerance
layer is designed to prevent the event this feature responds to.** Nobody has
computed what is left.

He also has a ready-made exit that I handed him: the same brief states *"the
alternative I'd accept: B first, then A — ship the two features, measure how many
users still break through protection, and size the Comeback Screen's real audience
before paying to build it."*

**What would satisfy him:** the size of the remaining audience — breakers-through-protection
per week — and the retained-user value of moving their return rate. The counterfactual
replay spec at `../05-decide/counterfactual-replay.md` can produce the first number
from historical data. It is unowned.

---

# 3 · Tom — churned user, broke a 12-day streak, now on Duolingo

## T1 · *"The notification is why I left. You've put it out of scope."*

> *"The app sent me this 'you lost your streak' notification that just made me feel
> bad."*

**Why it lands.** The PRD's Non-Goals table excludes **notification tone, timing and
volume**, routing them to Fast track 1. The prototype's only entry point is a
notification. So the document specifies the screen behind the door and declares the
door someone else's problem.

**For Tom the door is the whole story.** He stopped opening the app. The surface
reaches him only if he taps a push from the app that last made him feel bad — and
`hypothesis.md` already carries this as open question 10: *whether the notification
is a prerequisite rather than a parallel track.* The PRD does not resolve it; it
formalises the split.

QA checklist P1 sharpens it further: if push is disabled there is **no in-app
fallback at all**, and the PRD does not add one.

**What would satisfy him:** either make Fast track 1 a stated prerequisite rather
than a parallel track, or add an in-app entry point so the surface survives a user
who has stopped trusting our notifications. The PRD currently does neither.

## T2 · *"By the time I'd see this, I'd get a grey card telling me my best was 12 days. That's the reset again, with better manners."*

> *"There was no way to recover it, nothing. So I gave up."*
> *"I switched to Duolingo, at least there a missed day doesn't wipe everything, and
> a streak freeze feels forgiving."*

**Why it lands, and this is the one I did not expect to be this bad.** Tom was
roughly eight days absent. Under our own arithmetic — `hypothesis.md` known fact 8 —
**the week streak breaks before the daily streak for any user who accumulates
freezes**, because seven freezes means eight missed days while the weekly goal
tolerates at most four in a week. So by the time Tom returns, **both counters are
dead.**

That is user story 3. What the PRD specifies for him is the **memento fallback**: a
card naming his best-ever figure and stating nothing is running.

**The design's premise is "lead with what survived." For Tom, nothing did.** He gets
a number telling him what he used to have — which is a more articulate version of
the counter reading zero, the thing that made him quit. The PRD is honest about this
and calls it "an honest fallback." Honest is not the same as forgiving, and
forgiving is what he asked for by name.

Meanwhile the thing he says he switched for already exists elsewhere: *a missed day
doesn't wipe everything.* That is the tolerance layer, not this surface.

**What would satisfy him:** he is not the user this feature serves, and the PRD
should probably say so. The Freeze and Weekly Streak address Tom. The Comeback
screen serves the user who breaks *through* protection with a week streak still
alive — a narrower and less sympathetic population than the one whose quote opens
the problem statement.

---

# Which objection kills the initiative

**M1 — the Day-7 disclaimer — with M2 as its accelerant.**

Not because it is the most substantively serious. **T1 is the deepest problem**: if
the surface is unreachable the feature does not work regardless of funding. But T1's
consequence is *resequencing* — make Fast track 1 a prerequisite — and resequencing
survives a meeting.

M1 kills it because **Marcus holds the greenlight, and M1 hands him a correct and
complete argument for cutting this feature while keeping the other two:**

1. The PRD states this feature is not measured on Day-7.
2. Day-7 is the reason the program was funded.
3. Our own decision brief says the other two features shrink this one's audience.
4. Nobody has sized what remains.
5. **Our own brief already names the alternative** — *"B first, then A"* — and offers
   to size the audience before paying to build it.

Every step is documented, in my handwriting, in a file he has read. He does not need
to construct the case; he only needs to adopt it. And it is not a bad decision — on
the information as currently written, descoping the Comeback screen to a later phase
is defensible.

**What to address upfront, in this order:**

1. **State program-level metric ownership in the PRD.** The tolerance layer owns the
   >50% Day-7 target. The Comeback screen owns reactivation and contributes to Day-7
   for one named population. Do not let the disclaimer stand alone — as written, a
   correct methodological point reads as a feature dodging its own business case.
2. **Size the audience.** Breakers-through-protection per week. The counterfactual
   replay produces it from historical data and is unowned. **This number decides
   whether the feature is worth building**, and I would rather produce it than have
   Marcus ask for it.
3. **Pre-empt the "B first, then A" exit by answering it.** Either accept the
   sequencing and say so, or give the reason it costs more than it saves — that the
   state-awareness gap (NPS R7) and the unowned return visit stay open in the
   interim.
4. **Resolve T1 in the PRD**, because it is the first thing Lena will raise and the
   answer is cheap: either promote Fast track 1 to a prerequisite or add an in-app
   entry point.

**The uncomfortable part.** M1 and T2 point the same way. M1 says the feature cannot
claim the program's metric; T2 says the user whose quote opens the problem statement
would receive a memento rather than a recovery. **Both suggest the Comeback screen's
real audience is narrower than the research used to justify it.** That is worth
knowing before the room decides, not after — and it is an argument for producing the
audience number quickly rather than for defending the scope harder.
