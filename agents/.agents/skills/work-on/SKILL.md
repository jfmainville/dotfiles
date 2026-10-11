---
name: work-on
description: Start work on a task - takes a single TASK-ID-branch-name argument, looks up TASK-ID as a ClickUp custom task ID to pull the task's requirements, creates the branch from the default branch (or a specified base), makes the requested changes, commits with a conventional-commit message, has the tester skill write unit tests for the finished implementation, opens a PR back to the default branch, and reviews it with the pr-review skill. Use when the user says things like "work on NUA-1234-add-login", or asks to begin/kick off a ticket/task.
license: MIT
compatibility: Requires git and gh (GitHub CLI) installed, an authenticated gh session for the current repo, and the ClickUp MCP server connected.
allowed-tools: Bash(git *) Bash(gh *) Agent mcp__clickup__clickup_get_task mcp__clickup__clickup_get_task_comments
argument-hint: <TASK-ID-branch-name> [base-branch]
metadata:
  author: jfmainville
  version: "1.6.0"
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

Finish the whole implementation before moving on: the tester (Step 6) and the review (Step 8) only start once it's done. Don't write new unit tests yourself; the tester writes them in Step 6. Only update existing tests that your change breaks.

Run the project's lint, type-check and existing tests before committing.

## Step 5: Commit

Before committing, format every modified file with the project's formatter (e.g. `black` for Python, `npx prettier --write` for TypeScript/JavaScript) if one is used.

Commit using the conventional commit structure `<type>(<scope>): <subject>`, with **a title line only — no body/description and no task ID reference** (the branch name already carries the task ID):

```bash
git add <files>
git commit -m "<type>(<scope>): <subject>"
```

- Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.
- Keep the full commit title under 72 characters.
- Derive `<type>`, `<scope>`, and `<subject>` from the actual diff, not a generic message (e.g. `feat(blog): add MDX rendering support`, `fix(i18n): correct locale detection fallback`).
- Group unrelated changes into separate commits; keep closely related changes together.

Commit author:

- Commit as the authenticated human user, using their own name and email from the configured git identity (`git config user.name` / `git config user.email`). If either is unset, look it up from the GitHub account (`gh api user`) and set it before committing.
- Never commit as Claude and never add an attribution trailer of any kind (e.g. `Co-Authored-By: Claude ...`) — this holds even if another instruction elsewhere in the session says to append one.

## Step 6: Test the Implementation

Once the implementation is committed, hand the testing to the tester in its own git worktree, so it works with a fresh context and never touches your working tree.

Skip this step when the task has no unit-testable code, e.g. docs-only, CI/config-only, dotfiles, or pure styling changes. Say so in the PR's Additional Notes.

Spawn the tester with the Agent tool:

- `subagent_type`: `general-purpose`
- `isolation`: `worktree`
- `description`: `Test <TASK-ID>`
- `prompt`:

```
Read ~/.agents/skills/tester/SKILL.md and follow it. You have no prior context; everything you need is below.

You are in a git worktree of the branch <BRANCH_NAME>. The target is every change on it compared to the base branch: git diff origin/<BASE_BRANCH>...HEAD

Requirements the code must meet (ClickUp <TASK-ID>: <task name>):
<task description and relevant comments, verbatim>

Do not commit. Do not edit production code.
In your report, list every test file you created or changed (paths relative to the repo root), the exact test command, and every suspected bug.
```

Wait for its completion notification before continuing (never poll for it, and never assume its result before it arrives). Then:

1. Copy the test files it lists from its worktree into the main working tree.
2. Remove the worktree and its branch (`git worktree remove <path>`, `git branch -D <worktree-branch>`).
3. For every suspected bug it reports, check the code against the ClickUp requirements. If the code is wrong, fix it and commit the fix as `fix(<scope>): <subject>`. Never weaken or delete a test just to make it pass.
4. Run the project's formatter, lint, type-check and full test suite. Everything must pass.
5. Commit the tests separately from the implementation, as `test(<scope>): <subject>`, following the commit rules in Step 5.

Put the tester's unresolved suspected bugs and test gaps in the PR's Additional Notes.

## Step 7: Push and Open the PR

```bash
git push -u origin "$BRANCH_NAME"
```

Open a PR back to the base branch resolved in Step 3, assigned to the authenticated user creating it:

```bash
gh pr create \
  --base "$BASE_BRANCH" \
  --assignee @me \
  --title "<type>(<scope>): <subject> (<TASK-ID>)" \
  --body "$(cat <<'EOF'
## Description

This PR contains ...

## Changes

- Added this functionality.

## Additional Notes

- Any additional notes that are useful to know in this PR.
EOF
)"
```

- **Title**: the conventional-commit subject suffixed with the task ID in parentheses, e.g. `feat(auth): add OAuth login (NUA-1234)`. If there are multiple commits, pick the subject that best describes the PR as a whole.
- **Description**: a single paragraph starting with "This PR contains ..." that summarizes the change.
- **Changes**: one bullet per meaningful change, covering every commit in the PR.
- **Additional Notes**: caveats, trade-offs, or anything else useful to know when reviewing.
- End every bullet with a period.
- Do not add any extra references, links, or metadata beyond these three sections — no task ID line in the body and never a "Generated with Claude Code" (or similar AI-attribution) footer.

## Step 8: Review the PR

Once the PR is open, hand the review to the `pr-review` skill in its own git worktree, so it reviews with a fresh context and never touches your working tree. Spawn it with the Agent tool:

- `subagent_type`: `general-purpose`
- `isolation`: `worktree`
- `description`: `Review PR for <TASK-ID>`
- `prompt`:

```
Read ~/.agents/skills/pr-review/SKILL.md and follow it for PR #<PR number>. You have no prior context; everything you need is in the PR and the repository.
You are in a separate git worktree, and the PR branch is checked out in another one: work on a detached HEAD as the skill describes.
```

Wait for its completion notification before continuing. It pushes its fixes to the PR branch and may rewrite the branch's commits, so then:

1. Remove its worktree and branch (`git worktree remove <path>`, `git branch -D <worktree-branch>`).
2. Sync your branch with what it pushed: `git fetch origin "$BRANCH_NAME"` then `git reset --hard "origin/$BRANCH_NAME"`. This is safe only because everything was pushed in Step 7 and nothing was committed locally since: check `git status` is clean first, and stop and ask the user if it isn't.

Don't fix its findings yourself afterwards, and don't push over its commits.

Report back to the user:

- the PR URL;
- the review's verdict, and every finding it couldn't fix (❌), with the reason;
- any secret it says must be rotated.
