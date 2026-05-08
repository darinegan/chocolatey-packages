## Automatic Folder

This is where you put your Chocolatey packages that are automatically packaged up by the [Chocolatey AU](https://community.chocolatey.org/packages/chocolatey-au) framework (the maintained successor to `majkinetor/au`).
Chocolatey AU works with packages without automatic package tokens necessary. So you can treat the packages as normal.

Execute `update_all.ps1` in the repository root to run the [Chocolatey AU](https://community.chocolatey.org/packages/chocolatey-au) updater with default options.

To fully setup all the features ensure you perform the steps in the [setup/README.md](../setup/README.md#automatic-updater-chocolatey-au)

To get the packages that implement a Chocolatey AU updater run `Get-AUPackages` or `lsau` in this directory.

**NOTE:** Ensure when you are creating packages for Chocolatey AU, you don't use `--auto` as the packaging files should be normal packages. Chocolatey AU doesn't need the tokens to do replacement.

