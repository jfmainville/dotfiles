---
name: pr-resolve-reviews
description: Resolve all PR review comments (human and bot) on current PR. Fetches unanswered comments, evaluates each one, fixes real issues, dismisses false positives, and replies to every comment with the outcome.
license: MIT
compatibility: Requires git and gh (GitHub CLI) installed.
allowed-tools: Bash(gh api *) Bash(gh pr *) Bash(git add *) Bash(git commit *) Bash(git push *)
metadata:
  author: jfmainville
  version: "1.0.0"
  homepage: https://github.com/jfmainville/dotfiles
---

Automatically resolve all review comments (both human and bot) already submitted on the current PR review.

### Step 1: Fetch All Comments

Determine the repository and PR number:

```bash
gh pr view --json number,headRepositoryOwner,headRepository \
  -q '{owner: .headRepositoryOwner.login, repo: .headRepository.name, pr: .number}'
```

If this command fails (no PR associated with the current branch), print "No PR found for the current branch" and stop — do not proceed with any of the steps below.

Fetch inline review-thread comments, including resolution state and thread IDs, via GraphQL:

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

Treat any `reviewThreads` node with `isResolved: false` as unanswered. Treat any issue comment without a prior reply from you as unanswered.

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

Never pause execution to ask the user. For DISCUSSION and UNCERTAIN comments, keep going — they get a clarifying reply in Step 4 instead of a code change.

Do NOT reply to comments yet. Replies happen after the commit (Step 4).

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

### Step 4: Reply to All Comments

Now that the commit hash exists, reply to every processed comment. Do not reply for fresh fixes that reviewers should still verify themselves — every other outcome gets a reply:

- **Closing outcomes** (false positive, already addressed, fixed and pushed): reply with the outcome and resolve the thread.
- **DISCUSSION / UNCERTAIN outcomes**: reply asking the reviewer to clarify (state the tradeoff or what's unclear), and leave the thread unresolved so the reviewer can respond.

**Reply message style:** plain sentences only. No em dashes, no semicolons. Do not include the commit SHA.

**Threaded (inline) comments:** reply in-thread using the original comment's `databaseId`:

```bash
gh api "repos/$OWNER/$REPO/pulls/$PR_NUMBER/comments" \
  -f body="<outcome or clarifying question>" -F in_reply_to="$COMMENT_DATABASE_ID"
```

For closing outcomes only, resolve the thread:

```bash
gh api graphql -f query='
  mutation($threadId: ID!) {
    resolveReviewThread(input: { threadId: $threadId }) { thread { id isResolved } }
  }' -f threadId="$THREAD_ID"
```

**Non-threadable comments:** If a comment was posted as a PR-level issue comment or review-summary submission (not an inline review comment on a specific line), reply with:

```bash
gh pr comment "$PR_NUMBER" --body "<outcome>"
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
- Leave clarification threads unresolved; only resolve threads you've actually closed out

### Best Practices

- Verify findings before fixing - bots have false positives, humans rarely do
- Keep fixes minimal and focused - don't refactor unrelated code
- Ensure type-check and lint pass before committing
- Group related fixes into a single commit
- Copilot `suggestion` blocks often contain ready-to-use fixes
- If a human reviewer suggests a specific code change, prefer their version unless it introduces issues
