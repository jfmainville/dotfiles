---
name: work-on
description: Start work on a task - takes a single TASK-ID-branch-name argument, looks up TASK-ID as a ClickUp custom task ID to pull the task's requirements, creates the branch from the default branch (or a specified base), makes the requested changes, commits with a conventional-commit message, and opens a PR back to the default branch. Use when the user says things like "work on NUA-1234-add-login", or asks to begin/kick off a ticket/task.
license: MIT
compatibility: Requires git and gh (GitHub CLI) installed, an authenticated gh session for the current repo, and the ClickUp MCP server connected.
allowed-tools: Bash(git *) Bash(gh *) mcp__clickup__clickup_get_task mcp__clickup__clickup_get_task_comments
argument-hint: <TASK-ID-branch-name> [base-branch]
metadata:
  author: jfmainville
  version: "1.1.0"
  homepage: https://github.com/jfmainville/dotfiles
---

Automate the bookkeeping around starting a task: looking up the task in ClickUp, branch creation, the implementation work it requires, a conventional-commit-formatted commit, and a PR back to the default branch.

## Step 1: Parse Arguments

The user invoked this with: $ARGUMENTS

Expected form: `<TASK-ID-branch-name> [base-branch]`

Only one identifier is passed in — the full branch name — and it already follows this repo's convention of `TASK-ID-branch-name`. Extract the task ID back out of it rather than asking for it separately:

- **TASK-ID**: the leading task/ticket identifier the branch name starts with, always in the form of exactly three letters, a hyphen, and four digits (`AAA-1111`), e.g. `NUA-1234` in `NUA-1234-add-login`. Match that fixed-width leading pattern (`^[A-Za-z]{3}-[0-9]{4}`) to find where the ID ends and the description begins. If the first argument doesn't start with a recognizable `AAA-1111` pattern, stop and ask the user to confirm the task ID rather than guessing. This ID is the task's ClickUp custom ID (see Step 2, below).
- **branch-name** (the full first argument): use it verbatim as the branch name — do not re-slugify or otherwise rewrite it, since the user has already supplied it in its final form.
- **base-branch** (optional second argument): the branch to branch from. If omitted, use the repository's default branch (see Step 2).

The final branch name is exactly the first argument as given:

```
$ARGUMENTS[0]
```

Do not alter it (e.g. don't add extra prefixes like `feature/`, don't reformat casing).

## Step 2: Look Up the Task in ClickUp

Fetch the task's details from ClickUp using the extracted TASK-ID as a custom task ID:

```
mcp__clickup__clickup_get_task with task_id: "<TASK-ID>", include: ["description"]
```

If the task can't be found (wrong ID, wrong workspace, no ClickUp access), stop and ask the user rather than guessing at the task's scope.

Use the returned name, description, and status to understand what the task actually requires — this replaces needing the user to separately describe the work. If a task has open questions or the description is too thin to act on, pull comments too (`mcp__clickup__clickup_get_task_comments`) before asking the user for clarification.

## Step 3: Resolve the Base Branch

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

## Step 4: Make the Changes

Implement whatever work the ClickUp task requires, per its description and comments fetched in Step 2 (plus anything else already discussed in this conversation). If the task's scope is still unclear after reading it, ask the user rather than fabricating work.

Run the project's lint/type-check/tests if available before committing.

## Step 5: Commit

Commit using the conventional commit structure, with **no description/body and no task ID reference** — the branch name already carries the task ID:

```bash
git add <files>
git commit -m "<type>(<scope>): <summary>"
```

- Derive `<type>`, `<scope>`, and `<summary>` from the actual diff, not a generic message.
- Group unrelated changes into separate commits; keep closely related changes together.
- Do not add a co-author trailer.
- Commit as the currently configured git user.

## Step 6: Push and Open the PR

```bash
git push -u origin "$BRANCH_NAME"
```

Open a PR back to the base branch resolved in Step 3, with a standard title and description:

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
