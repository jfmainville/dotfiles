---
name: pr-resolve-review
description: Reply to all PR review comments (human and bot) on current PR. Fetches comments awaiting a reply, evaluates each one, fixes real issues, dismisses false positives, updates the PR description with the new changes, and replies to every comment with the outcome. Resolves only bot threads whose issue was fixed and pushed, leaving every human thread, dismissal, and question open so the user or reviewer can validate before resolving it.
license: MIT
compatibility: Requires git and gh (GitHub CLI) installed.
allowed-tools: Bash(gh api *) Bash(gh pr *) Bash(git add *) Bash(git commit *) Bash(git push *)
metadata:
  author: jfmainville
  version: "1.5.0"
  homepage: https://github.com/jfmainville/dotfiles
---

Process all review comments (both human and bot) already submitted on the current PR review: fetch them, evaluate each one, fix real issues, and reply to every comment with the outcome. Only bot threads whose issue was fixed and pushed get resolved. Every other thread is left open, so an unresolved thread always means a person still needs to look at it.

### Step 1: Fetch All Comments

Determine the repository and PR number:

```bash
gh pr view --json number,headRepositoryOwner,headRepository \
  -q '{owner: .headRepositoryOwner.login, repo: .headRepository.name, pr: .number}'
```

If this command fails (no PR associated with the current branch), print "No PR found for the current branch" and stop — do not proceed with any of the steps below.

Determine your own GitHub login, used below to tell your own replies apart from the reviewer's:

```bash
gh api user -q .login
```

Fetch inline review-thread comments, including resolution state, thread IDs, and each comment's author, via GraphQL:

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $pr: Int!, $cursor: String) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $pr) {
        reviewThreads(first: 100, after: $cursor) {
          pageInfo { hasNextPage endCursor }
          nodes {
            id
            isResolved
            path
            line
            comments(first: 50) {
              nodes {
                databaseId
                author { login }
                body
                diffHunk
              }
            }
          }
        }
      }
    }
  }' -f owner="$OWNER" -f repo="$REPO" -F pr="$PR_NUMBER"
```

Also fetch PR-level (non-inline) issue comments, which cannot be threaded:

```bash
gh api "repos/$OWNER/$REPO/issues/$PR_NUMBER/comments"
```

Skip resolved threads. Because this skill leaves most threads open on purpose, `isResolved: false` alone doesn't tell you whether a thread still needs a reply. Treat an unresolved `reviewThreads` node as unanswered only if its most recent comment is NOT authored by your own login. Treat an issue comment as unanswered only if there is no later issue comment authored by your own login.

If zero unanswered comments are found, print "No unanswered comments found" and stop.

### Step 2: Process Each Unanswered Comment

For each unanswered comment, apply the appropriate evaluation based on whether the author is a bot or a human.

#### For Bot Comments

Read the referenced code and determine:

1. **TRUE POSITIVE** - A real bug that needs fixing
2. **FALSE POSITIVE** - Not actually a bug (intentional behavior, bot misunderstanding)
3. **UNCERTAIN** - Not sure; flag for clarification

**Likely TRUE POSITIVE:**

- Code obviously violates stated behavior
- Missing null checks on potentially undefined values
- Type mismatches or incorrect function signatures
- Logic errors in conditionals
- Missing error handling for documented failure cases

**Likely FALSE POSITIVE:**

- Bot doesn't understand the framework/library patterns
- Code is intentionally structured that way (with comments explaining why)
- Bot is flagging style preferences, not bugs
- The "bug" is actually a feature or intentional behavior
- Bot misread the code flow

#### For Human Comments

Read the referenced code and the reviewer's comment. Human reviewers are generally more accurate and context-aware than bots. Determine:

1. **ACTIONABLE** - The reviewer identified a real issue or requested a concrete change
2. **DISCUSSION** - The comment raises a valid point but the right approach is unclear
3. **ALREADY ADDRESSED** - The concern has already been fixed or is no longer relevant

**Likely ACTIONABLE:**

- Reviewer points out a bug or logic error
- Reviewer requests a specific code change
- Reviewer identifies missing edge cases or error handling

**Likely DISCUSSION -- flag for clarification:**

- Reviewer suggests an architectural change you're unsure about
- Comment involves a tradeoff (performance vs readability, etc.)
- The feedback is subjective without team consensus

#### When UNCERTAIN -- flag for clarification

For both bot and human comments:

- The fix would require architectural changes
- You're genuinely unsure if the behavior is intentional
- Multiple valid interpretations exist
- The fix could have unintended side effects

#### Act on Evaluation

**If TRUE POSITIVE / ACTIONABLE:** Fix the code. Track the comment ID and a brief description of the fix.

**If FALSE POSITIVE:** Do NOT change the code. Track the comment ID and the reason it's not a real bug.

**If DISCUSSION:** Do NOT change the code. Track the comment ID and the tradeoff/ambiguity to raise with the reviewer.

**If ALREADY ADDRESSED:** Track the comment ID and note why.

**If UNCERTAIN:** Do NOT change the code. Track the comment ID and what specifically is unclear.

Never pause execution to ask the user. For DISCUSSION and UNCERTAIN comments, keep going — they get a clarifying reply in Step 5 instead of a code change.

Do NOT reply to comments yet. Replies happen after the commit (Step 5).

### Step 3: Commit and Push

After evaluating and fixing ALL unanswered comments:

1. Run your project's lint and type-check
2. Group the fixes by what they actually touch (e.g. one group per component/module/concern), not by which comment prompted them. Unrelated fixes go in separate commits; closely related ones can share a commit.
3. For each group, stage just those files and commit using the conventional commit structure without a description and DO NOT include any task ID or a co-author trailer. Write `<TYPE>(<SCOPE>)` and the summary from the actual diff being committed, not a generic message. Commit as the currently configured git user, then push:
   ```bash
   git add <CHANGE_GROUP>
   git commit -m "<TYPE>(<SCOPE>): <summary of this group's change>"
   git push
   ```
4. Capture each commit's hash from the output.

### Step 4: Update the PR Description

If Step 3 produced no commits, skip this step. Otherwise, fetch the current PR body:

```bash
gh pr view "$PR_NUMBER" --json body -q .body
```

Add one bullet to the **Changes** section for each meaningful change pushed in Step 3, after the existing bullets. Keep every existing bullet, and only edit the Description paragraph or **Additional Notes** when a fix makes them inaccurate. Rewrite the whole body so it follows the same standards as the `work-on` skill:

```bash
gh pr edit "$PR_NUMBER" --body "$(cat <<'EOF'
## Description

