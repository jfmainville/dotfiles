---
name: pr-resolve-review
description: Handle every unanswered review comment and change request on the current PR. Fixes real issues, pushes, updates the PR description, replies in-thread, and resolves only fixed bot threads.
license: MIT
compatibility: Requires git and gh.
allowed-tools: Bash(gh api *) Bash(gh pr *) Bash(git add *) Bash(git commit *) Bash(git push *)
metadata:
  author: jfmainville
  version: "2.0.0"
  homepage: https://github.com/jfmainville/dotfiles
---

Run unattended and never ask the user. Never post a top-level PR comment, only in-thread replies. An unresolved thread means a person still needs to look at it. Rules live in `~/.agents/rules/`.

## 1. Fetch

```bash
gh pr view --json number,headRepositoryOwner,headRepository \
  -q '{owner: .headRepositoryOwner.login, repo: .headRepository.name, pr: .number}'
gh api user -q .login
```

If there is no PR, print "No PR found for the current branch" and stop.

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $pr: Int!, $cursor: String) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $pr) {
        reviewThreads(first: 100, after: $cursor) {
          pageInfo { hasNextPage endCursor }
          nodes {
            id isResolved path line startLine
            comments(first: 50) { nodes { databaseId author { login } body diffHunk } }
          }
        }
      }
    }
  }' -f owner="$OWNER" -f repo="$REPO" -F pr="$PR"
gh api --paginate "repos/$OWNER/$REPO/pulls/$PR/reviews" \
  -q '.[] | {id, state, body, submitted_at, author: .user.login}'
```

- Skip resolved threads. A thread started by another account is unanswered when its last comment isn't from your login. A thread started by your login is unanswered when its last comment doesn't start with `🤖 *AI Agent:* `. Your login's comments without the prefix are the user's own.
- A reviewer's latest review that is `CHANGES_REQUESTED` with a body is a **change request**. Ignore your own reviews and plain issue comments.
- If nothing is unanswered, print "No unanswered comments found" and stop.

## 2. Evaluate

Read the code for each comment. Evaluate change requests like human comments.

- **Bot**: **TRUE POSITIVE** (a real bug), **FALSE POSITIVE** (misread code, framework patterns, intentional behavior, or style not in the rules), or **UNCERTAIN**.
- **Human**: **ACTIONABLE**, **DISCUSSION** (unclear trade-off or subjective), **ALREADY ADDRESSED**, or **UNCERTAIN**. Humans usually have context you lack, so prefer their suggested code unless it adds issues.
- **UNCERTAIN** covers architectural fixes, unclear intent, several valid readings, or risky side effects. Ask instead of guessing.
- A ` ```suggestion ` block that is correct gets applied verbatim to `line` (from `startLine`), with only the changes needed to compile and lint.

Fix TRUE POSITIVE and ACTIONABLE minimally, following the coding rules. Change nothing for the others. Track each outcome and reason. Don't reply yet.

## 3. Commit and Push

Run the format and lint check from `general.md` and the type-check on changed files. Group fixes by what they touch, then commit each group per `git.md` and push. Keep the hashes.

## 4. Update the PR

If anything was pushed, update the PR per `git.md`. Most review fixes aren't critical, so add a **Changes** bullet only for critical ones.

## 5. Reply and Resolve

Reply to each thread's first comment:

```bash
gh api "repos/$OWNER/$REPO/pulls/$PR/comments" -f body="<reply>" -F in_reply_to="$COMMENT_ID"
```

- Bot TRUE POSITIVE, fixed and pushed, gets the fix and is resolved. This is the only resolved outcome.
- Bot FALSE POSITIVE gets why it isn't a bug, left open.
- Human comments get the outcome, left open.
- DISCUSSION and UNCERTAIN get a clarifying question, left open.
- Change requests get no reply, since that would need a new comment. List them in the report.

Replies follow the `git.md` Writing Style, at one sentence (two at most), leading with the outcome, e.g. "Fixed, `token` is now checked for `null` before use." No greetings, restating, SHAs, links, trailing whitespace, or attribution. In threads started by your login only, prefix `🤖 *AI Agent:* `, whose colon is the only one allowed.

Resolve with:

```bash
gh api graphql -f query='mutation($id: ID!) { resolveReviewThread(input: {threadId: $id}) { thread { isResolved } } }' -f id="$THREAD_ID"
```

## 6. Report

One line per thread and change request with its outcome and whether it was resolved. List change requests separately, so the user can re-request review.
