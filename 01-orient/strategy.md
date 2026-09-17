# strategy.md — Recovering the 9-Point Day-7 Drop

*Last updated: 2026-09-14*

## Where this fits

Day-7 retention is Streakly's north star. MAU is still growing 28% YoY, which means the 9-point drop is currently masked at the top line — new users are covering for a leak in early retention. That masking is the strategic risk: the further Day-7 sits below baseline, the more acquisition spend is required to hold flat MAU, and the decline compounds quietly.

## The hypothesis

**Users go passive because breaking a streak feels like failure, and there is no graceful comeback.**

The mechanism, as we currently understand it:

1. A user builds a streak. The streak is the product's engine, so accumulated streak length *is* their felt progress.
2. Life intervenes and they miss a day.
3. The counter resets to zero. Their accumulated progress is removed at the exact moment they most need a reason to return.
4. The "you lost your streak" push arrives with a punitive tone, at peak quit risk.
5. Tapping through lands them on an unchanged home screen at day zero. The app does not acknowledge that anything happened and offers nothing in its place.
6. They don't come back.

Lena's research supports steps 3–5 as lived experience: users describe the reset as punishment and perceive no route back in. As of 2026-09-14 that corroboration strengthened: "no way back after a break" is the top theme across 10 NPS verbatims (4 mentions) and recurs in the interview set. It is no longer single-source.

**Known gap in the mechanism.** Every step above assumes a break occurs. Two independent sources now show churn without one — a day-4 interviewee disengaging with her streak intact, and two NPS respondents who drifted or "forget it exists." The hypothesis as written cannot account for those users, and a break-triggered fix cannot reach them by construction. Whether this drift path comes into scope is an open decision, not a settled exclusion.

**The strategic implication, if the hypothesis holds:** the fix is not more motivation. It is giving users a reason to return that is specific to them and their own progress. Generic encouragement is the thing that has already failed.

## Confidence in the hypothesis

| Claim | Confidence | Source |
|-------|-----------|--------|
| Day-7 is 39% against a 48% baseline | **Verified** | Retention dashboard |
| Users experience the streak reset as punitive, with no re-entry path | **Documented, qualitative** | Lena's research write-up |
| Absence of a recovery path drives disengagement | **Documented, corroborated** | Top theme in 10 NPS verbatims (4 mentions) plus the interview set. Two independent sources. Upgraded 2026-09-14 from single-source. |
| Churn also occurs with no streak break (drift path) | **Directional, and strengthened 2026-09-17** | 2 NPS respondents + 1 day-4 interview. Two independent sources, very small n. **Third source added, different in kind:** decomposing a 10-point cohort decline in the sample data attributes 1.7 points to more users breaking and 8.3 to retention falling within both groups — with the fall concentrated in users who never broke. Synthetic data, so this raises confidence without changing the tier. See `data/metric-findings.md` Q2. |
| Week-1 harm begins before any reset | **Directional, single-source** | One day-4 interview. The most consequential and least tested claim we hold. Must not carry a frame. |
| Five of five direct competitors ship a missed-day forgiveness mechanic; we do not | **Verified** | Primary-source competitive scan, 2026-09-14. Our current design matches only Lumosity — included in the scan as the do-nothing control case. |
| Neither candidate's market position is currently occupied | **Documented, with a research caveat** | Competitive scan. Caveat: no company documents its post-miss screen, so "unowned" is partly "not observable by desk research." Needs first-hand capture to firm up. |
| Two consecutive missed days → ~2x churn | **Directional only, and the magnitude is now questioned** | Raj, one evening of analysis. Unreviewed. Our most persuasive number and our least tested. **2026-09-17:** the sample data agrees on direction — week-1 breakers retain 15 pp worse at Day-7 (23.4% vs 38.4%, *p* = 0.0022), holding in all five cohort weeks — but puts the churn relative risk at **1.24–1.34, not 2x**. Different dataset and synthetic, so it does not overturn Raj's figure; it does mean "~2x" should stop travelling unqualified. |
| The v2 redesign caused the decline | **Not established** | Correlation in time only. Confounds unexamined. |
| Easy forgiveness devalues the streak and weakens its motivating power | **Directional, external voice** | Hacker News / Clozemaster, 2026-09-14. Long-streak holders on a mature product — a vocal, self-selected group at the opposite end of the lifecycle from our problem. See the cross-cutting risk section below. |
| Any of the above holds *for week-1 users specifically* | **Known gap** | Interviews and NPS are both stage-mixed and unlabeled. Our core metric is Day-7; no current evidence is segmented to it. |

