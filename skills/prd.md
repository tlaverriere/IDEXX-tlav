# prd

**The skill lives at [`prd/SKILL.md`](./prd/SKILL.md).**

A skill needs its own directory and a `SKILL.md` with YAML frontmatter to be discovered and invoked. This file is a pointer so the path stays findable — edit the real file, not this one.

**What it does:** writes a one-page PRD for the squad — Problem Statement, User, Goals, Non-Goals, Success Metrics, User Stories, Open Questions — with every claim attributed to a research file and every open question assigned to the person who has to answer it.

**When to use it:** any time a feature needs writing up for Raj and Lena rather than for leadership. Use `weekly-status` for the leadership update instead.

**What makes it different from a generic PRD template:** it reads the research files before writing and refuses to assert anything it cannot cite; non-goals must say where the excluded work lives; success metrics get checked against whether the feature actually owns them; acceptance criteria name the things that do not exist yet; and it closes by stating plainly what has never been tested.
