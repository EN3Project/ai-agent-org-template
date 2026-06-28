# Development Guidelines

These guidelines support the Development preset. They do not override `MANIFEST.md` or current user instructions.

## Coding

- Prefer existing project patterns over new abstractions.
- Add abstractions only when they remove real duplication or clarify shared behavior.
- Keep edits close to the requested behavior.
- Avoid unrelated formatting churn.
- Treat generated files, lockfiles, migrations, and snapshots as higher-risk edits.

## Testing

- Match test scope to risk.
- For small local fixes, run the narrowest relevant test.
- For shared behavior, public APIs, data migrations, auth, security, or concurrency, recommend broader tests.
- If the project has no obvious test command, inspect package/config files before deciding.
- If tests cannot run, report why and what risk remains.

## Review

- Findings should be specific, actionable, and evidence-labeled with GSAR.
- `FAIL` means the implementation should not be considered complete.
- `CONDITIONAL_PASS` means the work is usable with named caveats.
- `PASS` still includes residual risk if any remains.

## Final Delivery

Final answers should be concise and include:

- Changed paths.
- Behavior summary.
- Tests or checks run.
- Known residual risk.
