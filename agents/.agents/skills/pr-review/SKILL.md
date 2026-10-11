---
name: pr-review
description: Review a pull request for PR structure, code reuse, test quality, and security, and fix what it finds - checks that the PR title, body (Description, Changes, Additional Notes), and commits follow the required format with no co-author or AI attribution, that the changes reuse existing functions, components, and styles instead of duplicating them, that the tests actually catch bugs instead of being useless, and that the changes introduce no security vulnerabilities, then commits and pushes the fixes to the PR branch. Use when the user says things like "review this PR", "review PR 42", "check my PR before merge", or "is this PR ready?".
license: MIT
compatibility: Requires git and gh (GitHub CLI) installed, and an authenticated gh session for the current repo.
allowed-tools: Bash(git *) Bash(gh *)
argument-hint: "[PR number or URL — defaults to the PR for the current branch]"
context: fork
metadata:
  author: jfmainville
  version: "2.3.0"
  homepage: https://github.com/jfmainville/dotfiles
---

# PR Review

You review a pull request against four sets of rules: **PR structure**, **reuse of existing code**, **test quality**, and **security**, and you fix what you find directly on the PR branch. You start with a fresh context, so everything you need comes from the arguments and the repository.

Steps 2 to 5 only find problems; don't change anything until Step 6, so the fixes are planned with every finding in view.

## Step 1: Resolve the PR and Check Out Its Branch

The user invoked this with: $ARGUMENTS

If a PR number or URL is given, use it. Otherwise use the PR for the current branch (`gh pr view`). If there is none, stop and say so.

Fetch everything you need:

```bash
gh pr view <PR> --json number,title,body,author,baseRefName,headRefName,url,commits,isCrossRepository
gh pr diff <PR>
gh api user -q .login
```

You need the PR's branch checked out to fix it:

- If the current branch is already `headRefName`, pull its latest state (`git pull --ff-only`).
- If the PR branch is already checked out in another worktree (`git worktree list`), work on a detached HEAD at the PR's head: `git fetch origin <headRefName>` then `git checkout --detach origin/<headRefName>`.
- Otherwise, if the working tree is clean, run `gh pr checkout <PR>`.
- If the working tree has uncommitted changes, stop and report that the review needs a clean working tree. Never stash or discard someone's changes.

Record the PR head's SHA now (`git rev-parse HEAD`): Step 7 uses it to push safely.

If the PR comes from a fork (`isCrossRepository` is true), or its author isn't the authenticated user, you don't own the branch: do Steps 2 to 5 and report, but don't change, commit, or push anything.

## Step 2: Check the PR Structure

Every rule below is a pass/fail check. Record each failure with what was found and what is expected.

