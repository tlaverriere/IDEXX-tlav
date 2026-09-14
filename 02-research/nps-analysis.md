# NPS Verbatim Analysis — Streak Mechanic

**For:** Marcus · **From:** Trevor · **Date:** 2026-09-14
**Source:** 10 open-text NPS responses · **Confidence: directional only — see Limits**

---

## Bottom Line

Ten verbatims, and the complaint is unusually concentrated: **the single most-mentioned issue is the absence of a way back after a break (4 of 10)**, followed by **streak loss stated as the direct cause of abandonment (3 of 10)**. Three respondents describe deleting or ceasing to open the app, and in all three the trigger named is the reset itself.

Every piece of praise in the set is attached to a complaint. There is not one unqualified positive. The praise is consistently about **content**; the complaints are consistently about the **streak mechanic**. That split is the most useful thing in this data — it argues against spending on lessons and for spending on the mechanic.

One finding cuts against our current framing: **two respondents churned by drifting, not by breaking a streak.** One says plainly they "forget it exists." A break-triggered intervention cannot reach them.

---

## 1. Themes Mentioned More Than Once, Ranked by Frequency

| # | Theme | Count | Respondents |
|---|-------|:-----:|-------------|
| 1 | **No way back after a break** — wants recovery, freeze, or a pull-back | **4 / 10** | R3, R5, R6, R8 |
| 2 | **Streak loss → abandonment** — explicitly stopped using after the reset | **3 / 10** | R1, R9, R10 |
| 3 | **Praise** (all qualified — see §2) | **3 / 10** | R2, R5, R10 |
| 4 | **Notifications feel bad** — nagging, random, over-frequent | **2 / 10** | R2, R4 |
| 5 | **Reset reads as punishment or personal failure** | **2 / 10** | R3, R8 |
| 6 | **No acknowledgment of user state** — same UI regardless of where you are | **2 / 10** | R3, R7 |
| 7 | **Passive drift** — faded out without breaking a streak | **2 / 10** | R2, R5 |

**Counting note:** comments carry multiple themes, so counts sum above 10. R3 alone carries three (recovery, punishment, state awareness). Mentioned once and therefore excluded from the ranking: the explicit competitor benchmark (R6, "Other apps let you freeze a streak"), and notification *volume* as a distinct defect (R4, "three in one afternoon").

---

## 2. Praise vs. Complaints

### Praise — 3 mentions, none unqualified

| Respondent | What they praised | The attached complaint |
|---|---|---|
| R2 | "The first week was genuinely fun" | "After that the daily reminder just started to feel like nagging" |
| R5 | "Love the lessons" | "I just forget it exists after a couple of days" |
| R10 | "The streak is the only thing keeping me engaged" | "but the second I lost it, I was done" |

**Read:** the product earns real affection for its lessons and its first-week experience. R10 is the most double-edged line in the set — it confirms the streak is doing the engagement work *and* that it is a single point of failure.

### Complaints — grouped

- **Recovery absent (4):** no way to restore, no freeze, no pull-back, no easier return.
- **Reset causes exit (3):** "haven't opened the app since" / "Deleted after 3 weeks" / "I was done."
- **Notification quality (2):** tone reads as nagging; timing and volume read as random.
- **Emotional framing (2):** "punishes me," "feel like I failed."
- **No state awareness (2):** home screen identical at 2-day streak and after two weeks away.
- **Drift (2):** interest decayed or the app was simply forgotten — no break involved.

---

## 3. Top 3 Actionable Issues

Ranked on frequency **and** on how cheaply we can act without waiting on the open problem-validation question.

### 1. No recovery path after a break — 4 mentions, highest frequency

Most-cited issue in the set, and the first corroboration we have for it beyond a single interview. R6 names the competitive gap directly: *"Other apps let you freeze a streak. Why not this one?"*

**Important:** this raises confidence in the **problem**, not in any particular **solution**. It does not settle whether the Comeback screen is the right build — that decision remains open and yours.

### 2. Notification tone, timing, and volume — 2 mentions, but the cheapest fix here

R4's "three in one afternoon and just turned them all off" reads as a defect, not a design debate. This is the one item on the list that is **independent of the streak question entirely** — it can be investigated and fixed without resolving causality on the v2 redesign. Turning off notifications also removes our main re-engagement channel, so the cost of leaving it is compounding.

**Recommend treating this as a separable fast track.**

### 3. Home screen does not acknowledge user state — 2 mentions

R7 is the most precise piece of feedback in the whole set: *"The home screen looks the same whether I'm on a 2-day streak or coming back after two weeks away. Nothing acknowledges where I am."* That is a specific, observable, checkable defect. It overlaps with the Comeback concept but is broader — it applies to users who never broke a streak at all.

---

## 4. Limits — What This Data Cannot Support

Read these before quoting any number above.

1. **No NPS scores were included.** Despite the label, this set is verbatims only. I cannot compute NPS, split promoters from detractors, or trend anything.
2. **n=10, and frequency gaps are tiny.** The difference between the #1 theme and the #4 theme is two comments. Rank order here is a rough signal, not a measurement. Do not present "4 of 10" as a rate.
3. **Open-text NPS self-selects for strong feeling.** Users who churned angrily are overrepresented relative to users who quietly drifted. Prevalence cannot be inferred.
4. **No cohort or lifecycle data.** Respondents reference a 20-day streak, three weeks, a couple of days — clearly a mix of stages, but unlabeled. **This set therefore cannot speak to Day-7 retention specifically,** because I cannot identify which respondents were in week 1.
5. **Themes were coded by me from unstructured text.** A second coder would draw some boundaries differently, particularly between "punishment framing" and "no recovery path."

---

## 5. What Changed in Our Evidence Picture

- **Upgraded:** "no way back after a break" was single-source (one interview) in [interview-synthesis.md](interview-synthesis.md). It is now the most-mentioned theme across an independent set of 10. Still directional, but no longer one person's story.
- **Corroborated:** the drift path — churn without a streak break — appeared in the interviews (a day-4 user disengaging with her streak intact) and appears again here in two respondents. This is now a second, distinct churn mechanism that a break-triggered fix would not address.
- **Unchanged:** nothing here establishes that the v2 redesign *caused* the Day-7 decline. No respondent references the redesign. Correlation in time remains the only basis for that claim.

---

## 6. Decisions Needed

1. **Does notification quality get split off as a separate fast track?** It is cheap, self-contained, and does not require the causality question to be settled first. My recommendation: yes.
2. **Does the drift path get scoped into the problem statement?** Two independent sources now show churn without a break. If the problem statement stays reset-only, we are knowingly excluding a population we have evidence for.
3. **Do we need week-1-labeled feedback before Thursday?** Everything we have — interviews and this set — is stage-mixed. Our core metric is Day-7, and no current evidence is segmented to week 1. This is the largest hole in the problem write-up.

**Not resolved by this analysis, and not mine to resolve:** whether the Comeback screen gets built.
