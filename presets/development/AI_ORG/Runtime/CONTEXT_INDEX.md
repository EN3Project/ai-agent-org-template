# Runtime CONTEXT INDEX

## Template Source

Optional path to the source template repository:

```text
[template path]
```

If this is still `[template path]`, do not try to resolve `[template]/...` additional reads.

## Mode Router

### Normal Development

Trigger:

- Feature implementation
- Bug fix
- Refactor
- Test addition or repair
- Development task with code changes

Read:

- `MANIFEST.md`
- `orchestrator.md`
- `Workflows/dev-cycle.md`
- `Agents/architect.md`
- `Agents/developer.md`
- `Agents/tester.md`
- `Agents/reviewer.md`
- `Docs/development-guidelines.md`

### Fast Patch

Trigger:

- Small, localized edit
- Single-file fix
- Documentation tweak
- Obvious typo or config correction

Read:

- `MANIFEST.md`
- `orchestrator.md`
- `Workflows/dev-cycle.md`
- `Agents/developer.md`
- `Agents/reviewer.md`

### Test Or Review Only

Trigger:

- User asks to review code
- User asks to run or design tests
- User asks for risk assessment without implementation

Read:

- `MANIFEST.md`
- `orchestrator.md`
- `Agents/tester.md`
- `Agents/reviewer.md`
- `Docs/development-guidelines.md`

### General Non-Development

Trigger:

- Writing, summarization, organizing, or other non-code work
- User asks for a normal task inside the project that does not require code changes

Read:

- `MANIFEST.md`
- `orchestrator.md`
- `Workflows/execute.md`
- `Agents/worker.md`
- `Agents/critic.md`

### Organization Improvement

Trigger:

- User asks to change this AI_ORG
- Agent roles or workflows are confusing
- Same development failure repeats
- Runtime context is getting heavy

Read:

- `MANIFEST.md`
- `orchestrator.md`
- `Runtime/OBSERVATIONS.md`

Additional Read:

- `[template]/continuous-improvement.md`
- `[template]/OrgDesign.md`
- `[template]/org_designer.md`

## Improvement Signals

Record a short, abstract note in `Runtime/OBSERVATIONS.md` only when:

- The same bug pattern appears more than once.
- Tests are repeatedly missing for the same area.
- Review findings repeatedly fall into the same GSAR category.
- The same setup question blocks multiple tasks.
- The normal context set becomes too large for routine coding.

Use this shape:

```text
YYYY-MM-DD | Signal | Impact | Suggested adjustment
```

Do not store task details, secrets, logs, or copied source content.
