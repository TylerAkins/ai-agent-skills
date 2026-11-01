# Skill Evaluation

Use this rubric after drafting and before the verification exit gate. For every
criterion, record satisfied, failed, or unverified and cite its evidence. Do not
average results to hide a failure. Repair failed criteria; missing evidence leaves
that part of evaluation incomplete.

| Criterion | Acceptance evidence |
| --- | --- |
| Trigger precision | Classify representative activating, excluded, and ambiguous requests. The description and routing boundaries identify the intended artifact and yield to sibling workflows for excluded requests. |
| Clear structure | Inspect whether ordered actions are numbered, independent rules are easy to locate, conditions state their consequence, and checklists are reserved for evidence gates. Check for dense compound rules and unnecessary nesting without imposing a universal template. |
| Brevity and context cost | Inspect the entrypoint for operational necessity. Move conditional schemas, templates, and exhaustive lists into linked references; remove duplicated instructions only when one retained rule covers the same cases. Record file sizes or line counts as observations, not universal pass thresholds. |
| Determinism | Trace each phase from its entry condition to its required artifact, command output, or read-back. A missing prerequisite has an explicit hold or failure outcome, and no confidence claim permits advancement. |
| Host portability | Check instructions for Cursor, Claude Code, Codex, Copilot, and OpenCode without assuming a host-specific tool name, path, delegation API, or installation. Record actual discovery and execution evidence separately for each tested host. |

## Candidate checks

Before completing the evaluation:

- Verify name, directory, description length, and YAML parsing against the destination
  schema and available validator.
- Resolve every relative link, including links within references. Confirm owned
  resources survive skill-folder extraction and identify sibling dependencies.
- Check each reference's load condition and ensure no duplicate procedure competes
  with the entrypoint.
- Compare scope and authority with the intended request, including commits, live
  changes, and publication.
- Verify shortcut protections name plausible domain-specific evasions and state the
  action that prevents them. A table is optional.
- Walk through activating, excluded or ambiguous, and blocked requests. Record
  required outputs, evidence, and stopping conditions. A static walkthrough is not
  observed agent behavior.
- Compare every rule in a behavior-preserving rewrite with its baseline. Look
  specifically for dense compound instructions, duplicated gates, lost exceptions,
  and checklists whose completion is not supported by evidence.
- Check all required destination inventories in the complete candidate. In
  `ai-agent-skills`, verify README counts and `using-skills` routing.
- Run the destination-specific validation and retain commands, actual output, and
  exit codes. Use the specified standalone read-back only when no validator exists.

## Behavioral and Host Evidence

For execution evidence, use representative requests in a safe scratch workspace and
retain actual artifacts and decisions. Compare them with acceptance criteria set
before the run. Do not provide the expected answer as proof. Record the host,
candidate revision or exact working files, request, observed output, and unsupported
tools or missing sibling skills.

For non-code outputs, check properties such as schema validation, resolved links,
required artifact fields, or a read-back of saved content. A model's statement that
an artifact is correct does not satisfy these criteria.

Label structural checks, static walkthroughs, model self-assessments, host discovery,
and observed agent execution separately. Do not claim all-host compatibility from a
successful package build. Report missing live-host evidence even when structural
validation passes. Do not claim token or cost savings without measuring them.
