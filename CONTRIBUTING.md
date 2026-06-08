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

Pull requests are validated by the **Validate Chocolatey packages** workflow. That workflow is intentionally secret-free so it can safely run for forked pull requests.

## Maintainer release workflow

The release automation is intentionally split into mutually exclusive responsibilities:

- **Update Chocolatey package sources** runs `.\update_all.ps1` without publishing and opens an update pull request.
- **Validate Chocolatey packages** validates pull requests and is the required merge gate.
- **Publish Chocolatey packages** only packs and pushes sources that already reached protected `master`.

Maintainers should not combine update and publish behavior in a single workflow. Publishing to public chocolatey.org must happen through the publish workflow, using `CHOCOLATEY_PUSH_URL=https://push.chocolatey.org/` and the protected `CHOCOLATEY_API_KEY` environment secret.

Manual publish runs must be dispatched from `master`; the publish workflow checks out protected `master` and will not run from feature branches.

Publish-on-push should only be enabled after the required repository controls below are configured. Until then, publishing remains a manual environment-gated workflow dispatch.

### Required repository controls

Before publish-on-push is enabled, maintainers must ensure:

1. `master` requires pull request review.
1. `master` blocks direct pushes and force pushes.
1. The validation result job is a required status check.
1. The default `GITHUB_TOKEN` permission is read-only, or each workflow uses explicit `permissions: {}`.
1. The `chocolatey-publishing` environment exists with required reviewers.
1. `CHOCOLATEY_API_KEY` is stored only as a `chocolatey-publishing` environment secret.
1. External GitHub Actions are pinned to full commit SHAs and maintained through reviewed updates.

Use `gh` to confirm the live repository controls before changing release automation:

```powershell
gh api repos/darinegan/chocolatey-packages/branches/master/protection
gh api repos/darinegan/chocolatey-packages/environments
gh api repos/darinegan/chocolatey-packages/actions/permissions
gh api repos/darinegan/chocolatey-packages/actions/permissions/workflow
```

### Required automation credentials

- `UPDATE_PR_TOKEN`: fine-grained PAT or GitHub App token scoped only to this repository with the minimum permissions needed to push the update branch and create or update pull requests. Do not replace it with `GITHUB_TOKEN`; `GITHUB_TOKEN`-created PRs do not trigger the required pull request validation workflow.
- `CHOCOLATEY_API_KEY`: protected environment secret for publishing to public chocolatey.org.
- `CHOCOLATEY_PUSH_URL`: non-secret workflow environment variable set to `https://push.chocolatey.org/`.

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
