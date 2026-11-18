---
name: work-on
description: Start work on a task - takes a single TASK-ID-branch-name argument, looks up TASK-ID as a ClickUp custom task ID to pull the task's requirements, creates the branch from the default branch (or a specified base), makes the requested changes, commits with a conventional-commit message, and opens a draft PR back to the default branch. Use when the user says things like "work on NUA-1234-add-login", or asks to begin/kick off a ticket/task.
license: MIT
compatibility: Requires git and gh (GitHub CLI) installed, an authenticated gh session for the current repo, and the ClickUp MCP server connected.
allowed-tools: Bash(git *) Bash(gh *) mcp__clickup__clickup_get_task mcp__clickup__clickup_get_task_comments
argument-hint: <TASK-ID-branch-name> [base-branch]
metadata:
  author: jfmainville
  version: "1.18.0"
  homepage: https://github.com/jfmainville/dotfiles
---

Automate the bookkeeping around starting a task: looking up the task in ClickUp, branch creation, the implementation work it requires, a conventional-commit-formatted commit, and a PR back to the default branch.

## Step 1: Parse Arguments

The user invoked this with: $ARGUMENTS

Expected form: `<TASK-ID-branch-name> [base-branch]`

Only one identifier is passed in — the full branch name — and it already follows this repo's convention of `TASK-ID-branch-name`. Extract the task ID back out of it rather than asking for it separately:

- **TASK-ID**: the leading task/ticket identifier the branch name starts with, in the form of letters, a hyphen, and digits (`<TASK-ID>-short-description`), e.g. `NUA-1234` in `NUA-1234-add-login` or `NUA-01` in `NUA-01-add-nextjs`. Match the leading pattern (`^[A-Za-z]+-[0-9]+`) to find where the ID ends and the description begins. If the first argument doesn't start with a recognizable task ID, stop and ask the user to confirm the task ID rather than guessing. This ID is the task's ClickUp custom ID (see Step 2, below).
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

Follow the coding rules while implementing: `~/.agents/rules/general.md`, then the rules file for each language you touch (`lua.md`, `python.md`, `typescript.md`, `scss.md`, `shell.md`, `terraform.md`, `go.md` in the same folder). The project's own `AGENTS.md`/`CLAUDE.md`, tool configs, and existing code win when they disagree. Only read a rules file when its content isn't already in your context.

Run the type-check and test commands from each language's rules file (or the project's own scripts) before committing.

## Step 5: Commit

Before committing, run the Neovim format and lint check from the **Formatting and Linting** section of `~/.agents/rules/general.md` (`nvim --headless -c "luafile ~/.agents/scripts/nvim-check.lua" <files>`), or the language file's formatter and linter when Neovim isn't available, on every modified file. Fix every issue you introduced and run it again until it passes.

Commit following the **Commits** and **Author and Attribution** sections of `~/.agents/rules/git.md`.

## Step 6: Push and Open the PR

Push the branch and open a draft PR back to the base branch resolved in Step 3, following the **Pull Requests** section of `~/.agents/rules/git.md`. The title ends with the task ID from Step 1.

## Step 7: Keep the PR Up to Date After Each Commit

Every time a further commit is pushed to the branch (e.g. follow-up fixes or review changes), always update the PR title and body right away, as the **Keeping it up to date** rules in `~/.agents/rules/git.md` describe.

Report the PR URL back to the user when done.
