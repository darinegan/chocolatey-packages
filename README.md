# Chocolatey Packages

This repository contains Chocolatey packages, most of which are [automatic](https://chocolatey.org/docs/automatic-packages).

All packages should conform with the [standards][choco-standards] from the Chocolatey Community Core Team.

[Contributions][contributing] that follow this are welcome.

## What is This Repository?

This repository hosts a collection of Chocolatey packages that are automatically maintained using the [AU (Automatic Updater)][au-framework] framework. Chocolatey is a package manager for Windows that allows you to install and manage software through simple commands. The packages in this repository are designed to automatically check for new versions of software and update accordingly.

## Repository Structure

```
chocolatey-packages/
├── automatic/           # Packages that auto-update with AU
│   ├── service-fabric/
│   ├── service-fabric-sdk/
│   ├── service-fabric-tools/
│   └── smimesign/
├── manual/              # Packages maintained manually
├── icons/               # Package icons and images
├── setup/               # Setup scripts for AU
├── tools/               # Helper tools and PowerShell modules
│   └── PSModules/       # Custom PowerShell modules
├── update_all.ps1       # Script to update all automatic packages
└── test_all.ps1         # Script to test all packages
```

### Folder Descriptions

- **`automatic/`**: Contains packages that are automatically updated using the AU framework. Each package has an `update.ps1` script that defines how to check for and apply updates.

- **`manual/`**: Contains packages that require manual updates or don't need automatic updates.

- **`icons/`**: Stores package icons and images to avoid duplication across package folders.

- **`setup/`**: Contains setup scripts for configuring the AU framework on your system.

- **`tools/`**: Houses helper tools and PowerShell modules used by packages (e.g., ServiceFabricPackageTools).

## Current Packages

This repository currently maintains the following packages:

- **service-fabric**: Microsoft Service Fabric runtime for distributed systems
- **service-fabric-sdk**: Service Fabric SDK for development
- **service-fabric-tools**: Service Fabric development tools
- **smimesign**: S/MIME signing tool from GitHub

## How Automatic Updates Work

The automatic packages in this repository use the [AU (Automatic Updater)][au-framework] framework:

1. Each package in `automatic/` contains an `update.ps1` script
2. This script defines:
   - Where to check for the latest version (`au_GetLatest`)
   - What to update in package files (`au_SearchReplace`)
   - Any pre-update actions (`au_BeforeUpdate`)
3. The `update_all.ps1` script runs all package updates automatically
4. When a new version is found, AU updates the package files and can optionally push to Chocolatey.org

### Example Update Process

When `update_all.ps1` runs:

```powershell
# Execute from repository root
.\update_all.ps1
```

For each package, AU will:
1. Check the upstream source for the latest version
2. Compare with the current package version
3. If newer, download checksums and update package files
4. Optionally create a commit and push to Chocolatey

## Getting Started

### Prerequisites

- Windows with PowerShell 5.0+
- [Chocolatey](https://chocolatey.org/install) installed
- Git for version control

### Setting Up AU

1. Clone this repository:
   ```powershell
   git clone https://github.com/darinegan/chocolatey-packages.git
   cd chocolatey-packages
   ```

2. Run the AU setup script:
   ```powershell
   .\setup\au_setup.ps1
   ```

   This will:
   - Install the AU PowerShell module
   - Set up NuGet package provider
   - Configure PowerShell Gallery as a trusted repository

3. (Optional) Configure AU plugins and options:
   - See [AU Plugins documentation][au-plugins]
   - Configure environment variables for automated pushing (see `update_all.ps1`)

### Updating Packages

To update all packages manually:

```powershell
.\update_all.ps1
```

To update specific packages:

```powershell
.\update_all.ps1 -Name service-fabric,smimesign
```

To force an update even if version hasn't changed:

```powershell
.\update_all.ps1 -ForcedPackages 'service-fabric'
```

### Testing Packages

To test all packages:

```powershell
.\test_all.ps1
```

To test specific packages:

```powershell
.\test_all.ps1 -Name service-fabric
```

To test a random subset (useful for CI):

```powershell
.\test_all.ps1 -Name 'random 3'  # Tests a random 1/3 of packages
```

## Adding a New Package

### Adding an Automatic Package

1. Create a new folder in `automatic/` with your package name:
   ```powershell
   cd automatic
   mkdir my-package
   cd my-package
   ```

2. Create the standard Chocolatey package files:
   - `my-package.nuspec` - Package metadata
   - `tools\chocolateyInstall.ps1` - Installation script
   - `tools\chocolateyUninstall.ps1` - Uninstallation script (if needed)

3. Create an `update.ps1` script:
   ```powershell
   Import-Module au

   function global:au_SearchReplace {
       @{
           'tools\chocolateyInstall.ps1' = @{
               "(?i)^(\s*url\s*=\s*)'.*'" = "`${1}'$($Latest.URL)'"
               "(?i)^(\s*checksum\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum)'"
           }
       }
   }

   function global:au_GetLatest {
       # Logic to get the latest version
       # Return a hashtable with Version, URL, Checksum, etc.
   }

   update -ChecksumFor all
   ```

4. Test your update script:
   ```powershell
   .\update.ps1
   ```

5. Add your package icon to the `icons/` folder

**Note**: Do NOT use `choco new --auto` for AU packages. AU doesn't require automatic package tokens.

### Adding a Manual Package

1. Create a new folder in `manual/` with your package name
2. Create standard Chocolatey package files (`.nuspec`, `chocolateyInstall.ps1`, etc.)
3. No `update.ps1` needed for manual packages

## Configuration

### Environment Variables

The `update_all.ps1` and `test_all.ps1` scripts can be configured using environment variables:

- `$Env:au_Push` - Set to 'true' to push updates to Chocolatey
- `$Env:github_user_repo` - Your GitHub username/repo for reports
- `$Env:gist_id` - Gist ID for publishing update reports
- `$Env:github_api_key` - GitHub API key for gist and git operations
- `$Env:mail_*` - Email notification settings (user, server, password, port, etc.)

### Custom Configuration File

You can create a `update_vars.ps1` file in the repository root to set these variables:

```powershell
# update_vars.ps1
$Env:github_user_repo = 'darinegan/chocolatey-packages'
$Env:gist_id = 'your-gist-id'
$Env:github_api_key = 'your-api-key'
$Env:au_Push = 'false'  # Set to 'true' for automated pushing
```

This file is ignored by git to keep your credentials private.

## Continuous Integration

The repository can be configured to work with AppVeyor or other CI systems:

- AU can automatically update packages on a schedule
- Test packages before pushing
- Generate update reports and publish to Gists
- Commit and push changes back to the repository

See the [AU AppVeyor documentation][au-appveyor] for setup instructions.

## Package Standards

All packages must follow the [Chocolatey Community Core Team Standards][choco-standards]:

- Use proper semantic versioning
- Include accurate package metadata
- Provide clear installation/uninstallation scripts
- Use checksums for downloaded files
- Include package source URL
- Provide icon URLs from a CDN (not local files)

## Resources

- [Chocolatey Package Documentation](https://docs.chocolatey.org/en-us/create/create-packages)
- [AU Framework](https://github.com/majkinetor/au)
- [AU Plugins](https://github.com/majkinetor/au/blob/master/Plugins.md)
- [Chocolatey Community Core Team Standards][choco-standards]

## Contributing

We welcome contributions! Please read our [Contributing Guide][contributing] before submitting pull requests.

When contributing:
1. Fork the repository
2. Create a feature branch
3. Make your changes following the package standards
4. Test your changes locally
5. Submit a pull request

## License

This repository is licensed under the Apache License 2.0. See [LICENSE.md](LICENSE.md) for details.

[//]: # "References"

[choco-standards]: https://github.com/chocolatey/chocolatey-coreteampackages/blob/master/CONTRIBUTING.md "Chocolatey Community Core Team Standards"
[contributing]: CONTRIBUTING.md "Contributing"
[au-framework]: https://github.com/majkinetor/au "AU Framework"
[au-plugins]: https://github.com/majkinetor/au/blob/master/Plugins.md "AU Plugins"
[au-appveyor]: https://github.com/majkinetor/au/wiki/AppVeyor "AU AppVeyor Setup"
