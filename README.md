# Chocolatey Packages

This repository contains Chocolatey packages, most of which are [automatic](https://chocolatey.org/docs/automatic-packages).

All packages should conform with the [standards][choco-standards] from the Chocolatey Community Core Team.

[Contributions][contributing] that follow this are welcome.

## Automation

Current automation scope in this branch is a dedicated **Validate** workflow:

- **Validate** checks pull requests without secrets or publishing authority.
- The final **Validation result** job is always-concluding so it can be used as a required branch-protection check.

Update and publish workflow design is intentionally deferred to follow-up issue work so the current PR can stay validate-only. See issue #40 (deferred update/publish architecture) and issue #39 (publish-trigger follow-up under that deferred stream).

For contributor and maintainer operating rules, see [CONTRIBUTING.md](CONTRIBUTING.md). For AI-agent-specific repository guidance, see [AGENTS.md](AGENTS.md).

[//]: # "References"

[choco-standards]: https://github.com/chocolatey/chocolatey-coreteampackages/blob/master/CONTRIBUTING.md "Chocolatey Community Core Team Standards"
[contributing]: CONTRIBUTING.md "Contributing"