The hypothesis still rests on the two weakest rows — Raj's figure and v2 causality. That is the honest strategic position, and it is why discovery comes before design. The 2026-09-14 research moved one row up and opened two new ones; it did not close either of the two that matter most.

## What has to be true for this strategy to hold

**1. v2 caused it.** If something else shipped in that window, or acquisition mix shifted, or the effect is seasonal, the entire frame is wrong and we would be fixing a symptom of a different disease.

**2. The week-1 streak break is the intervention point.** This rests entirely on Raj's unvalidated figure. If the churn concentration doesn't hold, we have a broad retention problem and this strategy is too narrow to address it.

**3. The post-break experience matters more than notification timing.** Raj's instinct is "both, with post-break mattering more." Unresolved. These imply different owners and very different cost profiles — a notification tone-and-timing fix is far cheaper than a new surface.

**4. The problem is break-shaped.** *Added 2026-09-14. Weakened 2026-09-17 — this is now the condition most likely to fail.* The hypothesis and the Comeback concept both trigger on a break. Two sources suggest a share of churn is drift, not reset — users who never break anything and simply fade. If that share is material in week 1, a break-triggered fix addresses only part of the loss and the problem statement needs widening before we scope a solution.

**A third source now points the same way, and it sizes the share.** Decomposing a 10-point Day-7 decline across cohorts in the sample data: **1.7 points from more users breaking, 8.3 points from retention falling within both groups** — with breakers flat (23.1% → 22.9%) and non-breakers falling (41.9% → 29.2%). On that shape, most of the decline is not break-shaped at all.

The data is synthetic and does not reproduce Streakly's real figures, so this is not evidence the condition fails. It is the clearest statement yet of *how* it would fail, and it is the exact decomposition Query 1 was specified to produce on real data. Worth putting to Marcus before the query lands — an approved direction plus an inconvenient answer is harder to absorb than an inconvenient answer that was flagged as possible in advance.

## Approved interventions

> **Approved 2026-09-16.** Marcus approved **Option C** — Candidate 1 (Comeback Screen) and Candidate 3 (Freeze + Weekly Streak) ship together, with the **release gated on Query 1** rather than assumed by it.
>
> The "parked" framing below is superseded. **The risks and open questions are not** — every one of them is still live, and none was closed by the approval. Candidate 2 remains superseded: it was replaced by Candidate 3, not approved.

### Candidate 1 — Comeback screen (Lena)

Lena's **Comeback screen**: shown when a streak breaks, replacing the cold reset with the user's best-streak stat and one 60-second comeback lesson to rebuild momentum. Raj confirms it is buildable with existing data sources; targeting logic is unbuilt.

> **Amended 2026-09-14 — the one-tap streak freeze has been removed from this concept.** Candidate 3 eliminates the freeze entirely, so the third component of Lena's original sketch no longer exists. **Done 2026-09-16 — Trevor told Lena directly.** *(Her reaction is not yet recorded here.)* It is her concept and the changes were material: the freeze affordance removed, the concept parked and un-parked, and a pre-emptive trigger added that changes what the surface is. What remains of the concept is the *acknowledgment* half, which is also the half the competitive scan says nobody owns.

Parked on purpose, for three reasons. It addresses only the post-break half of the problem, which condition 3 has not resolved. It presumes the causal story in condition 1, which is unverified. And as of 2026-09-14 it has a known coverage gap: it fires on a break, so it cannot reach the drift-path users in condition 4 — including the only week-1 user we have interviewed.

