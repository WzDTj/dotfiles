#!/usr/bin/env bash
set -euo pipefail

MODEL="${AI_COMMIT_MODEL:-github-copilot/gpt-5-mini}"
AGENT="${AI_COMMIT_AGENT:-OpenCode-Builder}"
DIFF_LIMIT="${AI_COMMIT_DIFF_LIMIT:-12000}"

if ! command -v opencode >/dev/null 2>&1; then
  echo "Error: 'opencode' command not found." >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: current directory is not a git repository." >&2
  exit 1
fi

FILES="$(git diff --staged --name-only)"
DIFF="$(git diff --staged --no-color)"

if [ -z "$DIFF" ]; then
  echo "No staged changes. Stage files first." >&2
  exit 1
fi

if [ "${#DIFF}" -gt "$DIFF_LIMIT" ]; then
  DIFF="${DIFF:0:DIFF_LIMIT}"
fi

build_prompt() {
  cat <<EOF
Generate ONE concise git commit subject line.

Rules:
- Max 50 chars
- Imperative mood
- Conventional Commit style if suitable
- Output subject only, no code block, no explanation

Staged files:
$FILES

Staged diff:
$DIFF
EOF
}

generate_message() {
  local prompt raw
  prompt="$(build_prompt)"
  raw="$(printf "%s" "$prompt" | opencode run --model "$MODEL" --agent "$AGENT")"
  raw="${raw//$'\r'/}"
  raw="${raw#${raw%%[![:space:]]*}}"
  raw="${raw%%$'\n'*}"
  raw="${raw#\`\`\`}"; raw="${raw%\`\`\`}"
  printf "%s" "$raw"
}

commit_with_message() {
  local message="$1"
  if [ -z "$message" ]; then
    echo "Commit message cannot be empty." >&2
    return 1
  fi
  git commit -m "$message"
}

MSG="$(generate_message)"

while true; do
  echo
  echo "Suggested commit message:"
  echo "-------------------------"
  echo "$MSG"
  echo "-------------------------"
  read -r -p "[y] commit, [e] edit, [r] regenerate, [n] cancel: " action

  case "$action" in
    y|Y)
      commit_with_message "$MSG"
      break
      ;;
    e|E)
      read -r -p "Edit message: " edited
      MSG="$edited"
      ;;
    r|R)
      MSG="$(generate_message)"
      ;;
    n|N)
      echo "Cancelled."
      break
      ;;
    *)
      echo "Invalid choice. Use y/e/r/n."
      ;;
  esac
done
