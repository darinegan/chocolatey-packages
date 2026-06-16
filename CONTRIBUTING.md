# Contributing

Welcome and thank you for deciding to contribute to this project. Contributions are released under the [project's license][license].

Please note that this project is released with a [Code of Conduct][code-of-conduct]. By participating, you agree to abide by its terms.

## Getting Started

1. [Fork][fork-repo] this repository.
1. [Clone][clone-repo] your fork.
1. Create a new [branch][branching-basics].
1. [Make your change][making-changes].
1. [Push your change][pushing-changes].
1. Submit a [pull request][submit-a-pr].

Pull requests are validated by the **Validate** workflow. That workflow is intentionally secret-free so it can safely run for forked pull requests.

## Issue tracking

Use GitHub Issues as the durable unit of work for non-trivial changes.

1. Start from an existing issue or create one before opening a substantial pull request.
1. Include a closing reference in the pull request body when the pull request fully resolves the issue.
1. If review, investigation, or implementation discovers follow-up work, file a separate issue for that work instead of leaving it only in chat, comments, or local notes.

## Current automation scope

This PR scope is validate-only:

- **Validate** validates pull requests and is the merge gate candidate.
- Validate stays secret-free so it can safely run for forks.

Update and publish automation is deferred to follow-up issue work:

- #40 tracks deferred update/publish architecture.
- #39 stays open as a child follow-up for publish-trigger enablement after the deferred stream is implemented.

Until that deferred work lands, maintainers continue the release flow manually (`.\update_all.ps1`, `choco pack`, `choco push`) from trusted maintainer context.

### Maintainer responsibilities

Repository controls are managed through GitHub settings and automation. Normal maintainer work should focus on the manual steps that cannot be safely automated:

1. Review and merge pull requests after validation passes.
1. Ensure pull requests pass the `Validation result` gate before merge.
1. Run manual release commands from trusted maintainer context when a package release is needed.
1. Set or rotate secrets without pasting secret values into issues, pull requests, or chat.

For this validate-only phase, treat update/publish credentials and workflow triggers as deferred work under #40/#39 and do not add publish or update secrets to pull request validation.

## Resources

- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute)
- [Understanding the GitHub Flow](https://guides.github.com/introduction/flow)

[//]: # "References"

[license]: LICENSE.md "License"
[code-of-conduct]: CODE_OF_CONDUCT.md "Code of Conduct"
[fork-repo]: https://help.github.com/articles/fork-a-repo "Fork a repo"
[clone-repo]: https://help.github.com/articles/cloning-a-repository "Cloning a repository"
[branching-basics]: https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging "Git Branching Basics"
[making-changes]: https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository#_committing_changes "Committing Your Changes"
[pushing-changes]: https://help.github.com/articles/pushing-to-a-remote "Pushing to a remote"
[submit-a-pr]: https://help.github.com/articles/creating-a-pull-request-from-a-fork "Creating a pull request from a fork"
