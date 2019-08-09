# Git Guide

## Naming conventions

All names, including repositories, branches and labels should use hyphens, \(not snake or camel case\).

Example:

civilcode-website

## Branch names

Use the following template:

    {issue-type}/{module}/{description}

Example:

    ability/payouts/paying-out-a-merchant

## Branch Management

The strategy for merging is different based on the PR being merged:

### A. Squash and merge

* "feature" tasks
* bug fixes
* chores

### B. Create a merge commit

* "feature" modules
* "feature" abilities

## Rebase vs Merging master

Branches pushed to a shared repository are never rebased - only merge upstream branches.

## Branching of an existing feature branch

If a feature branch is pending review and you wish to branch off from that branch for a new
feature follow this strategy to avoid merge conflicts:

1. branch from `master` -> `your_new_branch`
2. squash merge `branch_pending_review` into `your_new_branch`

When `branch_pending_review` is merged into `master`, rebase `your_new_branch` with `master`.

## Forking

If a repository from a third-party needs to be forked for a client:

1. create the branch with the application name, e.g. `acme-platform`.
2. if you wish to submit a PR to the third-party, do that in another branch.

Never make a reference to a third-party repository directly, always create a fork in the
`civilcode` repository and reference that as the dependency. Try to resolve the fork and branch
as soon as possible, i.e. PR to the third-party, update dependency when new release is available.
