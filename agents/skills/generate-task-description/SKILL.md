---
name: generate-task-description
description: Generate a Chinese Jira task description from the Jira issue template and the actual changes in its linked PRs plus any PRs explicitly supplied by the user. Use only when the user explicitly invokes `$generate-task-description`; never trigger implicitly for ordinary Jira, PR, review, planning, or description-writing requests.
---

# Generate Task Description

Generate a reviewable Jira description without modifying Jira.

## Input

Require a Jira issue key such as `DEV-11504`. Accept optional additional PR URLs, PR numbers with repository names, branches, commits, or a local diff.

If the Jira key is missing, ask only for the key. If no implementation PR or diff can be found, ask for one instead of inventing changes.

## Workflow

1. Fetch the Jira issue's current summary, full description, status, comments, attachments, issue links, and remote links. Prefer an authenticated Jira connector; otherwise use `acli` after checking its local help and authentication state.
2. Preserve the issue's description template, headings, order, and any existing release instructions. Treat the template as the output structure, not as evidence that a change occurred.
3. Collect implementation PRs from Jira remote links, the description, comments, and user-supplied PRs. User-supplied PRs are additional scope unless the user says they replace linked PRs.
4. Fetch each PR's metadata, changed files, and full diff with the GitHub connector or `gh`. For local branches or commits, inspect the merge-base diff. Do not infer behavior from PR titles alone.
5. Synthesize the behavior actually added, changed, or removed across all relevant PRs. Resolve conflicts in favor of the diff and call out unresolved scope conflicts before drafting.
6. Fill the Jira template in Chinese using the rules below.
7. Return the proposed description for confirmation. Never update the Jira issue, add a Jira comment, or transition its status unless the user separately and explicitly requests that write.

## Writing Rules

- Base every claim on the Jira content or PR/diff evidence. Do not invent requirements, tests, impact, or release steps.
- Write for product, QA, operations, and engineering readers. Prefer behavior and principles over file names, class names, constants, field-by-field implementation notes, or code excerpts.
- Keep section 1 (`仕様と背景`) blank.
- In section 2 (`実装のLogic`), explain the operating principle and resulting behavior in plain language. Omit unnecessary technical detail.
- In section 3 (`テスト流れ`), write concrete, observable verification steps derived from the actual changes. Cover changed behavior and important unaffected paths when supported by the diff.
- In section 4 (`影響範囲`), list only affected product surfaces or workflows. Keep it concise.
- In section 7 (`Engineer自分テストの所`), always write exactly: `已按「テスト流れ」测试`.
- For every other section that is not involved, write exactly `None`. Do not pad it with explanations.
- Preserve any instruction already present above the numbered template, such as a required code-first and migration-later release order.
- Use `None` for `Release Note` when no release note is supported by Jira or the PRs.
- Do not claim tests passed merely because test files changed. Section 7 uses the required fixed wording; section 3 describes the intended confirmation flow.

For the standard Poper task template, read [references/poper-template.md](references/poper-template.md).

## PR Selection Rules

- Include open or merged implementation PRs that materially implement the ticket.
- Exclude unrelated, superseded, or reverted PRs when the evidence is clear; state the exclusion briefly outside the generated description.
- When a linked PR cannot be accessed, identify it and ask the user for access or a diff.
- When PRs span repositories, produce one coherent task description covering the combined user-visible behavior.
- Do not include generated files, lockfile churn, formatting-only changes, or unrelated cleanup in the description unless they materially affect release or testing.

## Output

Return the complete proposed Jira description in one Markdown code block. Before the block, mention only material missing evidence or excluded PRs. Do not append implementation analysis after the block unless the user asks for it.
