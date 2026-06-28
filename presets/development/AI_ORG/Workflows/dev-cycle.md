# Workflow: DevCycle

## Objective

Convert a software-development request into a focused implementation with appropriate tests and review.

## Trigger

Use this workflow for feature work, bug fixes, refactors, test work, and code review tasks.

## Complexity Router

| Level | Condition | Route |
|---|---|---|
| Fast Patch | Small localized change with clear behavior | Developer -> Reviewer |
| Standard | Feature, bugfix, refactor, or test update | Architect -> Developer -> Tester -> Reviewer |
| Full | Cross-cutting design, data migration, public API, security-sensitive change | Architect -> user checkpoint -> Developer -> Tester -> Reviewer |

Default to Standard when risk is unclear.

## Phase 0: Briefing

Orchestrator gathers:

- Task and expected behavior.
- Relevant repository context.
- Files or areas likely in scope.
- Constraints and no-overwrite rules.
- Verification expectations.
- Done condition.

Ask only when missing information would make the work unsafe or likely wrong.

## Phase 1: Architect

Architect returns:

- Change summary.
- Files or modules likely affected.
- Design approach.
- Risks and assumptions.
- Test strategy.

Skip this phase only for Fast Patch work.

## Phase 2: Developer

Developer implements the focused change.

Rules:

- Inspect existing code before editing.
- Preserve unrelated worktree changes.
- Follow local style and existing helpers.
- Avoid unrelated refactors.
- Report changed files and noteworthy decisions.

## Phase 3: Tester

Tester selects and runs relevant verification.

Expected output:

- Commands run.
- Result.
- Coverage or gap.
- Any failures with likely cause.

If no tests can be run, Tester explains why and recommends the smallest useful verification.

## Phase 4: Reviewer

Reviewer checks:

- Does the implementation satisfy the request?
- Are safety and no-overwrite rules respected?
- Are tests sufficient for the risk?
- Are there regressions, edge cases, or maintainability issues?
- Are findings classified with GSAR evidence quality?
- Did the devil's advocate pass find a plausible failure mode?

Reviewer returns `PASS`, `CONDITIONAL_PASS`, or `FAIL`.

## Revision Limit

If Reviewer returns `FAIL`, loop back to Developer up to two times. After two failed revision loops, Orchestrator reports the blocker and next best action.

## Done When

- Requested behavior is implemented or a blocker is clear.
- Tests or verification are reported.
- Reviewer verdict is known.
- Final answer lists changed paths, behavior, verification, and residual risk.