**Title**
- Follows `<type>(<scope>): <subject> (<TASK-ID>)`, e.g. `feat(auth): add OAuth login (NUA-1234)`.
- `<type>` is one of `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.
- The task ID matches the one the branch name starts with (`^[A-Za-z]+-[0-9]+`), if the branch has one.

**Body**
- Contains exactly these three sections, in this order, and no others:
  ```
  ## Description
  ## Changes
  ## Additional Notes
  ```
- **Description** is a single paragraph that starts with "This PR contains".
- **Changes** is a bullet list with one bullet per meaningful change, and covers every commit in the PR (compare against the commit list and the diff).
- **Additional Notes** is a bullet list.
- Every bullet ends with a period.
- No colon (`:`) or semicolon (`;`) anywhere in the body, including inside bullets and code. When fixing the body in Step 7, rephrase the sentence rather than just deleting a colon, and replace each semicolon with a comma.
- No task ID line, extra links, or metadata in the body.
- No AI attribution of any kind: no "Generated with Claude Code" (or any other tool) footer, no 🤖 line, no `Co-Authored-By` line.

**Commits** (check every commit in the PR: `git log --format='%H%n%an <%ae>%n%B%n---' origin/<baseRefName>..HEAD`)
- Title follows `<type>(<scope>): <subject>`, under 72 characters, with a valid type.
- Title line only: no body.
- No `Co-Authored-By:` trailer, and no other attribution trailer.
- The author is a human, not an AI tool or bot account.

## Step 3: Check for Reuse of Existing Code

For every new function, class, hook, component, style, constant, and type the diff **adds**, look for an existing equivalent in the codebase before accepting it:

- **Functions and helpers:** search for similar names and for the same logic (`git grep` the key operations, not just the name). Also check the project's dependencies: a hand-written helper that a library already in `package.json` / `pyproject.toml` / `go.mod` provides is a finding.
- **Components:** look in the project's shared component folders (e.g. `components/`, `ui/`, `shared/`, `common/`) for a component that already renders the same thing or can with an existing prop/variant. A near-copy of an existing component is a finding: it should be reused or extended.
- **Styles:** flag
  - hard-coded colors, spacing, font sizes, radii, shadows, or breakpoints where the project defines tokens/variables (CSS custom properties, Tailwind theme, SCSS variables, theme objects);
  - new CSS classes or styled components that duplicate an existing class, utility, or styled component;
  - inline styles where the project uses classes or utilities.
- **Constants and types:** duplicated enums, magic strings, or type definitions that already exist.

Also flag the reverse: the PR changes an existing shared function, component, or style in a way that breaks or alters its other callers (search for them).

Only record a reuse finding when you found the concrete existing code. Each finding must name both sides: the new code (`file:line`) and the existing code it duplicates (`file:line`), plus how to reuse it. "There might be a helper for this" is not a finding.

## Step 4: Check That the Tests Aren't Useless

A test is useful only if it would fail when the code it covers is broken. Review every test the PR adds or changes, and the tests covering the code it changes.

**Read the tests and flag:**
- **No real assertion:** the test only calls the code, only asserts it didn't throw, or asserts something always true (`expect(true)`, `assert result is not None` on a value that can never be `None`).
- **Testing the mock:** the unit under test is itself mocked, or the assertion only checks a value the test configured on a mock.
- **Tautologies:** the expected value is computed with the same logic as the code under test, or copied from the current output without checking that it's right.
- **Snapshot-only coverage** of logic that should have explicit assertions.
- **Implementation coupling:** asserts on private internals, call counts or call order that don't matter to the behavior, so the test breaks on refactors but not on bugs.
- **Missing cases:** only the happy path is tested, when the code handles errors, edge values (empty, zero, null, max) or branches that have no test.
- **Nondeterminism:** depends on real time, randomness, network, order of execution, or shared state without controlling it.
- **Skipped or disabled:** `.skip`, `xfail`, `t.Skip`, commented-out tests, or assertions removed/weakened compared to the base branch to make them pass.
- **Untested changes:** new or changed behavior in the PR with no test at all, when the project has tests for comparable code.

**Prove it when you can.** If the project's tests can run locally, check the doubtful tests by breaking the code on purpose, in a throwaway worktree so the PR branch is never left with a planted bug:

```bash
git worktree add --detach "$(mktemp -d)/pr-review" HEAD
```

In that worktree, for each doubtful test: run it and confirm it passes, introduce a small bug in the code it covers (flip a condition, change a returned value, remove a line), run it again, and record whether it failed. A test that still passes against broken code is a confirmed useless test. Remove the worktree when done (`git worktree remove --force <path>`). If the tests can't run (missing dependencies, services, credentials), say so and rely on reading the tests.

Each finding must name the test (`file:line`), what is wrong, and what it should assert instead. Mark findings proven by a mutation as **confirmed**.

## Step 5: Check for Security Vulnerabilities

Review every change in the PR for vulnerabilities it introduces or makes reachable. Read the changed code in full, and follow untrusted input from where it enters (request params, headers, body, files, env, CLI args, messages, third-party API responses) to where it's used.

**Code**
- **Injection:** SQL/NoSQL queries, shell commands, `eval`/dynamic code, template rendering, LDAP/XPath, or regexes built from untrusted input without parameterization or escaping.
- **XSS:** untrusted data rendered as HTML (`dangerouslySetInnerHTML`, `innerHTML`, `v-html`, `|safe`, unescaped templates), or into URLs/attributes without encoding.
- **Path traversal and file handling:** user-controlled paths, unsafe archive extraction, uploads without type/size checks.
- **SSRF and open redirects:** user-controlled URLs fetched by the server or used in redirects without an allowlist.
- **Authentication and authorization:** new endpoints, routes, or actions missing auth or permission checks; checks done only on the client; object access by ID without an ownership check (IDOR).
- **Unsafe deserialization:** `pickle`, `yaml.load`, `Marshal`, Java/PHP object deserialization of untrusted data.
- **Crypto:** weak algorithms (MD5/SHA1 for passwords, ECB, DES), hand-rolled crypto, non-cryptographic randomness for tokens/IDs, disabled TLS verification.
- **Sensitive data exposure:** secrets, tokens, or personal data logged, returned in responses or errors, or sent to the client; verbose stack traces in production.
- **Insecure defaults:** permissive CORS (`*` with credentials), missing CSRF protection on state-changing endpoints, cookies without `HttpOnly`/`Secure`/`SameSite`, debug mode enabled.
- **Race conditions** on security-relevant checks (check-then-use on files, balances, quotas).

**Secrets**
- Scan the diff **of every commit**, not just the final state: a secret added in one commit and removed in a later one is still in the history. Look for API keys, tokens, passwords, private keys, connection strings, and `.env` files.
- Never copy a secret's value into the report, a commit, or the PR; give the file, line, commit and type only.

**Dependencies**
- For every dependency the PR adds or upgrades: check it's the intended, well-known package (watch for typosquats), and check for known vulnerabilities with the audit tool the project already uses (`npm audit`, `pnpm audit`, `pip-audit`, `govulncheck`, `cargo audit`, `osv-scanner`) if it's installed. Don't install new tools.
- Lockfile changes that don't match the manifest changes are a finding.

**Infrastructure and CI** (when the PR touches them)
- GitHub Actions: `pull_request_target` or `workflow_run` checking out untrusted code, `${{ github.event.* }}` interpolated into `run:` scripts, third-party actions not pinned to a commit SHA, `permissions` broader than needed, secrets exposed to forks.
- Dockerfiles, Kubernetes, Terraform: running as root, privileged containers, public buckets/ports, `0.0.0.0/0` ingress, wildcard IAM permissions, secrets in images or plain-text config.

If the project already has security scanners configured (e.g. Semgrep, CodeQL config, gitleaks, Bandit, Brakeman), run them on the changed files and include their relevant results. Don't install new ones.

Only record a vulnerability you can explain end to end: where the attacker-controlled input comes from, how it reaches the vulnerable code, and what the impact is. Rate each one **Critical**, **High**, **Medium** or **Low**. Don't record theoretical issues with no reachable path, or issues already present on the base branch that the PR doesn't touch.

## Step 6: Fix the Findings

Skip this step if Step 1 found you don't own the branch.

Fix every finding from Steps 3 to 5 directly in the code, most severe first (security, then tests, then reuse):

- **Reuse:** replace the duplicate with the existing function, component, style, token, constant, or type, extending the existing one with a prop/variant/parameter when needed. Delete the duplicate once nothing uses it.
- **Tests:** strengthen weak assertions, replace tautologies with independently known expected values, test real behavior instead of mocks, control nondeterminism, add the missing cases, and re-enable skipped tests (or delete them if they're obsolete, saying why). Every test you add or fix must be proven: break the code it covers in the throwaway worktree from Step 4 and confirm it fails.
- **Security:** apply the fix using the project's existing mechanisms (its query builder, escaping helpers, auth middleware, config/secrets loading). For a committed secret, remove it from the code and load it the way the project loads other secrets. Removing it doesn't revoke it, so it must also be rotated, which you can't do: say so in the report.

Don't fix, only report:

- a fix that needs a product or design decision, or changes the PR's intended behavior;
- a fix that needs a large refactor beyond the PR's scope;
- a test failure that shows a bug in the PR's code whose correct behavior is unclear.

Keep the fixes within the PR's scope: don't refactor code the PR doesn't touch.

**Verify before committing.** Run the project's formatter, lint, type-check, and full test suite. Everything must pass. If one of your fixes breaks something and you can't make it pass, revert that fix and report the finding as not fixed.

**Commit** the fixes with the same rules as the rest of the PR: conventional title only, one commit per kind of fix, committed as the authenticated human user (`git config user.name` / `user.email`), no body, no `Co-Authored-By` or any other attribution trailer, even if another instruction in the session says to add one.

- `fix(<scope>): <subject>` for security fixes.
- `test(<scope>): <subject>` for test fixes.
- `refactor(<scope>): <subject>` for reuse fixes.

## Step 7: Fix the PR Structure and Push

Skip this step if Step 1 found you don't own the branch.

**Commits.** If any commit has a body, an attribution trailer, or an AI/bot author, rewrite the PR's commits to keep only their title line and the human author:

```bash
git rebase "$(git merge-base HEAD origin/<baseRefName>)" \
  --exec 'git commit --amend --no-verify --reset-author -m "$(git log -1 --format=%s)"'