Worth stating plainly, because the research cuts both ways: the *problem* it targets is now better evidenced than it was, while its *coverage* is now known to be narrower than assumed. Neither of those settles whether it gets built.

**Competitive support — added 2026-09-14.** The scan found **no competitor running a designed return session as a standing surface**; the position is unowned. Duolingo sized it inadvertently: a one-time June 2026 offer to restore a lapsed user's longest-ever streak for three lessons drew **15.4M revivals, roughly 8M from users with no active streak**, which management called evidence of the scale of the win-back opportunity — then left it as a campaign rather than building it. Caveat carried forward: part of why this space looks empty is that no company documents its post-miss screen, so "unowned" is partly "not observable by desk research." See `../02-research/competitive-matrix.md`, Gap 1.

**Approved 2026-09-16** as part of Option C. The coverage gap above is unchanged by the approval: it fires on a break, so it still cannot reach a pre-break week-1 user or the drift path. Shipping it does not close either.

### Candidate 2 — 26-of-30 goal, alongside the streak freeze · **SUPERSEDED**

> **Superseded by Candidate 3 on 2026-09-14.** The freeze was eliminated entirely and the quota reworked into a calendar-month goal with its own month streak. Everything below is kept as the record of how the design arrived where it did — **do not scope work from it.** Specifically obsolete: the streak freeze, the slack double-count question, the 2×2 attribution problem, and the fixed first-30-days window.

*Raised by Trevor, 2026-09-14. Originally framed as an alternative to the freeze, then revised to sit alongside it. Confirmed the same day: it does **not** replace the streak counter.*

**What it is.** An explicit quota goal — complete 26 of your first 30 days — with four misses pre-granted rather than earned or purchased. The streak counter stays as the headline number and the streak freeze stays in place. All three coexist.

**Why it is worth taking seriously.** It is a *framing* mechanic, not a repair mechanic. The freeze and the Comeback screen both fire at or after a break; a quota changes the stated target from day 1. That makes it the only candidate we hold that sits **upstream** of the break, which is where our week-1 evidence points (condition 4, drift path). It also covers Tom's case: two travel days spend two spares rather than a 12-day streak.

**The central risk, now that the counter stays.** The reset still happens on screen. A user who misses a day still watches the counter go to zero — the exact experience described in research as "a big fat zero" and losing "everything I've built." The quota softens the *goal* while the *counter* still delivers the punishment. At the moment of a miss, the product would be saying two contradictory things at once: you lost your streak, and you are still fine. Whether that lands as reassurance or as mixed messaging is an empirical question, and it is the first thing a concept test should probe.

**Unresolved design questions. This is a candidate, not a defined intervention:**

1. **Does slack double-count?** Users would hold four spare days *and* freeze tokens. If a miss can spend either, effective tolerance is the sum and the goal may become unfailable. Removing the stakes removes what retains long-streak users — one NPS respondent: *"The streak is the only thing keeping me engaged."*
2. **Is 26 the right threshold?** Currently an assumption, not a finding. Treat the number as a parameter for the data to set, not a given to design around.
3. **Front-loaded slack may move the cliff rather than remove it.** Spares deplete. A user at day 9 with one spare left faces 21 days of required perfection — potentially a steeper cliff, later. Rolling or regenerating windows would need testing.
4. **Comprehension load — now three systems.** A week-1 user would track a streak counter, a depleting spare-day budget, and a freeze token, aimed at a population already describing the product as "a chore instead of a game." With the counter retained, legibility becomes the top design risk rather than a secondary one.

**The attribution problem.** Because the mechanics would ship together, a control-versus-bundle test shows whether the bundle works but not which half did it — and we would carry both indefinitely without knowing if one is dead weight. Clean attribution needs a 2×2 factorial (control / freeze only / quota only / both), and an interaction effect requires materially more power than a main effect. The cheaper path is to **sequence**: quota first, since it targets the evidenced failure mode, then layer the freeze only if a gap remains. Raj to size the minimum detectable effect before either is committed.

