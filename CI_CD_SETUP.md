# CI/CD Pipeline for DevPropertyHub-MVP

This document explains the Continuous Integration and Continuous Deployment (CI/CD) pipeline set up for the DevPropertyHub-MVP Flutter application.

## Overview

The CI/CD pipeline is implemented using GitHub Actions and automatically runs on:
- Every push to the `main`, `master`, and `develop` branches
- Every pull request targeting these branches

## Pipeline Jobs

The pipeline consists of three main jobs:

### 1. Test Job

This job runs on every commit and PR and performs the following tasks:
- Checks out the code
- Sets up Flutter environment
- Installs dependencies
- Verifies code formatting
- Runs static code analysis
- Executes all tests (unit, widget, and integration)
- Collects and uploads code coverage information

### 2. Android Build Job

This job runs after the Test job passes and:
- Builds a release APK of the application
- Makes the APK available as a downloadable artifact

### 3. Web Build Job

This job runs after the Test job passes and:
- Enables web support
- Builds a release web version of the application
- Makes the web build available as a downloadable artifact

## Benefits

- **Automated Testing**: Ensures all tests pass on every commit
- **Code Quality**: Enforces code formatting and static analysis
- **Early Bug Detection**: Catches issues before they reach production
- **Build Automation**: Automatically generates release builds
- **Team Confidence**: Provides confidence that code changes don't break existing functionality

## Setting Up Code Coverage Reports

To get detailed code coverage reports:

1. Create a [Codecov](https://codecov.io/) account
2. Link your GitHub repository
3. Add your Codecov token as a GitHub secret named `CODECOV_TOKEN`

## Viewing Test Results

- Test results are visible in the GitHub Actions tab of your repository
- Failed tests will cause the workflow to fail, and detailed logs will be available
- Code coverage reports will be available on Codecov once set up

## Customizing the Pipeline

To modify the CI/CD pipeline:

1. Edit the `.github/workflows/flutter_ci.yml` file
2. Commit and push your changes
3. The updated workflow will be used for subsequent runs

## Handling Failures

If the CI pipeline fails:

1. Check the GitHub Actions logs to identify the issue
2. Fix the failing tests or issues in your local environment
3. Commit and push the fixes
4. The pipeline will automatically run again

## Notes for African Market Deployment

- The low-bandwidth mode is fully tested in the pipeline
- APK size optimization is essential for the target market
- Consider testing on lower-end devices commonly used in the target market
