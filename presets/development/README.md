# Development Preset

This preset turns `AI_ORG` into a small software-development team:

- Architect: scopes design, risks, files, and test strategy.
- Developer: makes focused code changes.
- Tester: chooses and runs relevant verification.
- Reviewer: checks correctness, safety, regression risk, and evidence quality.
- DevCycle: routes work through the lightest useful path.

It is meant to be copied as a ready-to-use `AI_ORG/` for AI-assisted coding. It is not a CI system, release framework, or long-term knowledge base.

## Install

1. Pick the target repository or project directory.
2. If the target already has `AI_ORG/`, do not overwrite it. Read its `MANIFEST.md`, `Runtime/BOOT.md`, and `Runtime/CONTEXT_INDEX.md`, then ask whether to continue, extend, or create a differently named org.
3. Copy `presets/development/AI_ORG/` to the target as `AI_ORG/`.
4. Start normal operation from `AI_ORG/Runtime/BOOT.md`.

## Manifest Guidance

The preset `MANIFEST.md` is intentionally generic. For a real project, adjust only these fields first:

- Purpose: name the project and the kind of software work the org should help with.
- Safety and No-Overwrite Rules: add project-specific protected paths, generated files, or deployment boundaries.
- Development Expectations: name the preferred package manager, test command, lint command, and review standard if known.
- Runtime: set the template source only if this repository's reference docs should be available for org-improvement tasks.

Keep the manifest short. Put detailed coding conventions in `Docs/development-guidelines.md`, not in the manifest.

## Included Files

```text
AI_ORG/
  MANIFEST.md
  orchestrator.md
  Agents/
    architect.md
    developer.md
    tester.md
    reviewer.md
  Workflows/
    dev-cycle.md
  Runtime/
    BOOT.md
    CONTEXT_INDEX.md
    OBSERVATIONS.md
  Docs/
    development-guidelines.md
  Scratch/
    README.md
```

## First Task Checklist

- The user request is understood and scoped.
- Existing worktree changes are inspected before edits.
- No unrelated files are changed.
- Tests or a clear reason tests were not run are reported.
- Reviewer returns `PASS`, `CONDITIONAL_PASS`, or `FAIL`.
- Final answer lists changed paths and behavior.
