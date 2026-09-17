# weekly-status

**The skill lives at [`weekly-status/SKILL.md`](./weekly-status/SKILL.md).**

A skill needs its own directory and a `SKILL.md` with YAML frontmatter to be discovered and invoked. This file is a pointer so the path stays findable — edit the real file, not this one.

**What it does:** turns raw bullet-point notes into a weekly update, calibrated to its audience. Two formats:

- **Format A — leadership, for Marcus.** Shipped / In Progress / Blockers / Next Week, three bullets maximum each, one page, with the ask in a Slack covering line.
- **Format B — squad, for Raj and Lena.** A shared state line, then a block each: Raj gets file paths, scope consequences and rollback; Lena gets the artifact to open and an honest evidence label. No bullet cap — the squad needs completeness, not brevity.

Asked for a weekly update with no audience named, it writes both.

**When to use it:** any time you have rough weekly notes and need something Marcus can read in ninety seconds, or something the squad can act on.

**Before it writes anything** it runs a pre-flight check against the repo, because raw notes carry half-remembered items. It catches three things: work that never happened, roleplay reported as user research, and items understated in the notes. All three have occurred.
