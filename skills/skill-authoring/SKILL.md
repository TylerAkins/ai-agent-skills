---
name: skill-authoring
description: >-
  Design, author, evaluate, or package agent skills using the destination's
  conventions and validation requirements. Use when creating or revising a skill,
  checking its activation triggers, or preparing a skill package.
---

# Skill Authoring

## Scope and authority

Use this skill to design, author, revise, evaluate, or package agent skills and their
supporting resources. Use [agent-planning](../agent-planning/SKILL.md) for engineering
plans, [test-authoring](../test-authoring/SKILL.md) for behavioral tests, and
[writing-clean-simple-code](../writing-clean-simple-code/SKILL.md) for production
code. Those requests do not trigger skill authoring unless the requested artifact is
a skill. Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting.

Preserve user authorization and unrelated work. Drafting and packaging do not
authorize commits, live-host installation, remote publication, or repository-policy
changes. Resolve missing intent only when it blocks dependent authoring; continue
settled work.

## Author a skill

1. Define one responsibility, observable output, activation requests, exclusions,
   and acceptance criteria. Inspect neighboring skills and destination tooling so
   the new workflow does not duplicate an existing one.
2. Identify destination registration requirements before drafting. For additions
   or renames here, update the README browse table and
   [using-skills](../using-skills/SKILL.md) routing table in the same change,
   including counts and affected links. Elsewhere, update existing required
   inventories. Do not create a README, router, or tooling only to imitate this repo.
3. Keep activation boundaries, authority, operational actions, and exit gates in
   `SKILL.md`. Put domain schemas, templates, and exhaustive checklists in
   `references/<topic>.md`. Link each reference where it is needed and state when
   to load it. Do not duplicate its procedure or load every reference automatically.
4. Use relative internal links. Resolve each from its containing file and verify
   that it stays within the permitted destination. Keep owned references inside the
   skill folder so extraction retains them. Identify sibling-skill dependencies;
   links do not install those dependencies.
5. Follow destination frontmatter and registration contracts. In this collection,
   use YAML frontmatter with a directory-matching name that matches
   `^[a-z0-9]+(?:-[a-z0-9]+)*$` and is at most 64 characters. The nonempty
   description must be at most 1,024 characters and identify the activation boundary.
6. For a rewrite, preserve the skill's existing behavioral contract. Keep useful
   conditions and exceptions, required evidence, failure outcomes, and outputs.
   Define phase entry conditions and required artifacts or command/read-back evidence.
   For non-code work, specify deterministic acceptance or read-back criteria. Missing
   evidence blocks only the dependent transition.
7. Use numbered steps only when order matters, bullets for independent rules, and
   checklists for evidence-based gates. Do not impose one section template on every
   skill. Prefer direct conditional instructions and explicit prohibitions for real
   hazards. Remove repetition only after confirming the retained rule covers the
   same conditions and exceptions.
8. Add concrete, domain-specific shortcut protections to each authored skill.
   They may be concise rules or a table; a table is not required. Do not retrofit
   unrelated skills just because this workflow is loaded.

## Evaluate and validate

Read [skill evaluation](references/skill-evaluation.md) before evaluating a candidate.
Record representative trigger cases, criterion results, evidence, and missing host
coverage. Keep structural checks, static walkthroughs, model self-assessment,
observed behavior, and token or cost measurements distinct. An opinion or line count
does not establish model compliance or token savings.

Choose validation for the actual destination:

- In this repository, from its root and using the Go version in `go.mod`, run
  `go run ./cmd/skillpack` and `go test ./...`. Show commands, actual output, and
  exit codes. Both must exit 0, and validation must report the expected skill count,
  resolved references, and synchronized registries. Missing Go or failed checks
  blocks this gate.
- In another repository or for a standalone skill, run its configured validator
  and applicable checks. Do not require this repository's Go tooling or install it
  solely to satisfy this procedure. If no validator exists, record a path-specific
  read-back of frontmatter, relative links, packaged resources, and registration.
  A read-back cannot replace a validator or test suite the destination requires.

Run other destination-required checks. Repair failures within scope or report the
missing prerequisite; do not declare completion with an applicable gate failed or
unverified. Structural validation does not establish host discovery or agent
behavior. Report those separately, including untested hosts and scenarios. Give the
changed paths, observed checks, and remaining limits. Use authorized
[git-delivery](../git-delivery/SKILL.md) for later Git or publication actions.
