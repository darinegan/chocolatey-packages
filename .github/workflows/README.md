# GitHub Actions Workflows

This repository includes two GitHub Actions workflows for automated package management:

## Workflows

### PR Build (`pr.yml`)
- **Triggered on**: Pull requests to the master branch
- **Purpose**: Test package updates without publishing
- **Actions**: Runs `test_all.ps1` to validate package configurations

### Master Build (`master.yml`)  
- **Triggered on**: 
  - Push to master branch
  - Daily scheduled run at 6:00 AM UTC
- **Purpose**: Update packages and optionally push to Chocolatey
- **Actions**: Runs `update_all.ps1` to check for updates and publish packages

## Required Secrets

Configure the following secrets in your GitHub repository settings:

### Optional Secrets (for enhanced functionality)
- `AU_PUSH`: Set to "true" to enable pushing packages to Chocolatey
- `CHOCOLATEY_API_KEY`: Your Chocolatey API key for publishing packages
- `GIST_ID`: GitHub Gist ID for storing update reports
- `GIST_ID_TEST`: GitHub Gist ID for storing test reports
- `MAIL_USER`: Email address for notifications
- `MAIL_PASS`: Email password for notifications
- `MAIL_SERVER`: SMTP server for notifications  
- `MAIL_PORT`: SMTP port for notifications
- `MAIL_ENABLESSL`: Set to "true" to enable SSL for email

### Automatic Secrets
- `GITHUB_TOKEN`: Automatically provided by GitHub Actions

## Usage

The workflows will automatically run based on their triggers. No manual intervention is required for normal operation.

For testing individual packages locally, use:
```powershell
.\test_all.ps1 -Name "package-name"
```

For updating packages locally, use:
```powershell
.\update_all.ps1 -Name "package-name"
```