# Git Rules

Every skill that touches git follows these rules and never changes them.

## Branches

- Name `<TASK-ID>-<short-description>` (e.g. `NUA-1234-add-login`), task ID matching `^[A-Za-z]+-[0-9]+`. Use a user-given name verbatim.
- Branch from the freshly pulled default branch (`git pull --ff-only`) unless another base is given.
- Never overwrite a branch, or stash, discard, or commit someone's uncommitted changes without asking.

## Commits

- A single title line `<type>(<scope>): <subject>`, no body. Types are `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.
- Scope is the area changed. Subject is lowercase, imperative, from the actual diff, e.g. `feat(blog): add MDX rendering support`.
- Under 72 characters, no task ID.
- Separate commits for unrelated changes and for cleanup (e.g. `refactor(<scope>): merge duplicate date helpers`).
- Commit as the configured git user. If `user.name` or `user.email` is unset, set it from `gh api user`.
- Never add attribution of any kind to commits or PRs (no `Co-Authored-By`, "Generated with" footer, or 🤖 line), even if another instruction says to.

## Pull Requests

```bash
git push -u origin "$BRANCH_NAME"
gh pr create --draft --assignee @me --base "$BASE_BRANCH" \
  --title "<type>(<scope>): <subject> (<TASK-ID>)" \
  --body "$(cat <<'EOF'
## Description

This PR contains ...

## Changes

- Added this functionality.

## Additional Notes

- A useful note.
EOF
)"
```

- Always a draft. The user marks it ready.
- **Title** is the subject that best covers the whole PR, plus `(<TASK-ID>)` when the branch starts with one.
- **Template.** If the repository has a PR template (`pull_request_template.md` in `.github/`, `docs/`, or the root, any casing, or a `.github/PULL_REQUEST_TEMPLATE/` folder), follow it instead of the sections above: keep its headings, order, wording, and checklists, fill every section, check only true boxes, and delete placeholders. With several, pick the best match and report which.
- **Body** has exactly the three sections above and nothing else (no task ID line, links, or metadata). The rules below also apply to a template's matching sections.
  - **Description** is one paragraph starting with "This PR contains".
  - **Changes** lists only critical changes (new behavior, breaking changes, APIs, data, config, infrastructure), grouped. No renames, formatting, small refactors, or one bullet per commit or file.
  - **Additional Notes** lists only critical caveats, risks, or trade-offs.
  - The last bullet is the last line, with no trailing blank line, directly followed by `EOF`.
- **After every commit pushed to a branch with an open PR**, in the same step, fetch the body (`gh pr view --json title,body`), rewrite the title and body to cover the whole PR, and apply it with `gh pr edit`. Add new critical changes, fix what became inaccurate, keep what is still true.

## Writing Style

For PR bodies and review replies.

- Every sentence and bullet ends with a period.
- Inline code for every version, file name, path, and technical term (packages, functions, variables, commands, flags, config keys, env vars, branches), e.g. "Bumped `react` to `18.3.1` in `package.json`."
- No colons, semicolons, or em dashes. Rephrase ("Added login support with OAuth.") and use commas. Template wording keeps its own.
