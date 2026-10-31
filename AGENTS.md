# Repository Instructions

This repository maintains shared skills for Cursor, Codex, Claude Code, OpenCode,
and Copilot. These instructions apply to work in this repository; they are not automatically installed elsewhere.

- Keep canonical content in `skills/<name>/SKILL.md` and supporting resources in
  that skill's folder. Host discovery links point to this shared source.
- Read `skills/anti-ai-writing/SKILL.md` before human-facing text. Use
  `skills/using-skills/SKILL.md` to select relevant workflows when routing is needed.
  Read the selected skill; do not treat its description as the complete procedure.
- Keep changes scoped and preserve unrelated work. Update affected relative links
  when names or responsibilities change. Do not add personal-only dependencies.
- For accepted plan implementation, use `skills/implement-plan/SKILL.md` to coordinate
  verification and final independent review. Planning remains planning-only; unavailable
  independent review must be reported incomplete rather than replaced by self-review.
- When editing README installation guidance, include every supported installer flavor
  from the maintained installer definitions. Give each flavor a clearly labeled,
  collapsible section containing complete install, activation/verification, and
  update instructions, including supported Bash and PowerShell variants. Keep shared
  prerequisites and flavor navigation visible. Verify commands against the installer;
  preserve customization/conflict guidance and do not substitute one host's example
  or a link for another flavor's required steps. Use generic examples outside the
  flavor-specific instructions and do not privilege a particular editor or agent.
- Preserve the Jira writing reference's tested ADF contracts and examples unless
  a specific formatting change is requested and validated.
- Check frontmatter, local links, and whitespace for changed packages. Distinguish
  structural validation from actual host behavioral evidence.
- For tooling changes, run `go test -race ./...`, `go vet ./...`, and
  `go run ./cmd/skillpack`; build all five host packages into new scratch directories.
  Keep portable, Cursor, and Claude manifest identities/versions aligned.
  Do not ship the repository discovery symlink, repo instructions, or credentials in host packages.
- Do not load every skill, force a lifecycle, or delegate solely because a skill
  mentions another skill. Avoid duplicate instructions and unnecessary approval rituals.
- Commit, push, publish, contact others, or change live systems only within explicit
  authorization. Preserve existing authorization and exact-draft publication gates.
- Never dismiss GitHub reviews or approvals, including stale reviews, or enable
  automatic dismissal in repository settings or automation. Use authorized re-review
  requests instead and preserve review history.
