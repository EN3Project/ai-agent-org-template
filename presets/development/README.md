# Development Preset

This preset is an overlay that turns the base `scaffold/AI_ORG/` into a small software-development team:

- Architect: scopes design, risks, files, and test strategy.
- Developer: makes focused code changes.
- Tester: chooses and runs relevant verification.
- Reviewer: checks correctness, safety, regression risk, and evidence quality.
- DevCycle: routes work through the lightest useful path.

It is meant to be applied through `scripts/init-ai-org.* --preset development`. It is not a CI system, release framework, or long-term knowledge base.

## Install

Use the initialization script so the base scaffold and development overlay are combined consistently.

Bash:

```bash
bash scripts/init-ai-org.sh \
  --preset development \
  --destination ./AI_ORG \
  --purpose "既存コードベースの機能追加、修正、テスト、レビューを安全に進める"
```

PowerShell:

```powershell
.\scripts\init-ai-org.ps1 `
  -Preset development `
  -Destination .\AI_ORG `
  -Purpose "既存コードベースの機能追加、修正、テスト、レビューを安全に進める"
```

If the target already has `AI_ORG/`, do not overwrite it. Read its `MANIFEST.md`, `Runtime/BOOT.md`, and `Runtime/CONTEXT_INDEX.md`, then ask whether to continue, extend, or create a differently named org.

Directly copying `presets/development/AI_ORG/` is not recommended because it is only the overlay. The generated org should also include the common scaffold areas such as `Reports/`, `Decisions/`, `Vault/`, and `Runtime/HEALTH.md`.

## Manifest Guidance

The preset `MANIFEST.md` is intentionally generic. For a real project, adjust only these fields first:

- Purpose: pass `--purpose`; the script replaces `[用途を書く]`.
- Safety and No-Overwrite Rules: add project-specific protected paths, generated files, or deployment boundaries.
- Development Expectations: name the preferred package manager, test command, lint command, and review standard if known.
- Runtime: set the template source only if this repository's reference docs should be available for org-improvement tasks.

Keep the manifest short. Put detailed coding conventions in `Docs/development-guidelines.md`, not in the manifest.

## Generated Files

```text
AI_ORG/
  .gitignore
  MANIFEST.md
  orchestrator.md
  Agents/
    architect.md
    developer.md
    worker.md      # fallback for non-development tasks
    critic.md      # fallback quality gate
    tester.md
    reviewer.md
  Workflows/
    dev-cycle.md
    execute.md     # fallback for non-development tasks
  Runtime/
    BOOT.md
    CONTEXT_INDEX.md
    OBSERVATIONS.md
    HEALTH.md
  Reports/
    dispatch-trace.md
    health-check.md
  Decisions/
    ADR-template.md
  Vault/
    README.md
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
