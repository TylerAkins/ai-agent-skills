---
name: skill-authoring
description: Design, author, evaluate, and package new engineering skills or refactor existing skills using the destination's conventions and validation requirements.
---

# Skill Authoring

## Scope and Authority

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting. Distinguish
skill design, local authoring, evaluation, and repository registration. Deliver a
scoped skill package with verified references and any required destination inventories.
Drafting or packaging does not authorize commits, installation into live hosts,
remote publication, or changes to repository policy.

## Clarify Boundary and Trigger

Define one responsibility, its observable output, activating requests, exclusions,
and acceptance criteria before drafting. Inspect neighboring skills and actual
destination tooling to avoid duplicating an existing workflow.

Use this skill for new or revised agent instructions and their supporting resources.
Use [agent-planning](../agent-planning/SKILL.md) for engineering implementation plans,
[test-authoring](../test-authoring/SKILL.md) for behavioral tests, and
[writing-clean-simple-code](../writing-clean-simple-code/SKILL.md) for production
code. Those tasks do not trigger skill authoring unless the requested artifact is
itself a skill. Resolve missing intent before dependent authoring; continue settled work.

## Structure and Progressive Disclosure

Keep trigger boundaries, authority, operational steps, and exit gates in `SKILL.md`.
Put domain schemas, templates, and exhaustive checklists in `references/<topic>.md`.
Link each reference at its point of use and state when to load it. Do not duplicate
its contents in the entrypoint or load all references automatically.

Use relative paths for internal links. Resolve them from the containing file and
confirm they exist without escaping the permitted destination boundary. Keep references owned
by the skill inside its folder so individual extraction preserves them. Identify
sibling-skill dependencies explicitly; links do not install those dependencies.

## Authoring Rules

Follow anti-ai-writing: no em dashes, filler, conversational openers, or corporate
fluff. Write concrete actions and required evidence rather than confidence claims.
Preserve existing user authorization and unrelated work.

Use the destination's supported frontmatter contract. For this collection, require
YAML frontmatter with a name matching its directory and the regex
`^[a-z0-9]+(?:-[a-z0-9]+)*$`, at most 64 characters. Require a nonempty description
of at most 1,024 characters that identifies the activation boundary.

Define phase entry conditions, required artifacts or command/read-back evidence,
and failure behavior. Missing evidence blocks the dependent transition. Non-code
work must specify deterministic acceptance criteria or validation read-backs.
Include domain-specific anti-rationalization rules in every skill authored here.
Do not retrofit unrelated skills merely because this workflow is loaded.

Identify the destination's registration requirements before authoring. In this
collection, register additions or renames in the README browse table and the
[using-skills](../using-skills/SKILL.md) routing table in the same change, including
counts and affected links. Elsewhere, update existing required inventories; do not
create a README, router, or collection tooling solely to imitate this repository.

## Anti-Rationalization Guardrails

| Model Rationalization | Enforced Rule |
| --- | --- |
| The skill is simple, so reference files are unnecessary. | If technical detail exceeds operational steps, isolate it into `references/` and link it at the relevant step. |
| I can skip the Anti-Rationalization table for this domain. | Every authored skill must pre-empt its concrete evasion paths with enforced rules. |
| A verification gate is not applicable to a non-code skill. | Define deterministic acceptance criteria or validation read-backs before declaring completion. |
| I will register the skill in the README later. | Required destination registry updates are atomic with the skill change; this collection requires README and using-skills updates. |

## Verification Exit Gate

Read [skill evaluation](references/skill-evaluation.md) before evaluating the candidate.
Record its trigger cases, acceptance results, and any missing host evidence.
Choose the validation path from the actual destination:

- **This repository:** When editing the source checkout of `ai-agent-skills`, run
  the following from its root using the Go version declared in `go.mod`:

  ```sh
  go run ./cmd/skillpack
  go test ./...
  ```

  Display the commands, actual output, and exit codes. Both must exit 0, with the
  expected skill count, resolved references, and synchronized registries. Missing
  Go blocks this repository's gate; do not waive required checks.
- **Other repositories or standalone skills:** Run the destination's configured
  skill validator and applicable checks. Do not require Go, `cmd/skillpack`, or
  this repository's test suite, and do not install them solely to satisfy this skill.
  If no validator exists, record a file read-back checking frontmatter fields
  against the destination contract, relative-link resolution, packaged resources,
  and required registration. Include the paths and observed results for each
  criterion; a declaration that the skill looks correct is insufficient.

Completion requires all applicable structural and evaluation criteria to pass.
Run additional destination-required checks for the changed scope. Failed or
unavailable required checks block completion; repair within scope or report the
missing prerequisite. A standalone validation read-back cannot replace a validator
or test suite explicitly required by the destination.

Structural validation does not prove host discovery or agent behavior. Report those
separately, including untested hosts and scenarios. Deliver the changed paths,
observed verification, and remaining limits. Use authorized
[git-delivery](../git-delivery/SKILL.md) for subsequent Git or publication actions.
