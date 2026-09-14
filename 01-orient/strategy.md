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

Lena's research supports steps 3–5 as lived experience: users describe the reset as punishment and perceive no route back in.

**The strategic implication, if the hypothesis holds:** the fix is not more motivation. It is giving users a reason to return that is specific to them and their own progress. Generic encouragement is the thing that has already failed.

## Confidence in the hypothesis

| Claim | Confidence | Source |
|-------|-----------|--------|
| Day-7 is 39% against a 48% baseline | **Verified** | Retention dashboard |
| Users experience the streak reset as punitive, with no re-entry path | **Documented, qualitative** | Lena's research write-up |
| Two consecutive missed days → ~2x churn | **Directional only** | Raj, one evening of analysis. Unreviewed. Our most persuasive number and our least tested. |
| The v2 redesign caused the decline | **Not established** | Correlation in time only. Confounds unexamined. |

The hypothesis is built on the two weakest rows in that table. That is the honest strategic position, and it is why discovery comes before design.

## What has to be true for this strategy to hold

**1. v2 caused it.** If something else shipped in that window, or acquisition mix shifted, or the effect is seasonal, the entire frame is wrong and we would be fixing a symptom of a different disease.

**2. The week-1 streak break is the intervention point.** This rests entirely on Raj's unvalidated figure. If the churn concentration doesn't hold, we have a broad retention problem and this strategy is too narrow to address it.

**3. The post-break experience matters more than notification timing.** Raj's instinct is "both, with post-break mattering more." Unresolved. These imply different owners and very different cost profiles — a notification tone-and-timing fix is far cheaper than a new surface.

## Candidate intervention — parked

Lena's **Comeback screen**: shown when a streak breaks, replacing the cold reset with the user's best-streak stat, one 60-second comeback lesson to rebuild momentum, and a one-tap streak freeze to protect the rebuilt streak. Raj confirms it is buildable with existing data sources; targeting logic and freeze rules are unbuilt.

Parked on purpose, for two reasons. It addresses only the post-break half of the problem, which condition 3 has not resolved. And it presumes the causal story in condition 1, which is unverified.

It loses nothing by waiting for Thursday.

## Open strategic questions

- What is the recovery target, and by when? Nothing has been set.
- Is recovering 48% the goal, or is 48% itself no longer the right benchmark post-v2?
- What is the cost of the retention leak in acquisition spend? Quantifying this would tell us how much rigor we can afford to buy.
