# Skill Evaluation

Use this rubric after drafting and before the verification exit gate. Record each
criterion as satisfied, failed, or unverified with its evidence. Do not average
scores to conceal a failed requirement. Failures require repair; missing evidence
leaves the affected evaluation incomplete.

| Criterion | Acceptance evidence |
| --- | --- |
| Trigger precision | Classify representative activating, excluded, and ambiguous requests. The description and routing boundaries identify the intended artifact and yield to sibling workflows for excluded requests. |
| Brevity and context cost | Inspect the entrypoint for operational necessity. Move conditional schemas, templates, and exhaustive lists into linked references; remove duplicated instructions. Record file sizes or line counts as observations, not universal pass thresholds. |
| Determinism | Trace each phase from its entry condition to its required artifact, command output, or read-back. A missing prerequisite has an explicit hold or failure outcome, and no confidence claim permits advancement. |
| Host portability | Check instructions for Cursor, Claude Code, Codex, Copilot, and OpenCode without assuming a host-specific tool name, path, delegation API, or installation. Record actual discovery and execution evidence separately for each tested host. |

## Candidate Checklist

- Verify the name, directory, description length, and YAML parse against collection tooling.
- Resolve every relative link, including links within references. Confirm owned resources survive extraction of the skill folder and identify sibling dependencies.
- Verify references have a stated load condition and no duplicated procedure competes with the entrypoint.
- Check scope and authority against the intended request, including commits, live changes, and publication.
- Verify the guardrail table addresses plausible shortcuts with concrete enforced rules.
- Trace one successful request and one blocked request through the written workflow. Record the required output and stopping condition; a walkthrough is not observed agent behavior.
- Check README inventory, displayed skill counts, and using-skills routing in the complete candidate.
- Run the entrypoint's required validation commands and retain actual output and exit codes.

## Behavioral and Host Evidence

When evaluating execution, use representative requests in a safe scratch workspace
and preserve the actual artifacts and decisions. Compare them with acceptance
criteria established before the run. Do not supply the expected answer as proof.
Record the host, candidate revision or exact working files, request, observed output,
and any unsupported tool or missing sibling skill.

For non-code outputs, use checkable properties such as schema validation, resolved
links, required artifact fields, or a read-back of saved content. A model statement
that an artifact is correct cannot satisfy these criteria.

Label static checks, walkthroughs, host discovery, and observed agent execution
separately. Do not claim all-host compatibility from a successful package build.
Missing live host evidence must appear in the delivery limits even when structural
validation passes.
