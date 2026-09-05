---
name: work-on
description: Start work on a task - takes a single TASK-ID-branch-name argument, creates that branch from the default branch (or a specified base), makes the requested changes, commits with a conventional-commit message, and opens a PR back to the default branch. Use when the user says things like "work on TASK-123-add-login", or asks to begin/kick off a ticket/task.
license: MIT
compatibility: Requires git and gh (GitHub CLI) installed, and an authenticated gh session for the current repo.
allowed-tools: Bash(git *) Bash(gh *)
argument-hint: <TASK-ID-branch-name> [base-branch]
metadata:
  author: jfmainville
  version: "1.0.0"
  homepage: https://github.com/jfmainville/dotfiles
---

Automate the bookkeeping around starting a task: branch creation, the implementation work already discussed in the conversation, a conventional-commit-formatted commit, and a PR back to the default branch.

## Step 1: Parse Arguments

The user invoked this with: $ARGUMENTS

Expected form: `<TASK-ID-branch-name> [base-branch]`

Only one identifier is passed in — the full branch name — and it already follows this repo's convention of `TASK-ID-branch-name`. Extract the task ID back out of it rather than asking for it separately:

- **TASK-ID**: the leading task/ticket identifier the branch name starts with, always in the form of exactly three letters, a hyphen, and four digits (`AAA-1111`), e.g. `ABC-1234` in `ABC-1234-add-login`. Match that fixed-width leading pattern (`^[A-Za-z]{3}-[0-9]{4}`) to find where the ID ends and the description begins. If the first argument doesn't start with a recognizable `AAA-1111` pattern, stop and ask the user to confirm the task ID rather than guessing.
- **branch-name** (the full first argument): use it verbatim as the branch name — do not re-slugify or otherwise rewrite it, since the user has already supplied it in its final form.
- **base-branch** (optional second argument): the branch to branch from. If omitted, use the repository's default branch (see Step 2).

The final branch name is exactly the first argument as given:

```
$ARGUMENTS[0]
```

Do not alter it (e.g. don't add extra prefixes like `feature/`, don't reformat casing).

## Step 2: Resolve the Base Branch

If no `base-branch` was given, determine the repo's default branch:

```bash
gh repo view --json defaultBranchRef -q .defaultBranchRef.name
```

Fall back to `git remote show origin | sed -n '/HEAD branch/s/.*: //p'` if the `gh` call fails (e.g. no GitHub remote).

Before switching branches, run `git status`. If there are uncommitted changes, stop and ask the user whether to stash them, include them in the new branch, or abort — do not guess.

Update the base branch to the latest remote state and branch off it:

```bash
git fetch origin "$BASE_BRANCH"
git checkout "$BASE_BRANCH"
git pull --ff-only origin "$BASE_BRANCH"
git checkout -b "$BRANCH_NAME"
```

If a local branch with `$BRANCH_NAME` already exists, stop and ask the user how to proceed (reuse it, or pick a different name) rather than overwriting it.

## Step 3: Make the Changes

Implement whatever work the task requires, as already described in the conversation. If the task's scope hasn't actually been described yet (this skill was invoked with only bookkeeping details and no actual task description), ask the user what changes to make before proceeding — don't fabricate work.

Run the project's lint/type-check/tests if available before committing.

## Step 4: Commit

Commit using the conventional commit structure, with **no description/body and no task ID reference** — the branch name already carries the task ID:

```bash
git add <files>
git commit -m "<type>(<scope>): <summary>"
```

- Derive `<type>`, `<scope>`, and `<summary>` from the actual diff, not a generic message.
- Group unrelated changes into separate commits; keep closely related changes together.
- Do not add a co-author trailer.
- Commit as the currently configured git user.

## Step 5: Push and Open the PR

```bash
git push -u origin "$BRANCH_NAME"
```

Open a PR back to the base branch resolved in Step 2, with a standard title and description:

```bash
gh pr create \
  --base "$BASE_BRANCH" \
  --title "<type>(<scope>): <summary>" \
  --body "$(cat <<'EOF'
## Summary
- <1-3 bullet points describing the change>

## Test plan
- [ ] <how this was/should be verified>

Task: <TASK-ID>
EOF
)"
```

- The PR title mirrors the commit summary (conventional commit style, no task ID in the title).
- The PR description references the task ID on its own trailing line — unlike the commit, the PR body is the right place for that traceability.
- If there are multiple commits covering distinct concerns, summarize all of them in the Summary bullets.

Report the PR URL back to the user when done.
