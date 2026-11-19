---
name: work-on
description: Start a task from a `TASK-ID-branch-name` argument. Pulls the ClickUp task, branches, implements it, commits, and opens a draft PR. Use for "work on NUA-1234-add-login" or starting a ticket.
license: MIT
compatibility: Requires git, an authenticated gh, and the ClickUp MCP server.
allowed-tools: Bash(git *) Bash(gh *) mcp__clickup__clickup_get_task mcp__clickup__clickup_get_task_comments
argument-hint: <TASK-ID-branch-name> [base-branch]
metadata:
  author: jfmainville
  version: "2.0.0"
  homepage: https://github.com/jfmainville/dotfiles
---

Arguments: $ARGUMENTS (`<branch-name> [base-branch]`)

## 1. Parse

- The branch name is the first argument, used verbatim.
- The task ID is its leading `^[A-Za-z]+-[0-9]+` (e.g. `NUA-1234`). If there is none, ask the user.
- The base is the second argument, or the default branch (`gh repo view --json defaultBranchRef -q .defaultBranchRef.name`, falling back to `git remote show origin`).

## 2. Read the Task

Call `mcp__clickup__clickup_get_task` with the task ID as a custom ID and `include: ["description"]`. Read its comments too when the description is thin. If the task isn't found or its scope stays unclear, ask the user.

## 3. Branch

If `git status` shows uncommitted changes or the branch already exists, ask the user. Otherwise:

```bash
git fetch origin "$BASE" && git checkout "$BASE" && git pull --ff-only origin "$BASE" && git checkout -b "$BRANCH"
```

## 4. Implement

Implement the task following `~/.agents/rules/` (`general.md` and the language files). Run the language file's type-check and tests.

## 5. Commit, Push, and Open the PR

Run the format and lint check from `general.md`, then commit, push, and open a draft PR against the base, following `~/.agents/rules/git.md`. After any later push, update the PR as `git.md` requires. Report the PR URL.
