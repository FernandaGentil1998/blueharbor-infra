# Exercise 9.3 — Automate CI with GitHub Actions

## Objective

Implement a Continuous Integration (CI) pipeline for the BlueHarbor TrackIt application using GitHub Actions. Automate application testing, validate Docker builds, configure branch protection rules, and publish the application image to GitHub Container Registry (GHCR).

## 1. Create the GitHub Actions Workflow

Created the workflow file:

```text
.github/workflows/ci.yml
```

The workflow was configured to run automatically on:

- Push events to the `main` branch when files under `trackit/` or the workflow file are modified.
- Pull requests containing changes under `trackit/`.

The pipeline includes two jobs:

- **test:** installs Python dependencies and executes the automated application tests using pytest.
- **build:** builds the Docker image after the test job succeeds. This job runs on pushes to `main`.

The build job depends on the successful completion of the test job, ensuring that Docker images are only published after the tests pass.

## 2. Configure the Automated Tests

The test job uses:

- Ubuntu as the GitHub Actions runner.
- Python 3.12.
- Dependencies from `trackit/requirements.txt`.
- Pytest for automated testing.

The pipeline installs the dependencies and executes the application test suite.

This provides an automated validation step before changes can be integrated into the main branch.

## 3. Configure the Docker Build and Publish Job

Configured the build job to authenticate with GitHub Container Registry (GHCR) and publish the TrackIt Docker image.

The image is published under:

```text
ghcr.io/fernandagentil1998/trackit
```

The workflow generates two image tags:

- The Git commit SHA, providing an immutable reference to a specific build.
- `latest`, representing the most recently published image.

The build job runs only after the test job succeeds and is triggered by pushes to `main`.

## 4. Test the CI Pipeline with an Intentional Failure

Created a dedicated branch to validate the pipeline's ability to detect failing tests.

Introduced an intentional test failure and opened a pull request.

GitHub Actions executed the workflow and reported a failed test job.

The failure demonstrated that the pipeline correctly identifies unsuccessful tests and prevents the changes from passing the required CI check.

## 5. Restore the Test and Validate a Successful Run

Reverted the intentional test failure and restored the expected test behavior.

Committed the correction and pushed the changes.

GitHub Actions executed the pipeline again:

- The test job completed successfully.
- The Docker build job completed successfully on the push to `main`.
- The application image was published to GHCR.

This confirmed that the pipeline could successfully validate the application and build its Docker image.

## 6. Configure Branch Protection for main

Configured a GitHub repository ruleset to protect the `main` branch.

The ruleset includes:

- Pull requests required before merging.
- No mandatory approvals.
- The `test` status check required before merging.
- Force pushes disabled.
- Branch deletion restricted.
- Merge, squash, and rebase methods allowed.

The required status check ensures that pull requests cannot be merged unless the automated test job succeeds.

## 7. Validate and Merge a Pull Request

Created a pull request to validate the branch protection configuration.

Verified that GitHub required the `test` status check before allowing the merge.

After the required check completed successfully, the pull request was merged.

This validated the repository's CI enforcement and protected branch workflow.

## 8. Verify the Docker Image in GHCR

Verified the published TrackIt package in GitHub Container Registry.

Package:

```text
ghcr.io/fernandagentil1998/trackit
```

The package was successfully published and made publicly accessible.

Repository package page:

https://github.com/users/FernandaGentil1998/packages/container/trackit

## Results

The GitHub Actions CI pipeline was successfully implemented and tested.

The workflow automated application testing, enforced successful test execution before Docker image publication, and published the resulting image to GitHub Container Registry.

The repository's `main` branch was protected through a ruleset requiring pull requests and successful CI checks.

An intentional test failure was used to validate the pipeline's failure handling, followed by a successful test run and Docker image publication.

**Key takeaway:** Continuous Integration automates software validation and build processes, while branch protection rules help maintain code quality and prevent untested changes from being merged into the main branch.

The next stage is to deploy the containerised application using Kubernetes.