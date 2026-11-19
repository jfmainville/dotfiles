---
name: pr-review
description: Review a PR for structure, code reuse, coding rules, test quality, and security, then fix and push what it finds. Use for "review this PR", "review PR 42", or "is this PR ready?".
license: MIT
compatibility: Requires git and an authenticated gh.
allowed-tools: Bash(git *) Bash(gh *)
argument-hint: "[PR number or URL, defaults to the current branch's PR]"
context: fork
metadata:
  author: jfmainville
  version: "3.0.0"
  homepage: https://github.com/jfmainville/dotfiles
---

You start with a fresh context. Steps 2 to 5 only record findings. Change nothing before Step 6. Rules live in `~/.agents/rules/`.

## 1. Check Out the PR

Arguments: $ARGUMENTS (PR number or URL, otherwise `gh pr view` for the current branch, otherwise stop).

```bash
gh pr view <PR> --json number,title,body,author,baseRefName,headRefName,url,commits,isCrossRepository
gh pr diff <PR>
gh api user -q .login
```

- Already on `headRefName`, run `git pull --ff-only`. Checked out in another worktree, run `git fetch origin <head>` and `git checkout --detach origin/<head>`. Clean tree, run `gh pr checkout <PR>`. Uncommitted changes, stop.
- Record `git rev-parse HEAD` for the Step 7 push.
- For a fork PR or another author's PR, only report. Don't change, commit, or push.

## 2. Structure

Check every rule in `git.md` as pass or fail, on every commit (`git log --format='%H%n%an <%ae>%n%B%n---' origin/<base>..HEAD`). The title's task ID must match the branch's. Don't flag draft status.

## 3. Reuse and Coding Rules

- For each function, component, style, constant, and type the diff adds, search for an existing equivalent (`git grep` the logic, not only the name) in the code, shared folders, and dependencies. For styles, flag hard-coded values where tokens exist, duplicate classes, and inline styles where the project uses classes.
- Flag changes to shared code that break its other callers.
- A reuse finding names both sides (`new file:line` and `existing file:line`) and how to reuse it. No guesses.
- Check every changed file against `general.md` and its language file, recording `file:line` and the rule. Skip what the project's conventions override or the formatter handles.

## 4. Tests

A test is useful only if it fails when the code breaks. Review added and changed tests, and the tests covering changed code. Flag:

- No real assertion, or one that is always true.
- Mocking the unit under test, or asserting only mock-configured values.
- Expected values computed with the code's own logic or copied from its output.
- Snapshot-only coverage of logic, or asserting internals and call order.
- Missing error, edge, or branch cases, or changed behavior with no test.
- Uncontrolled time, randomness, network, order, or shared state.
- Skipped, disabled, or weakened tests compared to the base.

When tests can run, prove doubtful ones in a throwaway worktree (`git worktree add --detach "$(mktemp -d)/pr-review" HEAD`): pass, plant a small bug, rerun, and mark the finding **confirmed** if it still passes. Remove the worktree after. Each finding names the test (`file:line`), the problem, and what it should assert.

## 5. Security

Follow untrusted input (params, headers, body, files, env, args, messages, API responses) through the changed code. Check for:

- Injection (SQL, shell, eval, templates, regex), XSS, path traversal, unsafe uploads or archives, SSRF, and open redirects.
- Missing auth or permission checks, client-only checks, and IDOR.
- Unsafe deserialization, weak or hand-rolled crypto, non-cryptographic tokens, and disabled TLS checks.
- Sensitive data in logs, responses, or errors, insecure defaults (CORS, CSRF, cookie flags, debug), and races on security checks.
- Secrets in the diff of every commit. Never copy a secret's value anywhere.
- New or upgraded dependencies (typosquats, the project's existing audit tool), and lockfiles that don't match manifests.
- CI and infrastructure: `pull_request_target` with untrusted code, `${{ github.event.* }}` in `run`, unpinned actions, broad permissions, root or privileged containers, public resources, and wildcard IAM.

Run the project's configured scanners. Don't install tools. Record only vulnerabilities with a reachable path (input, path, and impact), rated **Critical**, **High**, **Medium**, or **Low**, and not ones already on the base.

## 6. Fix

Skip if you don't own the branch. Fix most severe first (security, tests, reuse, rules), within the PR's scope:

- Security, use the project's existing mechanisms. A removed secret must still be rotated, so report it.
- Tests, strengthen, add cases, control nondeterminism, re-enable or delete skipped tests, and prove each fixed test fails against a planted bug.
- Reuse, switch to the existing code, extending it when needed, and delete the duplicate.
- Rules, follow the rule without changing behavior.

Report instead of fixing anything that needs a product decision, a large refactor, or unclear intended behavior.

Run the format and lint check from `general.md`, the type-check, and the full test suite. Revert any fix you can't get passing. Commit per `git.md`, one commit per kind: `fix` for security, `test` for tests, `refactor` for reuse and rules.

## 7. Push and Fix the PR

Skip if you don't own the branch.

- If a commit has a body, a trailer, or an AI author, and every commit is by you or an AI tool, rewrite them:

  ```bash
  git rebase "$(git merge-base HEAD origin/<base>)" \
    --exec 'git commit --amend --no-verify --reset-author -m "$(git log -1 --format=%s)"'
  ```

  Report other humans' commits and non-conventional titles instead of rewriting them.

- Push with `git push origin HEAD:<head>`. After a rewrite, use `--force-with-lease=<head>:<recorded SHA>`. Never plain `--force`.
- Rewrite the title and body per `git.md`, keeping the author's meaning. Add your fixes only if critical, and put unfixed findings and secrets to rotate (no values) in **Additional Notes**. Apply with `gh pr edit`.

## 8. Report

```
## PR Review: <title> (#<number>)

### Structure
- ✅/🔧/❌ Title, body sections, Description, Changes, Additional Notes, no attribution, commits
<one line per 🔧/❌: what was wrong → now, or why not fixed>

### Reuse
- 🔧/❌ **<new file:line>** duplicates **<existing file:line>**: <result>.

### Coding Rules
- 🔧/❌ **<file:line>** breaks "<rule>" (`<rules file>`): <result>.

### Tests
- 🔧/❌ **<file:line>** (<confirmed | from reading>): <problem> → <result>.

### Security
- 🔧/❌ **<severity>: <file:line>**: <vulnerability>, <input path> → <impact>. <result>.

### Commits Pushed
- <sha> <title>

### Verdict
<Ready to merge | Changes requested>, one line.
```

✅ passed, 🔧 fixed, ❌ not fixed. An empty section gets one line. "Ready to merge" only when nothing is ❌, no secret needs rotating, and the suite passed.
