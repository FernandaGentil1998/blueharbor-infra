# Lab 09 — Exercise 9.3: Build a CI Pipeline with GitHub Actions

## Objective

Build an automated CI pipeline using GitHub Actions to test the TrackIt application, validate changes through pull requests, and automatically build and publish Docker images to GitHub Container Registry (GHCR).

## 1. Create the GitHub Actions Workflow

Created the workflow file `.github/workflows/ci.yml` in the root of the repository.

Configured the workflow to run under two events:

- **Push to main:** execute the automated tests and build the Docker image when relevant application or workflow files change.
- **Pull request:** execute the automated tests when files inside the TrackIt application directory are modified.

The workflow contains two jobs:

- **test:** installs the Python dependencies and pytest, then executes the automated tests.
- **build:** builds and publishes the Docker image to GHCR, but only after the test job succeeds and when the event is a push to the main branch.

The Docker image is published with two tags: `latest` and the commit SHA.

## 2. Fix the Docker Build Configuration

The first workflow execution revealed that the GitHub Actions runner could not find the Dockerfile inside the TrackIt directory.

The Dockerfile and Docker Compose configuration existed in the development environment but had not yet been committed to the repository.

Added the missing files and synchronized the local repository with the remote branch using Git fetch and rebase before pushing the changes.

After correcting the repository contents, the workflow executed successfully, including the Docker build and image publication.

## 3. Test the CI Pipeline with an Intentional Failure

Created a separate branch named `test/break-ci` to test whether the pipeline could detect an application test failure.

Modified the health-check test by deliberately changing the expected response from `ok` to `ko`.

Executed the test locally and confirmed that it failed as expected.

Committed and pushed the intentional failure, then opened Pull Request #1, targeting the `main` branch.

GitHub Actions detected the failure in the `test` job. The dependent `build` job did not execute, confirming that the pipeline correctly prevents the build from proceeding when tests fail.

## 4. Restore the Test and Validate the Successful Run

Restored the expected health-check response to `ok` and executed the test locally again.

The test passed successfully.

Added a comment documenting the health-check test expectation to ensure that the pull request contained a change and triggered a new workflow execution.

Committed and pushed the correction to the same branch.

The new GitHub Actions execution completed successfully:

- The `test` job succeeded.
- The `build` job was skipped, as expected for a pull request.

This confirmed that the pipeline correctly distinguishes between pull request and push events.

## 5. Configure Branch Protection for main

Created an active branch ruleset in the repository settings to protect the `main` branch.

Configured the ruleset with the following requirements:

- Target the default branch, `main`.
- Require a pull request before merging.
- Set the required number of approving reviews to zero.
- Require status checks to pass before merging.
- Select the `test` job as the required status check.
- Block force pushes.
- Restrict branch deletions.
- Keep Merge, Squash, and Rebase as allowed merge methods.

Left the bypass list empty.

The `test` check was selected as mandatory because it validates the application changes. The `build` job was not selected because it is intentionally skipped on pull requests.

During validation, GitHub initially displayed an additional review requirement. Reviewed and updated the ruleset to remove the approval requirement while keeping the mandatory CI check.

## 6. Validate and Merge the Pull Request

Returned to Pull Request #1 and verified the final merge status.

The checks reported the following results:

- **ci / test (pull_request):** successful and required.
- **ci / build (pull_request):** skipped, as expected.
- **Vercel deployment:** successful.
- **Vercel Preview Comments:** successful.

GitHub confirmed that all checks had passed and that there were no merge conflicts.

Merged Pull Request #1 into the `main` branch.

This demonstrated that the branch protection rules correctly require the automated test to pass before changes can be merged.

## 7. Verify the CI Pipeline After the Merge

Opened the GitHub Actions tab and checked the workflow execution triggered by the merge into `main`.

Both jobs completed successfully:

- **test:** executed the automated tests and passed.
- **build:** built and published the Docker image to GHCR.

Unlike pull request executions, the push to `main` triggered both jobs.

## 8. Verify the Docker Image in GitHub Container Registry

Opened the repository's GitHub Packages section and accessed the TrackIt container package.

Confirmed that the latest image versions were published successfully.

The package displayed the following tags:

- `latest`
- `47318cd60de8346d920247df7918cef5826f6ef0`
- `0e0d757a76a0213c9f553e6193013515cd95779c`

The latest workflow execution published the `latest` tag and the image tagged with commit SHA `47318cd60de8346d920247df7918cef5826f6ef0`.

This confirmed that the Docker image was automatically published after the successful CI execution on `main`.

## 9. Results and Validation

The exercise successfully demonstrated:

- Automated application testing with GitHub Actions.
- Detection of an intentional test failure.
- Prevention of the build job when tests fail.
- Successful test execution after correcting the failure.
- Branch protection through an active ruleset.
- Mandatory CI validation before merging pull requests.
- Successful merge after all required checks passed.
- Automatic Docker image building and publication to GHCR.
- Image versioning using both `latest` and commit SHA tags.

**Result:** Exercise 9.3 completed successfully. The CI pipeline, pull request validation, branch protection, and automatic Docker image publication were all tested and verified.

**Next exercise:** Exercise 9.4 — Kubernetes Deployment, Self-Healing, Scaling, Rolling Updates, and Rollbacks.
