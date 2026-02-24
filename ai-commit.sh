#!/usr/bin/env bash
set -e

# 获取 staged diff
DIFF=$(git diff --staged)

if [ -z "$DIFF" ]; then
  echo "No staged changes."
  exit 1
fi

PROMPT="
Generate a concise git commit message.

Rules:
- max 50 chars subject
- imperative mood
- no explanation
- follow conventional commit if possible

Diff:
$DIFF
"

# ====== 选择你的 AI CLI ======

# opencode
MSG=$(echo "$PROMPT" | opencode run --model github-copilot/gpt-5-mini --agent OpenCode-Builder)

# 如果用 copilot-cli 替换上面一行：
# MSG=$(echo "$PROMPT" | copilot suggest)

echo "Suggested commit message:"
echo "-------------------------"
echo "$MSG"
echo "-------------------------"

read -p "Use this message? (y/n) " yn
if [ "$yn" = "y" ]; then
  git commit -m "$MSG"
fi