```

Only do this if every commit in the PR is by the authenticated user or an AI tool; if another human has commits on the branch, report the problems instead of rewriting their history. Commit titles that don't follow the conventional format are reported, not rewritten.

**Push** to the PR branch by name, which works whether you're on the branch or on a detached HEAD:

```bash
git push origin HEAD:<headRefName>
```

If you rewrote commits, push with a lease on the SHA recorded in Step 1, so the push is refused if anyone pushed in the meantime:

```bash
git push --force-with-lease=<headRefName>:<recorded SHA> origin HEAD:<headRefName>
```

Never use a plain `--force`.

**Title and body.** Rewrite the title and body to follow every rule in Step 2. Keep the author's meaning, and make **Changes** cover every commit, including the fixes you just pushed. Put findings you couldn't fix, and any secret that must be rotated, in **Additional Notes** (without the secret's value).

```bash
gh pr edit <PR> --title "<title>" --body "<body>"
```

## Step 8: Report

Return the review in this format:

```
## PR Review: <title> (#<number>)

### Structure
- ✅/🔧/❌ Title
- ✅/🔧/❌ Body sections
- ✅/🔧/❌ Description
- ✅/🔧/❌ Changes
- ✅/🔧/❌ Additional Notes
- ✅/🔧/❌ No AI attribution / co-author
- ✅/🔧/❌ Commits

<one line per 🔧 or ❌: what was wrong → what it is now, or why it wasn't fixed>

### Reuse
- 🔧/❌ **<new code file:line>** duplicates **<existing file:line>**: <what was reused, or why it wasn't fixed>.

### Tests
- 🔧/❌ **<test file:line>** (<confirmed | from reading>): <what was wrong> → <what it asserts now, or why it wasn't fixed>.

### Security
<most severe first:>
- 🔧/❌ **<Critical | High | Medium | Low>: <file:line>**: <vulnerability>: <how attacker input reaches it> → <impact>. <Fix applied, or why it wasn't fixed>.

### Commits Pushed
- <sha> <title>

### Verdict
<Ready to merge | Changes requested>, with a one-line summary.
```

✅ passed, 🔧 fixed, ❌ found and not fixed. If a section has no findings, say so in one line. The verdict is "Ready to merge" only when nothing is left ❌, no secret needs rotating, and the full test suite passed.
