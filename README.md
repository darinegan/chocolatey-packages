# Chocolatey Packages

This repository contains Chocolatey packages, most of which are [automatic](https://chocolatey.org/docs/automatic-packages).

All packages should conform with the [standards][choco-standards] from the Chocolatey Community Core Team.

[Contributions][contributing] that follow this are welcome.

## Package automation

Package updates and publishing are split across three GitHub Actions workflows:

- **Validate Chocolatey packages** checks pull requests without secrets or publishing authority.
- **Update Chocolatey package sources** runs Chocolatey-AU against `master` and opens a pull request when package source files under `automatic\` change.
- **Publish Chocolatey packages** packs and publishes reviewed package sources after they land on protected `master`.

Publishing targets public chocolatey.org. The publish workflow uses the explicit push endpoint `https://push.chocolatey.org/`; only the Chocolatey API key is secret.

For contributor and maintainer operating rules, see [CONTRIBUTING.md](CONTRIBUTING.md). For AI-agent-specific repository guidance, see [AGENTS.md](AGENTS.md).

[//]: # "References"

[choco-standards]: https://github.com/chocolatey/chocolatey-coreteampackages/blob/master/CONTRIBUTING.md "Chocolatey Community Core Team Standards"
[contributing]: CONTRIBUTING.md "Contributing"
