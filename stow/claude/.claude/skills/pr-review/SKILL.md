---
name: pr-review
description: Handle an open pull request — check CI status, diagnose failures, read review comments, propose fixes, and reply to reviewers. Use this skill whenever the user says "review PR", "check my PR", "handle PR comments", "fix CI", "PR status", or gives a PR number to work on. Also trigger when the user wants to address reviewer feedback, investigate failing checks, or manage any aspect of an in-progress pull request.
allowed-tools:
  - Bash(gh pr view:*)
  - Bash(gh pr checks:*)
  - Bash(gh pr diff:*)
  - Bash(gh pr comment:*)
  - Bash(gh run view:*)
  - Bash(gh api:*)
  - Bash(git checkout:*)
  - Bash(git fetch:*)
  - Bash(git log:*)
  - Bash(git diff:*)
  - Bash(git add:*)
  - Bash(git commit:*)
  - Bash(gh pr list:*)
---

# Review PR

Given a PR number, perform a single idempotent pass: check CI, diagnose failures, handle review comments, and report status. This skill is designed to be safe to run repeatedly (e.g. via `/loop`) — it skips work that's already been addressed.

## Arguments

`$ARGUMENTS` is a single PR number (e.g. `123`). If not provided, ask the user.

## Step 1: Gather context

Start by collecting all relevant PR state in parallel:

```bash
gh pr view $PR --json title,body,state,baseRefName,headRefName,mergeable,reviewDecision
gh pr checks $PR
gh pr diff $PR
```

Summarize the PR status briefly: title, branch, mergeable state, review decision, and check results.

## Step 2: Handle CI failures

If any checks are failing:

1. Identify the failing check(s) from `gh pr checks` output
2. Fetch the logs:
   ```bash
   gh run view $RUN_ID --log-failed
   ```
   If that's too verbose, use `--log-failed` with grep to find the relevant error lines.
3. Read the relevant source files to understand the failure
4. Diagnose the root cause and propose a fix to the user — do NOT push changes without approval
5. If the user approves the fix, implement it, commit, and push to the PR branch

If checks are passing, say so and move on.

## Step 3: Handle review comments

Fetch unresolved review comments:

```bash
gh api repos/{owner}/{repo}/pulls/$PR/comments --jq '[.[] | select(.in_reply_to_id == null)]'
```

Also fetch the review threads to understand conversation context:

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $pr: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $pr) {
        reviewThreads(first: 100) {
          nodes {
            isResolved
            comments(first: 50) {
              nodes {
                author { login }
                body
                path
                line
                createdAt
              }
            }
          }
        }
      }
    }
  }
' -f owner="{owner}" -f repo="{repo}" -F pr=$PR
```

For each **unresolved** thread:

1. Read the comment and the referenced code
2. Assess whether the feedback is actionable
3. Propose a fix to the user — do NOT implement without approval
4. Once the user approves a fix:
   - Implement the change
   - Reply to the comment AND resolve the thread (see below)

### Replying and resolving — every thread must be addressed

A PR cannot be merged with unresolved conversations. After fixing code (or deciding not to), **reply to every unresolved thread** explaining what was done, then **resolve it**. This applies to all threads, not just ones with code changes:

- **Fixed**: explain what changed (e.g., "Fixed — widened type to `Record<string, unknown>`.")
- **Deferred**: acknowledge and explain why (e.g., "Acknowledged — deferring to a follow-up since the production code has the same limitation.")
- **Won't fix / known trade-off**: explain the reasoning (e.g., "This is a known trade-off discussed during design. The watch failures are caught and warned.")
- **Already resolved by other changes**: note what resolved it (e.g., "Resolved — this import was removed when the file was split.")

**How to reply to a review thread:**

```bash
gh api graphql -f query='
  mutation($body: String!, $threadId: ID!) {
    addPullRequestReviewThreadReply(input: {
      body: $body,
      pullRequestReviewThreadId: $threadId
    }) {
      comment { id }
    }
  }
' -f body="Your reply here" -f threadId="$THREAD_ID"
```

**How to resolve a thread:**

```bash
gh api graphql -f query='
  mutation($threadId: ID!) {
    resolveReviewThread(input: {threadId: $threadId}) {
      thread { isResolved }
    }
  }
' -f threadId="$THREAD_ID"
```

Always reply first, then resolve. Do both for every thread — do not leave any conversations open.

**Important:** Run each `gh api graphql` call as a separate Bash command — do not wrap them in shell functions. The allowed-tools permissions match on the command prefix (`gh api`), so shell function wrappers will be blocked.

### Fetching thread IDs

When fetching review threads, include the thread `id` field so you can reply and resolve:

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $pr: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $pr) {
        reviewThreads(first: 100) {
          nodes {
            id
            isResolved
            comments(first: 50) {
              nodes {
                author { login }
                body
                path
                line
                createdAt
              }
            }
          }
        }
      }
    }
  }
' -f owner="{owner}" -f repo="{repo}" -F pr=$PR
```

If there are no unresolved comments, say so.

## Step 4: Summary

End with a brief status report:
- CI: passing / failing (with diagnosis if failing)
- Reviews: count of unresolved threads and what was addressed
- Merge readiness: whether the PR has approvals, passing checks, and is mergeable

Do NOT merge the PR — just report whether it's ready.

## Idempotency

When run repeatedly, be aware that:
- Previously resolved threads should be skipped
- Previously passing checks don't need re-investigation
- If you already proposed a fix in this conversation that hasn't been approved yet, don't re-propose it
