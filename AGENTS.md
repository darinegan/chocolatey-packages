# Agent instructions

This repository uses Chocolatey-AU and GitHub Actions to update, validate, pack, and publish.

## Operating rules

- Keep workflow responsibilities mutually exclusive:
  - update workflow: update package source files and open a pull request;
  - validation workflow: validate pull requests without secrets;
  - publish workflow: pack and publish reviewed sources from protected `master`.
- Do not use `pull_request_target` for automation.
- Do not add secrets to pull request validation.
- Do not combine `.\update_all.ps1` with `choco push` in the same workflow.
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
