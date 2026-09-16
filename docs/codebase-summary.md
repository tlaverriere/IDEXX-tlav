# Codebase Study — Habitica

*2026-09-16 · Trevor Laverriere*
**Repo:** [HabitRPG/habitica](https://github.com/HabitRPG/habitica) · branch `develop` (not `main`) · commit `8b664b7`, 2026-09-15

> **Framing, before anything else.** This is **not our codebase.** Habitica is the closest open-source analogue to Streakly, so this is a reference study — what a real production habit app does about streaks, and what that tells us to ask our own engineers. **The transferable output is the questions in §3, not the file paths.**
>
> Two constraints on the repo itself: its README states code contributions are **paused** as of a 2026 policy change and AI-generated code is prohibited, and the licence is non-standard (GitHub reports NOASSERTION). **Read it, don't lift from it.**

---

# 1 · PM-level tour

### What it does, in one sentence

From the README: *"an open-source habit-building program that treats your life like a role-playing game. Level up as you succeed, lose HP as you fail, and earn Gold to buy weapons and armor."*

### How it's organized

| Path | What's in it |
|---|---|
| `website/server/` | Node/Express API. Mongoose models, controllers split by API version (`api-v3/`, `api-v4/`), and `libs/` where the heavy logic lives |
| `website/common/` | **Shared client *and* server logic** — note it's called `common`, not `shared`. Holds `script/constants.js`, `script/content/`, `script/ops/`, `script/cron.js` |
| `website/client/` | Separate npm package. **Vue 2.7 + Vite 6**, 348 `.vue` files |
| `test/` | 437 files across unit, integration and content tests |
| `migrations/` | 259 one-off DB migration scripts — a signal about how schema change actually happens here |
| `gulp/` | Build orchestration. No monorepo tool; two `package.json` files stitched together with gulp |

**Stack:** Node 20, Express 4, **Mongoose 8 / MongoDB**, ioredis + bullmq for queues, Stripe + PayPal. 3,974 tracked files, of which 1,384 are locale files — so the real code surface is smaller than the file count suggests.

### The three files a PM should know

**1 · `website/common/script/content/`** — the entire content and economy layer, written as **executable JS modules rather than static data**. Quests, spells, gear, achievements, `loginIncentives.js`, `constants/schedule.js`. Every reward rung and release date is diffable in version control.

*Why you care:* `loginIncentives.js` is the closest thing in the repo to a daily check-in reward ladder — keyed by consecutive check-in count, with an `assignReward(user)` per rung and a `MAX_INCENTIVES` cap. It's the shape our Fast track 2 milestone work would take.

**2 · `website/common/script/ops/scoreTask.js`** (447 lines) — the core task-scoring rule, and **where streaks actually live**. `task.streak += 1` on completion, the 21-day achievement at `task.streak % 21 === 0`, and the reset itself at **line 310**.

*Why you care:* one file, one product rule. The sibling `ops/` files follow the same pattern — `rebirth.js`, `reset.js`, `revive.js`. If you want to know what a rule does, there's one place to look.

**3 · `website/server/libs/cron.js`** (516 lines) — the day-rollover. Missed dailies take damage, login incentives increment, the Perfect Day achievement is awarded, all buffs wipe.

*Why you care:* it also holds `CRON_SAFE_MODE` and `CRON_SEMI_SAFE_MODE` — global kill switches for punishment mechanics. Someone decided they needed the ability to turn off consequences for everyone at once. That's a product decision encoded as a flag, and it's the kind of thing we should want.

### What the data models tell us about product decisions

**Tasks are one collection with a discriminator on type** — `habit`, `daily`, `todo`, `reward` (`website/server/models/task.js:20`).

**`streak` exists only on the daily discriminator** (`models/task.js:404`, default `0`). Habits carry `counterUp`/`counterDown` instead.

**The decision that matters most for us: Habitica has no user-level streak at all.** A streak belongs to a *task*. A user with twelve dailies has twelve independent streaks. **Streakly's entire design assumes one global streak per user** — that is a fundamentally different model, and it is the difference between "did you do your lesson today" and "did you do each of your habits today."

**History is deliberately untyped and lossy.** `models/task.js:351` declares `history: Array` with the comment *"Schema for history not defined because it causes serious perf problems."* And `website/server/libs/preening.js` compresses it: daily entries for 60 days (365 for subscribers), then monthly, then yearly — and `_aggregate()` emits only `{date, value}`, **dropping `completed` and `isDue`.** A real production app chose performance over recoverable history. We will face the same trade.

---

# 2 · Mapping the Comeback screen onto this structure

### Where the trigger would have to go

**The streak resets in exactly one place:** `website/common/script/ops/scoreTask.js:305-310`.

```js
} else if (task.type === 'daily') {
    if (cron) {
      delta += _changeTaskValue(user, task, direction, times, cron);
      _subtractPoints(user, task, stats, delta);
      // Chilling frost should not affect challenge or group dailies
      if (!user.stats.buffs.streaks || task.challenge.id || task.group.id) task.streak = 0;
```

**Three things about that line are spec-relevant:**

1. **It is not in `cron.js`.** The reset is a *side effect of the damage function*, reached from the rollover through `common.ops.scoreTask`. Two files, two packages, and **no dedicated "break streak" function anywhere.**
2. **It lives in `common/`** — shared with the client. Adding a server-only notification there is awkward; `scoreTask` already has to guard with `if (user.addNotification)`.
3. **It has no test coverage.** Grepping `.streak` in `test/api/unit/libs/cron.test.js` (1,994 lines) returns **zero matches.** No test asserts `task.streak === 0` after cron. The damage and buff paths around it are heavily tested; the reset line is not.

**The better insertion point** is the dailies loop in `website/server/libs/cron.js:222-308`, where you have the user object and `user.addNotification()` is available.

### What it would touch

| Component | Path | Why |
|---|---|---|
| Task streak | `models/task.js:404` | The value being read and zeroed |
| Frost shield | `user.stats.buffs.streaks` (`user/schema.js:697`) | The existing exception to the reset |
| Sleep / pause | `user.preferences.sleep` (`user/schema.js:572`) | Skips the whole `scoreTask` call |
| In-app notifications | `models/userNotification.js` + `models/user/methods.js:203` | Embedded array on the user, ~90 type enum |
| Push | `models/pushDevice.js` + `libs/pushNotifications.js` | APNs + FCM |
| Task history | `task.history` + `libs/preening.js` | Only source for a "best ever" — and it's lossy |
| The rollover transaction | `cronWrapper` (`libs/cron.js:420`) | Everything saves in **one** Mongo transaction |

### Blast radius — this is the section to read twice

The streak reset sits **inside the damage function, inside the day-rollover loop.** In that same loop:

- **HP loss**, which can kill the avatar and trigger the death mechanic
- **Boss damage accumulated to the party quest** — `user.party.quest.progress.down += delta * priority` (`cron.js:275`). **This writes to data shared with other users.**
- `perfect = false`, which gates the Perfect Day achievement
- Task value decay, checklist mana docking, `task.completed = false`, `isDue`/`nextDue` recompute

And elsewhere in the same `cron()` call: login-incentive rewards and their notification, subscription perks, item-drop caps, todo decay, habit counter resets, **a full `stats.buffs` wipe**, MP regen, history preening, and a `UserHistory` write.

**Three failure modes a bug here produces:**

1. **It rolls back the user's entire day.** Everything is saved in one Mongo transaction in `cronWrapper`. A throw from a Comeback hook doesn't break the Comeback screen — it aborts the whole rollover.
2. **It corrupts other users' data.** The party-quest write means a bug in a per-user feature propagates to a shared group document.
3. **It jams the lock.** `checkForActiveCron` (`cron.js:392`) sets a 5-minute `CRON_TIMEOUT_WAIT` lock and throws `CRON_ALREADY_RUNNING`. A slow hook blocks the user's rollover entirely.

**And there is no existing event to hook.** `userNotification.js:43` has `STREAK_ACHIEVEMENT` — the 21-day *award* — with **no inverse.** No webhook fires on the reset line. Habitica never tells a user they lost a streak; they find out because the task card shows 0.

---

# 3 · What this changes about how I write the spec

### Data that does not exist yet

**1 · Best-ever streak. Does not exist, anywhere.**
Repo-wide grep for `bestStreak|maxStreak|longestStreak|highestStreak|streakRecord` returns **zero hits.** Habitica stores only the current `streak` and zeroes it in place — the prior value is not copied anywhere first.

And it **cannot be reliably derived.** Preening drops `completed` and `isDue`, and past the retention window the data needed to recompute a streak is gone.

> **Spec line:** best-ever streak must be a **new stored field, written at reset time, before the reset.** Deriving it from history is not an option. This is the single most important thing in this document, because the Comeback screen's headline stat is the one thing that cannot be computed after the fact.

**2 · Weekly streak. Does not exist.**
No week-goal concept anywhere in the repo. Habitica dailies have `frequency: 'weekly'`, but that is **scheduling** — which days a task is due — not a weekly completion goal. Our week streak, miss bank and spare days are all new storage.

**3 · A freeze as a countable resource. Does not exist.**
Two protections exist and **neither is a bank:**
- `user.stats.buffs.streaks` — a **boolean**, set only by the Mage spell Chilling Frost (`content/spells.js:103-114`), and **cleared unconditionally every cron**. A one-day shield, not a stored count.
- `user.preferences.sleep` — an **indefinite mode** the user toggles. Skips damage and the reset, but not habit counters, not `completed = false`, not login incentives.

> Our freeze bank — cap 7, seeded 3, earned per perfect 4-week block — has no analogue here. All of it is new.

**4 · A streak-broken notification type. Does not exist.** And there is **no opt-out preference for one** — `preferences.pushNotifications` and `preferences.emailNotifications` (`user/schema.js:593-629`) contain no streak or cron key. If we ship a streak notification, the opt-out is new too.

### Constraints to call out in the ticket

- **Per-task versus per-user streaks.** Habitica's streak belongs to a task. If our engineers reach for a per-task model, we get a different product. **State explicitly in the ticket that Streakly's streak is per-user.**
- **The day boundary is negotiated, not decided.** Habitica reconciles three timezone sources — `preferences.timezoneOffset`, `timezoneOffsetAtLastCron`, and an `x-user-timezoneoffset` header — plus a user-configurable `preferences.dayStart` (0–23). Our signup-anchored weeks inherit every bit of this complexity.
- **History will be lossy.** A production app with this exact problem chose performance and compressed it away, with an explicit code comment saying the alternative caused *"serious perf problems."* Anything we want to show later, we store now.
- **Users can write their own streak.** `streak` is absent from the model's `noSet` list and `PUT /tasks/:taskId` accepts it (`controllers/api-v3/tasks.js:673-674`). Worth a decision: is our streak server-authoritative or not?
- **The reset path may be untested.** Theirs appears to be. Ask what ours looks like before anyone touches it.

### The one thing engineers will ask — answer it before kickoff

> **"What runs at the moment a streak is at risk, and when exactly does a day end?"**

This is the question, and our spec does not currently answer it.

Habitica has **no scheduler for day rollover.** There is no OS cron, no worker. `cronWrapper` has exactly one caller — `POST /api/v3/cron` — and **the client decides when to call it**, on the first request of a new day, gated behind a "Record Yesterday's Activity" prompt.

Everything that happens at a day boundary happens **because the user showed up.**

**That is fatal to our pre-emptive trigger as currently designed.** We specified a prompt that fires *on the last day a streak can still be saved* — which requires something server-side to evaluate at-risk users and reach out to them *before* they open the app. If Streakly's architecture resembles Habitica's, **nothing exists to fire it.** The post-break state works fine on a show-up-and-evaluate model. The pre-emptive state needs a scheduled job that does not exist.

**So answer this before kickoff:** do we have a scheduled evaluator, or does our streak state only update when the user appears? If it's the latter, the pre-emptive trigger is infrastructure work, not a screen — and that changes its cost by an order of magnitude.

---

## What I'd take from this into our own design

| Habitica does | Worth copying? |
|---|---|
| `CRON_SAFE_MODE` — a global switch to disable punishment mechanics | **Yes.** We are shipping a punishment mechanic we are not sure about. A kill switch is cheap now and expensive later |
| Content and rewards as diffable code modules, not config | **Yes.** `loginIncentives.js` is the shape Fast track 2 should take |
| Streak protection as an *earned gameplay reward* (a Mage spell) | **Already converged.** Our earned-only freeze arrived at the same principle independently |
| Never telling users they lost a streak | **No — but note they made that choice.** The absence of a streak-broken notification in a mature habit app is itself a data point about whether ours should exist |
| Per-task streaks | **No.** Wrong model for a one-lesson-a-day product |