This PR contains ...

## Changes

- Added this functionality.

## Additional Notes

- Any additional notes that are useful to know in this PR.
EOF
)"
```

- **Description**: a single paragraph starting with "This PR contains ..." that summarizes the change.
- **Changes**: one bullet per meaningful change, covering every commit in the PR.
- **Additional Notes**: caveats, trade-offs, or anything else useful to know when reviewing.
- End every bullet with a period.
- Wrap every version number, file name, path, and technical term in inline code, e.g. "Bumped `react` to `18.3.1` in `package.json`." rather than "Bumped react to 18.3.1 in package.json.". This covers package and dependency names, functions, components, variables, commands, CLI flags, config keys, environment variables, and branch names.
- The last bullet of **Additional Notes** is the last line of the body. Never leave an empty line after it, and never end the body with a trailing blank line or whitespace. The `EOF` line goes directly after that last bullet, as shown above.
- Never use a colon (`:`) or a semicolon (`;`) anywhere in the body, including inside bullets and code. Rephrase instead of a colon, e.g. "Added login support with OAuth." rather than "Login: added OAuth support.", and use a comma instead of a semicolon, e.g. "Added the endpoint, the client still uses the old one.". The section headings contain neither.
- Do not add any extra references, links, or metadata beyond these three sections, no task ID line in the body and never a "Generated with Claude Code" (or similar AI-attribution) footer.

### Step 5: Reply to All Comments

Now that the commits are pushed, reply to every processed comment, then resolve only the threads listed as resolvable below:

- **Bot TRUE POSITIVE, fixed and pushed**: reply with the fix, then resolve the thread. This is the only outcome that gets resolved.
- **Bot FALSE POSITIVE**: reply with why it is not a real bug. Leave the thread unresolved, since the dismissal contradicts the comment and the user should validate it.
- **Human comment, any outcome** (ACTIONABLE fixed and pushed, ALREADY ADDRESSED): reply with the outcome. Leave the thread unresolved so the reviewer can confirm and resolve it.
- **DISCUSSION / UNCERTAIN outcomes**: reply asking the reviewer to clarify (state the tradeoff or what's unclear). Leave the thread unresolved.

When in doubt whether a fix was straightforward, leave the thread unresolved.

**Reply message style:** follow the same standards as the PR description in Step 4:

- Keep it as short as possible while staying clear. One sentence is the target, two at most. Lead with the outcome, e.g. "Fixed, `token` is now checked for `null` before use." or "Not a bug, `retry` is intentionally capped at `3`.".
- No greetings, thanks, restating the comment, or explaining what the reviewer already said.
- Plain sentences only, each ending with a period. No em dashes.
- Wrap every version number, file name, path, and technical term in inline code.
- Never use a colon (`:`) or a semicolon (`;`) anywhere in the reply, including inside code. Rephrase instead, or use a comma.
- No trailing blank lines or whitespace at the end of the reply.
- No commit SHA, links, references, AI-attribution prefix, or AI-attribution footer.

**Threaded (inline) comments:** reply in-thread using the original comment's `databaseId`:

```bash
gh api "repos/$OWNER/$REPO/pulls/$PR_NUMBER/comments" \
  -f body="<outcome or clarifying question>" -F in_reply_to="$COMMENT_DATABASE_ID"
```

**Non-threadable comments:** If a comment was posted as a PR-level issue comment or review-summary submission (not an inline review comment on a specific line), reply with:

```bash
gh pr comment "$PR_NUMBER" --body "<outcome>"
```

Non-threadable comments have no thread to resolve, so the reply is the only action.

**Resolving a thread:** after replying, resolve a resolvable thread using its GraphQL thread `id` from Step 1:

```bash
gh api graphql -f query='
  mutation($threadId: ID!) {
    resolveReviewThread(input: {threadId: $threadId}) { thread { isResolved } }
  }' -f threadId="$THREAD_ID"
```

## Important Notes

### Response Policy

- **Every comment gets a response** - No silent ignores
- For bots: responses help train them and prevent re-raised false positives
- For humans: replies keep reviewers informed and unblock approvals

### Reviewer Interaction

- Never pause execution to ask the user — run the whole skill unattended
- When uncertain about a finding, or facing an architectural/business-logic tradeoff, don't guess: reply on the thread asking the reviewer to clarify, and move on
- It's better to ask the reviewer than to make a wrong fix or wrong dismissal
- Human reviewers often have context you don't - defer to them via a clarifying reply when unsure
- Only resolve bot threads whose issue was fixed and pushed. Never resolve a human thread, a dismissed false positive, or a thread with an open question

### Best Practices

- Verify findings before fixing - bots have false positives, humans rarely do
- Keep fixes minimal and focused - don't refactor unrelated code
- Ensure type-check and lint pass before committing
- Group related fixes into a single commit
- Copilot `suggestion` blocks often contain ready-to-use fixes
- If a human reviewer suggests a specific code change, prefer their version unless it introduces issues
