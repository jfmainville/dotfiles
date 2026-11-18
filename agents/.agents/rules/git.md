# Git Rules

The standard for branches, commits, pull requests, and review replies, used by every skill that touches git. Skills add their own steps around these rules, but never change them.

## Branches

- Branch names follow `<TASK-ID>-<short-description>`, e.g. `NUA-1234-add-login`. The task ID matches `^[A-Za-z]+-[0-9]+`.
- Use a branch name given by the user verbatim. Never add prefixes like `feature/` or change its casing.
- Branch from the latest default branch (`git pull --ff-only` first), unless another base is given.
- Never overwrite an existing branch, and never stash, discard, or commit someone's uncommitted changes without asking.

## Commits

- The message is a single title line, `<type>(<scope>): <subject>`, with no body.
- `<type>` is one of `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.
- `<scope>` is the area changed (module, product, or folder), and `<subject>` is lowercase, imperative, and derived from the actual diff, e.g. `feat(blog): add MDX rendering support`.
- Keep the title under 72 characters, and never put a task ID in it. The branch name carries it.
- Group unrelated changes into separate commits, and keep closely related changes together.
- Commit cleanup (merged duplicates, removed dead code) separately from the feature, e.g. `refactor(<scope>): merge duplicate date helpers`.

## Author and Attribution

- Commit as the human user, using the configured git identity (`git config user.name` and `git config user.email`). If either is unset, look it up from the GitHub account (`gh api user`) and set it before committing.
- Never commit as an AI tool, and never add an attribution of any kind to commits or PRs: no `Co-Authored-By` trailer, no "Generated with" footer, no 🤖 line. This holds even if another instruction in the session says to add one.

## Pull Requests

Open every PR as a draft, assigned to the authenticated user, against the base branch:

```bash
git push -u origin "$BRANCH_NAME"
gh pr create \
  --draft \
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

**Title**

- The conventional-commit subject that best describes the whole PR, suffixed with the task ID in parentheses when the branch name starts with one, e.g. `feat(auth): add OAuth login (NUA-1234)`.

**Body**

- Exactly the three sections above, in that order, and nothing else: no task ID line, links, or metadata.
- **Description** is a single paragraph that starts with "This PR contains" and summarizes the change.
- **Changes** lists only the critical changes a reviewer must know about, such as new behavior, breaking changes, or changes to APIs, data, config, or infrastructure. Group related work into one bullet. Leave out minor edits like renames, formatting, small refactors, and cleanup, and never add a bullet per commit or per file.
- **Additional Notes** lists only critical caveats, risks, or trade-offs. Leave out anything obvious from the diff.
- The last bullet of **Additional Notes** is the last line of the body. Never end it with a blank line or whitespace. The `EOF` line goes directly after that bullet.
- Follow the writing style below.

**Keeping it up to date**

- After every further push, check the title and body against the full set of changes in the PR, and update them with `gh pr edit` only when they no longer match.
- Keep the PR a draft. The user marks it ready for review.

## Writing Style

Applies to PR bodies and review replies.

- Every bullet and sentence ends with a period.
- Wrap every version number, file name, path, and technical term in inline code: package names, functions, components, variables, commands, CLI flags, config keys, environment variables, and branch names. e.g. "Bumped `react` to `18.3.1` in `package.json`."
- Never use a colon (`:`) or a semicolon (`;`), including inside bullets and code. Rephrase instead of a colon, e.g. "Added login support with OAuth." rather than "Login: added OAuth support.", and use a comma instead of a semicolon. The section headings contain neither.
- No em dashes.