**What gates this — and may kill half of it for free.** A counterfactual replay on existing week-1 cohorts: among users who churned after a reset, how many had four or fewer total misses in their first 30 days?

- Mostly **more** than four → the quota would not have saved them. Candidate is weak, nothing was built.
- Mostly **four or fewer** → strong prior, and it may simultaneously show the freeze is **redundant**, since the quota would have absorbed the same misses.

This runs on existing data, requires no new sources, and could rule out half the bundle before any build. It is problem-validation work, not solution design, so it does not jump the Thursday gate.

**Competitive support — added 2026-09-14.** Every app in the scan treats consecutive days as the objective and bolts forgiveness on top — freezes, charges, shields, repairs. **No learning app ships a goal with tolerance built into its definition.** Finch is closest in spirit ("gentle consistency, not perfection," streak advancing on app-open, Pause Mode hiding goals *and* notifications) but is a wellness product. This is a second unowned position — and because every patch mechanic in the market fires at or after a break, Candidate 2 remains the only one of the two that can reach a pre-break week-1 user. See `../02-research/competitive-matrix.md`, Gap 2.

This also sharpens the argument against bundling: the two candidates target **two different unowned positions against two different failure modes** — post-break dormancy and pre-break anxiety. Shipping them together forfeits learning which position is worth occupying.

**Parked on the same terms as Candidate 1.** One strategic cost is worth naming plainly: bundling means Thursday faces a single larger tangible solution rather than two competing ones, which amplifies the design-anchoring risk rather than diluting it. A bundled candidate is also harder to park than a single one, because parking it reads as rejecting more work. Whether "alongside" is a design conviction or a hedge against not yet knowing which mechanic addresses the problem is worth deciding deliberately — if it is the hedge, that argues for the replay and sequencing, not for building both.

### Candidate 3 — Unforgiven daily streak + weekly consistency layer

*Designed by Trevor across several passes, 2026-09-14. Supersedes Candidate 2 and amends Candidate 1. The first candidate that **resolves** the forgiveness-devaluation risk rather than carrying it. Moved from a monthly to a weekly period on the same day — see the change log for why.*

**The core idea.** Stop forgiving the streak. Add a second, slower currency that measures *consistency* instead of *perfection*. Two ladders measuring two different things, so neither can dilute the other.

| Layer | Rule |
|---|---|
| **Daily streak** | Consecutive days. One miss resets it — **unless** a freeze is applied from the freeze bank below. Protection is never purchasable and never gifted; it can only be earned. |
| **Weekly goal** | Finish the week having missed **at most 1 day**, plus anything drawn from the bank. Weeks are **signup-anchored** — days 1–7, 8–14, and so on — so week 1 maps exactly onto the Day-7 window. |
| **Miss bank** | Unused weekly misses accumulate, **cap 3**, auto-applied. **New accounts start with a full bank of 3**, so week 1 has 4 misses available. Seed equals cap, so there is one number to explain rather than two: *you start fully protected and re-earn protection by showing up.* |
| **Week streak** | Consecutive weeks in which the weekly goal was met. |
| **Freeze bank** | One freeze earned per **perfect 4-week block** — signup-anchored, weeks 1–4, 5–8, and so on — with **zero misses**. Cap **7**, sized to absorb a week-long absence. **One freeze is granted at the start of each of the first 3 blocks** — days 1, 29 and 57 — *in addition* to anything earned. Three seeds total, then seeding stops. Auto-applied to protect the daily streak, with an explicit notification so a freeze is never spent silently. A freeze earned or seeded while at cap is simply lost. Three rules that matter: a freeze protects the **daily streak only**, so the day still counts as a miss against the weekly goal; **a frozen day does not count as perfect** for earning; and **no progress meter ships** for the perfect block — the rule is discoverable and the award is celebrated, but progress toward it is never displayed. |
| **Last-gasp save** | **Opt-in.** After failing a week, the user may commit to a **7-consecutive-day run**; success preserves the week streak. A failed attempt does **not** consume one. **Four per account year** (12 months from signup), available from the first week. |
| **Visibility** | Both layers visible from day 1. |

