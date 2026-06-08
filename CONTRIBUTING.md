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

Publishing remains a manual environment-gated workflow dispatch until publish-on-push is enabled in a follow-up change.

### Maintainer responsibilities

Repository controls are managed through GitHub settings and automation. Normal maintainer work should focus on the manual steps that cannot be safely automated:

1. Review and merge automated update pull requests.
1. Approve protected publishing deployments when packages should be released.
1. Set or rotate automation secrets without pasting secret values into issues, pull requests, or chat.
1. Manually dispatch update or publish workflows when needed.

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
