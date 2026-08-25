---
name: jira-estimation-brief
description: Generate a Chinese EPM estimation meeting script from Jira work item keys by fetching Jira data with acli. Use when the user asks to prepare, explain, brief, groom, or estimate Jira tickets.
---

# Jira Estimation Brief

## Purpose

Generate a Chinese EPM meeting script for Jira estimation meetings.

The user provides one or more Jira work item keys, such as `ENG-1086` or `APP-234`.

You must fetch Jira data with Atlassian CLI `acli` before generating the script.

---

## Mandatory Data Fetching

For each Jira key, run the following commands:

```bash
acli jira workitem view <JIRA_KEY> --json --fields "*all"
acli jira workitem comment list --key <JIRA_KEY> --json --paginate
acli jira workitem attachment list --key <JIRA_KEY> --json
```

Do not ask the user to paste Jira content unless all `acli` attempts fail.

---

## Failure Handling

If `acli` is unavailable, authentication fails, permission is denied, or the Jira key does not exist, do not invent the meeting script.

Output only the following information:

- Failed command
- Error summary
- Possible cause
- Concrete fix suggestion

Do not generate a speculative meeting script when Jira data cannot be fetched.

---

## Output Language

Use Chinese by default.

---

## Output Format

```markdown
# [JIRA_KEY] 评估会讲稿

## 1. 任务说明

## 2. 需求范围

## 3. 不做范围

## 4. 验收标准

## 5. 影响范围

## 6. 技术 / 实现关注点

## 7. QA 关注点

## 8. 风险与不确定性

## 9. 建议点数区间
```

---

## Section Requirements

### 1. 任务说明

Combine the one-sentence summary, meeting opening script, and background explanation into this section.

This section should include:

- What this ticket is about
- Why this ticket needs to be discussed
- What problem or goal it is related to
- How the EPM can introduce it in the meeting

Write it as a meeting-ready script that the EPM can read aloud.

Example style:

```text
大家看一下这个单子：[JIRA_KEY]。

先说一下背景，目前在【场景 / 流程】里存在【当前问题】。这个问题会影响【用户 / 业务 / 内部流程】。

所以这个单子的目标是【目标说明】。
```

---

### 2. 需求范围

List what needs to be completed in this ticket.

Focus on the actual work scope, not Jira metadata.

If the scope is unclear, mark it as `待确认`.

---

### 3. 不做范围

List what is not included in this ticket.

If Jira does not clearly define the out-of-scope items, write:

```text
当前 Jira 中没有明确说明不做范围，建议评估时注意不要把额外需求默认计入本单。
```

Do not invent out-of-scope items.

---

### 4. 验收标准

Summarize the acceptance criteria from Jira.

If acceptance criteria are missing or incomplete, clearly state:

```text
当前 Jira 中验收标准不完整，建议补充以下内容：

- 正常路径
- 异常路径
- 边界条件
- 权限或状态限制
- 回归范围
```

---

### 5. 影响范围

Analyze possible impact areas, such as:

- 前端页面
- 后端接口
- 数据结构
- 第三方服务
- 用户路径
- 兼容性
- 已有功能回归
- 关联工单或依赖项

Only include areas supported by Jira data.

If uncertain, mark it as `待确认`.

---

### 6. 技术 / 实现关注点

Summarize technical points that developers should consider during estimation.

Examples:

- 是否只影响当前模块
- 是否涉及接口变更
- 是否涉及数据结构变更
- 是否涉及历史逻辑兼容
- 是否依赖其他工单
- 是否涉及第三方服务
- 是否需要额外调研

If Jira does not contain enough technical detail, write:

```text
当前 Jira 中技术实现信息不足，需要开发在评估时确认。
```

---

### 7. QA 关注点

Summarize what QA should focus on.

Include relevant test angles:

- 正常路径
- 异常路径
- 边界场景
- 回归范围
- 多端兼容
- 特殊用户状态
- 数据状态差异

Only include QA concerns that are relevant to the ticket.

---

### 8. 风险与不确定性

List risks that may affect estimation.

Examples:

- 需求边界不清
- 验收标准不完整
- 依赖其他工单
- 涉及历史逻辑
- 涉及第三方服务
- 附件或外部链接未确认
- 评论区信息和描述存在冲突

If there are no obvious risks, write:

```text
从当前 Jira 信息看，暂无明显风险，但最终仍以开发和 QA 的评估为准。
```

---

### 9. 建议点数区间

Based on the available Jira data, provide:

- 乐观估计
- 正常估计
- 风险估计
- 建议点数

Explain the reason briefly.

If the information is insufficient, do not force a point estimate. Instead write:

```text
当前信息不足，不建议直接估点。建议先补充需求范围、验收标准或技术方案后再评估。
```

---

## Rules

- Do not invent missing information.
- Do not output the `acli` fetching result summary.
- Do not describe the Jira ticket status in the final meeting script.
- If acceptance criteria are missing, clearly say they are missing.
- If the scope is unclear, say so directly.
- If comments conflict with the description, mention the conflict in `风险与不确定性`.
- If attachments or external links are present and may affect estimation, mention them in `影响范围` or `风险与不确定性`.
- If the ticket is not ready for estimation, say so directly.
- The final script should be suitable for an EPM to read aloud in an estimation meeting.