**User-facing framing.** Express the goal as an allowance rather than a completion count: *"miss up to 1 day a week,"* plus whatever is banked.

Because weeks are signup-anchored, **no partial weeks exist** — every week, for every user, is exactly seven days. That removes the proration problem that dogged the monthly version, along with the 27-in-January / 24-in-February variation. Every number in this layer is now constant for every user.

**What it resolves**

1. **Devaluation — substantially mitigated, not eliminated.** *Revised twice on 2026-09-14: once when the freeze bank was added, again when seeding was introduced.* The daily streak can now be protected, so it is no longer a pure count of consecutive days, and **three of the seven possible freezes are gifted rather than earned.** Two things keep the risk low anyway. **Protection is never purchasable** — beyond the three seeds it is earned only by 28 consecutive perfect days, which makes a freeze a *trophy for not failing* rather than a cushion against failing. And **the gifted freezes are confined to days 1–84, before any streak is impressive**: the 500-day user's *"I didn't deserve that"* objection concerns long streaks, and by then every freeze in play was earned. Gifted protection expires before streaks become meaningful.
2. **The horizon mismatch — resolved.** This limitation survived every earlier version. A monthly goal paid off ~30 days out while our north star is Day-7; **a weekly goal pays off on day 7**, so the first completion lands precisely inside the window we are trying to move. The dead-zone after a failure also shrinks from up to three weeks to at most six days.
3. **The attribution problem — collapses.** With no freeze there is no second mechanic to disentangle. The 2×2 factorial and the sequencing debate both disappear and this becomes a two-arm test. Raj's sizing problem gets far easier and the answer arrives far sooner.
4. **Upstream reach — retained.** Because the weekly layer is visible from day 1, a user like Amara sees *"miss up to 1 day a week"* before she breaks anything. That was the single property that made Candidate 2 interesting, and it survives.
5. **Recovery is earned, not granted.** A preserved week streak required seven perfect days. "I clawed that one back" is a better story than "I had a freeze," and it is why the second layer devalues nothing.
6. **Granted tolerance becomes earned savings.** A flat allowance says *"you may miss a day."* Banking says *"not missing accumulates flexibility."* That inverts the permission risk — attendance now **buys** something visible rather than merely avoiding a loss. It is the first mechanic here that rewards showing up instead of punishing absence.
7. **Clustered absence — covered, for users who have banked.** At cap 3 a consistent user holds up to 4 misses in a single week, which absorbs a travel or illness run. Tom's two consecutive days would have been comfortably covered, as would Raj's two-consecutive-misses pattern.

**The bet, stated as a bet.** Two independent sources asked for a freeze **by name** — Tom (*"a streak freeze feels forgiving"*) and NPS R6 (*"Other apps let you freeze a streak. Why not this one?"*). Eliminating it means betting that the month layer satisfies a need those users articulated in terms of the streak itself. Users name solutions rather than needs, so the bet is often right — but this is the most likely challenge on Thursday and it should be defended, not glossed.

**Open risks**

