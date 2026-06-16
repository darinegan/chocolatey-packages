# Agent instructions

This repository currently lands a validate-only automation foundation.

## Operating rules

- Keep pull request validation secret-free and fork-safe.
- Use `pull_request` for validation; do not use `pull_request_target`.
- Do not add secrets to pull request validation.
- Update and publish workflow design is deferred to issue #40.
- Keep #39 open as a child follow-up under that deferred stream.
- Use `gh` to validate live repository controls before changing release automation.
- Pin external GitHub Actions to full 40-character commit SHAs.
- Prefer `git`, PowerShell, and `gh` over third-party actions in jobs that use sensitive tokens.
- Use GitHub Issues as durable work tracking for non-trivial changes.
- Link pull requests to the issues they resolve with closing references.
- When implementation discovers follow-up work, create a follow-up issue instead of leaving that work only in chat, comments, or local plans.

## Documentation ownership

- `README.md` owns the user-facing overview.
- `CONTRIBUTING.md` owns canonical human contributor, maintainer, and release instructions.
- `AGENTS.md` owns agent behavior only.

Cross-reference these files instead of duplicating content. Do not turn automated repository controls into human maintainer chores in CONTRIBUTING.md; document only the manual effort that remains. If you learn durable repository behavior or change automation behavior, update the most appropriate document so the next human or AI agent has less to rediscover.

## Self-documenting expectation

Leave the repository easier to understand than you found it. When automation changes, update the docs in the same change. When adding safeguards, make the invariant clear in workflow names, job names, and short comments where the reason is not obvious.
