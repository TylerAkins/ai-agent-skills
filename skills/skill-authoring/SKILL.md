---
name: skill-authoring
description: Design, author, evaluate, and package new engineering skills or refactor existing skills within this collection's architectural standards.
---

# Skill Authoring

## Scope and Authority

Read [anti-ai-writing](../anti-ai-writing/SKILL.md) before drafting. Distinguish
skill design, local authoring, evaluation, and repository registration. Deliver a
scoped skill package with verified references and synchronized inventories.
Drafting or packaging does not authorize commits, installation into live hosts,
remote publication, or changes to repository policy.

## Clarify Boundary and Trigger

Define one responsibility, its observable output, activating requests, exclusions,
and acceptance criteria before drafting. Inspect neighboring skills and actual
collection tooling to avoid duplicating an existing workflow.

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
confirm they exist without escaping the collection boundary. Keep references owned
by the skill inside its folder so individual extraction preserves them. Identify
sibling-skill dependencies explicitly; links do not install those dependencies.

## Authoring Rules

Follow anti-ai-writing: no em dashes, filler, conversational openers, or corporate
fluff. Write concrete actions and required evidence rather than confidence claims.
Preserve existing user authorization and unrelated work.

Require YAML frontmatter with a name matching its directory and the regex
`^[a-z0-9]+(?:-[a-z0-9]+)*$`, at most 64 characters. Require a nonempty description
of at most 1,024 characters that identifies the activation boundary.

Define phase entry conditions, required artifacts or command/read-back evidence,
and failure behavior. Missing evidence blocks the dependent transition. Non-code
work must specify deterministic acceptance criteria or validation read-backs.
Include domain-specific anti-rationalization rules in every skill authored here.
Do not retrofit unrelated skills merely because this workflow is loaded.

Register additions or renames in the README browse table and the
[using-skills](../using-skills/SKILL.md) routing table in the same change. Update
counts and affected links; do not declare registration complete with deferred edits.

## Anti-Rationalization Guardrails

| Model Rationalization | Enforced Rule |
| --- | --- |
| The skill is simple, so reference files are unnecessary. | If technical detail exceeds operational steps, isolate it into `references/` and link it at the relevant step. |
| I can skip the Anti-Rationalization table for this domain. | Every authored skill must pre-empt its concrete evasion paths with enforced rules. |
| A verification gate is not applicable to a non-code skill. | Define deterministic acceptance criteria or validation read-backs before declaring completion. |
| I will register the skill in the README later. | README and using-skills registry updates are atomic requirements of the skill change. |

## Verification Exit Gate

Read [skill evaluation](references/skill-evaluation.md) before evaluating the candidate.
Record its trigger cases, acceptance results, and any missing host evidence.
From the collection root, execute:

```sh
go run ./cmd/skillpack
go test ./...
```

Display both commands, actual output, and exit codes. Completion requires exit code
0 from both, the expected skill count, resolved references, synchronized registries,
and all evaluation acceptance criteria satisfied. Run additional repository-required
checks for the changed scope. If a command fails or cannot run, repair within scope
or report the gate blocked; do not substitute inspection for execution.

Structural validation does not prove host discovery or agent behavior. Report those
separately, including untested hosts and scenarios. Deliver the changed paths,
observed verification, and remaining limits. Use authorized
[git-delivery](../git-delivery/SKILL.md) for subsequent Git or publication actions.