1. **Legibility is still the top risk, though it improved.** Five concepts remain — daily streak, weekly allowance, miss bank, week streak, last-gasp save — but every number is now constant and the proration formula is gone. **Progressive disclosure is a design constraint, not a hope:** a day-1 user should see the daily streak and *"miss up to 1 day a week"* and nothing else. The bank should surface only once it holds something; the save should not exist on screen until a week has been failed. Concept-test the day-1 view in isolation.
2. **Seeding at the cap creates a week-1-to-week-2 cliff.** Week 1 permits 4 misses; a user who spends all of them enters week 2 with 1 miss and nothing banked — **a four-fold tightening at exactly day 8**, and days 8–14 are still a live retention window. This is the front-loaded-slack problem first flagged against 26-of-30, resurfacing at the week boundary. Banking protects the already-consistent and drains fastest for the struggling, which is the inverse of where help is needed. Watch it in the data rather than assuming the seed is sufficient.
3. **The weekly goal may be close to unfailable in week 1.** Four permitted misses across seven days means a user needs only 3 completions to keep the week streak. For a week-1 retention problem that generosity is arguably the point — but a goal that cannot be failed carries no stakes, and the user learns in week 1 that this layer is trivial. Whether maximum early generosity or a legible early stake matters more is untested and genuinely arguable.
4. **Granted tolerance may still be consumed as permission.** Banking mitigates this — see *resolves* #6 — but does not remove it, and a weekly allowance restates the permission 52 times a year instead of 12. Needs a guardrail on days-active, not retention alone.
5. **Participation-trophy framing.** Both the weekly goal and the save can read as consolation for failing the real thing. A naming-and-copy problem, cheap to test on paper. Brilliant's framing is the model worth stealing: a streak charge as *"a chance to apply what you've learned or take a break"* — permission, not rescue.
6. **Every number here is an assumption.** One miss per week, bank cap 3, seed 3, a 7-day save run, 4 saves per year — none is derived from our data. The counterfactual replay should *set* them, not confirm them. **The cap is now the single most consequential number**: because seed equals cap, it fixes both the level of week-1 protection and the size of the day-8 cliff at once.
7. **Signup-anchored weeks don't align across users.** *The "what is a week" question was surfaced and resolved on 2026-09-14 — signup-anchored, days 1–7, 8–14, so week 1 maps onto the Day-7 window and no partial weeks exist.* The residual constraint: because no two users share a week boundary, **any future weekly social feature is blocked** — leaderboards or leagues of the kind Elevate and Brilliant both shipped recently can't rank users over a common week. Not a problem today, and worth the trade for metric alignment. Worth remembering before someone proposes leagues.
8. **The earn rate still binds, but far less than before.** *Revised 2026-09-14 when seeding was added.* A perfect user now reaches the cap on **day 113** rather than day 196, and because every user holds a freeze from day 1 the feature is no longer near-invisible or dead UI. Past day 84 the original constraint returns in full: a single miss disqualifies the entire 4-week block it falls in, so a user who never assembles 28 consecutive perfect days accumulates nothing further, ever.
9. **~~Progress meter~~ — decided 2026-09-14: no progress meter ships.** A visible "day 19 of 28" counter would have been a second streak with a *harsher* reset — miss on day 27 and lose 27 days of progress — recreating streak-reset-as-punishment at four-week scale inside the feature meant to soften it. **The distinction to hold in design:** don't show *progress*, do make the *rule* discoverable and *celebrate the award*. A surprise reward is motivationally better than a loss-shaped progress bar, and the award moment doubles as a genuine acknowledgment around day 28 — close to where our retained user's first celebration landed.
10. **The two layers disagree about whether a holiday was acceptable.** A user with 7 freezes takes a week off: the daily streak survives, but the weekly goal records 7 misses against roughly 4 available, so the **week streak breaks anyway** and needs a last-gasp save. One layer says the absence was fine, the other says it wasn't. Coherent on paper, likely confusing in the product.
11. **Three seeds buy three buffer days across 12 weeks — they do not remove the cliff.** *Revised 2026-09-14 from a single seed.* A week-1 user holds 1 freeze plus 4 weekly misses, so their **first** missed day costs nothing visible: the daily streak is frozen and the weekly goal absorbs the miss. That directly answers the evidenced week-1 fear of losing *"everything I've built."* But the **second** miss inside a block still resets the daily streak in full. Intentional — the daily streak is the perfection counter — and worth stating precisely so the seeds aren't credited with more than they do.
12. **The droughts are shorter, but a new cliff appears at day 85.** Burning a seed on day 3 also breaks block 1's perfection, leaving ~26 days unprotected until the block-2 seed lands on day 29 — better than the ~53-day gap a single seed produced, and there are now three separate chances. **The new problem is what happens when seeding stops.** A user who has not assembled 28 perfect days by day 84 drops to **zero protection, permanently**, until they do. The training wheels come off on a fixed date rather than when the habit is actually formed — and the users still struggling at week 12 are precisely the ones who lose them.

**Approved 2026-09-16; release gated on Query 1.** Worth recording plainly: the risk named in `../CLAUDE.md` did materialise. The most tangible thing in the room attracted commitment while the problem underneath stayed unvalidated. The gate is the safeguard accepted in exchange, which makes running Query 1 — and honouring its answer — the thing that determines whether the approval was sound.

Nothing here establishes that v2 caused the decline, and all twelve risks above remain live.

### Not a candidate — table-stakes gaps surfaced by the scan

*Added 2026-09-14. Recorded separately because these are places we are **behind the field**, not positions we could lead. At least one may deserve to become a candidate.*

1. **We have no forgiveness mechanic at all.** Five of five direct competitors ship one. The only app in the scan that resets on a first miss is Lumosity — included as the do-nothing control case. **Reframed 2026-09-14:** under Candidate 3 this stops being a gap and becomes a *deliberate position*. We decline to forgive the streak and answer the same user need with a second currency instead. That is defensible differentiation rather than a shortfall — but only if the second currency actually works, which is the bet Candidate 3 names.
2. **Our first celebration appears to land around day 30.** Elevate's lands on **day 3**. Duolingo measured milestone animations at **+1.7%** on 7-day return. Our only retained-user interview puts her first acknowledgment at day 30 — three weeks after the Day-7 window closes.
3. **Re-arming protection is cheap everywhere else.** Elevate restores two freezes for a 2-day streak; Brilliant earns a charge passively, one per lesson. **Moot as of 2026-09-14** — with no protection to re-arm, the comparison no longer applies to us.

**Item 2 was adopted as a fast track on 2026-09-14** (Trevor's call) — see below. Item 1 is now a deliberate position rather than a gap; item 3 is moot.

## Cross-cutting risk — forgiveness may hollow out the streak

*Added 2026-09-14. Surfaced by external user-voice research (Hacker News, Clozemaster — Reddit was inaccessible from our tooling). It appears in **none** of our internal sources.*

Every intervention on this page adds tolerance — a freeze, a repair, a quota, a pre-granted miss. External user voice suggests tolerance carries a cost the internal research never surfaced.

A user with a 500-day Duolingo streak: *"A streak freeze devalues impressive streaks, and the discipline it took to get there… I didn't deserve that 500 day streak. A streak on Duolingo isn't worth much."* Others describe gaming it rather than learning — *"anybody with a high streak just turns the app on and runs the first lesson to keep it going"* — including one who memorised answer patterns to click through without reading.

**Why this is load-bearing and not a curiosity.** It converts our central tension from a trade-off into a possible trap. The interview set already shows that the mechanic retaining Priya is the one that expelled Tom. This risk goes further: the fix for Tom may not merely cost Priya's stakes, it may stop the streak functioning as evidence of anything for anyone. Our own NPS line — *"The streak is the only thing keeping me engaged"* — is what would be at risk.

**What it does not say.** It does not say forgiveness is wrong. Five of five competitors ship it and their businesses are intact.

**The reason it may not apply to our actual problem.** The users quoted are extreme-streak holders on a mature product — the population most invested in a streak meaning something, and the opposite end of the lifecycle from week 1. **A week-1 user holds nothing worth devaluing.** So this risk may bear on long-term engagement and on Priya-type retention while being close to irrelevant to Day-7. That distinction is untested and should not be assumed in either direction.

**How to act on it.** Treat "does the streak still mean something" as a guardrail rather than an afterthought. The A/B guardrails in `../05-decide/experiment-26of30.md` already include a habit-strength proxy; this argues for adding a perceived-value measure, and for watching whether protected users *complete* lessons or merely click through them.

**Substantially mitigated by Candidate 3 — revised 2026-09-14.** An earlier version of C3 eliminated the freeze outright, which resolved this risk completely. A freeze was then reintroduced in an **earned** form: one per 28 consecutive perfect days, capped at 7, never purchasable and never gifted. That does not resolve the risk, but it defuses most of it — every freeze represents four weeks of demonstrated perfection rather than a payment or a gift, so the "I didn't deserve this" objection loses its force. Residual exposure is real but small, held down by an earn rate that means almost no user accumulates meaningful protection.

**The line to defend — restated 2026-09-14 when seeding was introduced.** The original line was "never bought, never gifted." Seeding three freezes across the first 12 weeks crossed it, so the line is restated on a firmer basis: **protection must never be purchasable, and gifted protection must stay confined to the habit-formation window.** What brings the risk back in full is a freeze that is *bought*, or *gifted to an established user* — because that is what lets a long, impressive streak rest on something unearned. The 12-week window is evidence-aligned rather than arbitrary: our retained user put habit formation at roughly three weeks, so the training wheels comfortably outlast it.

This section stays as the argument any future proposal has to answer.

**Confidence: directional, external, single-platform, opposite-cohort.** Not established for week-1 users.

## Fast tracks — separable from the causality question

Two items run ahead of the Thursday gate. Both qualify on the same test: **cheap, evidence-backed, and independent of whether v2 caused the decline.** Neither presumes either candidate, and neither substitutes for problem validation.

### Fast track 1 — Notification quality

Tone, timing and volume. One NPS respondent received three notifications in an afternoon and disabled all of them — which also costs us our primary re-engagement channel. Reads as a defect rather than a design debate. One of our three interview subjects named the notification specifically.

**Unassigned.** Logged in `change_log.md` pending items.

### Fast track 2 — An acknowledgment moment inside week 1

*Adopted 2026-09-14 (Trevor).*

**The gap.** Elevate's first milestone celebration lands on **day 3** (verified). Duolingo measured milestone animations at **+1.7%** on 7-day return (verified). Our own evidence points to day 30 — three weeks past the window we are trying to fix.

**Step 0, before anything else: establish what our current milestone schedule actually is.** The "day 30" figure is an **inference from a single interview**, and a loose one. Priya said the 30-day celebration was what made the habit stick; she did *not* say nothing preceded it. We have been reasoning from one user's recollection about a schedule that is a matter of record. Raj or Lena can settle it in minutes, and the answer could dissolve this item or sharpen it considerably. **Do not scope work before this is answered.**

**Why it qualifies as a fast track.** Independent of v2 causality. Independent of both candidates. Requires no new surface, no change to streak accounting, and no resolution of the freeze rules. And unlike the 26-of-30 mechanic — which does not resolve until day 30 — an early milestone sits *inside* the Day-7 measurement window.

**The risk worth naming.** Adding celebration without addressing the reset means congratulating a user on day 3 and zeroing them on day 4. That could read as tone-deaf rather than encouraging, and it compounds the punishment framing Lena documented. This is cheap to build and cheap to get wrong, so sequencing against the reset question matters.

**Unassigned.** Owner and target date needed Thursday.

## Open strategic questions

- What is the recovery target, and by when? Nothing has been set.
- Is recovering 48% the goal, or is 48% itself no longer the right benchmark post-v2?
- What is the cost of the retention leak in acquisition spend? Quantifying this would tell us how much rigor we can afford to buy.
- Does the drift path come into scope, or do we deliberately narrow to break-triggered churn and say so out loud? *(Opened 2026-09-14.)*
- How do we get week-1-segmented evidence before committing to anything? Every source we hold — dashboard aside — is stage-mixed. *(Opened 2026-09-14.)*
- Does notification quality split off as a cheap, separable track that doesn't wait on causality? *(Opened 2026-09-14; see `change_log.md` pending items.)*
