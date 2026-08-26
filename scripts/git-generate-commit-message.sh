#!/usr/bin/env bash
set -euo pipefail

MODEL="${AI_COMMIT_MODEL:-gpt-5.6-luna}"
DIFF_LIMIT="${AI_COMMIT_DIFF_LIMIT:-12000}"

if ! command -v codex >/dev/null 2>&1; then
  echo "Error: 'codex' command not found." >&2
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

run_codex_with_loading() {
  local prompt="$1"
  local out_file="$2"
  local err_file="$3"
  local pid spinner index

  spinner='|/-\\'
  index=0

  (
    printf "%s" "$prompt" | codex exec --model "$MODEL" --sandbox read-only --output-last-message "$out_file" >/dev/null 2>"$err_file"
  ) &
  pid=$!

  while kill -0 "$pid" >/dev/null 2>&1; do
    printf "\rGenerating commit message... %s" "${spinner:index:1}" >&2
    index=$(( (index + 1) % 4 ))
    sleep 0.1
  done

  wait "$pid"
  local status=$?

  if [ "$status" -eq 0 ]; then
    printf "\rGenerating commit message... done\n" >&2
  else
    printf "\rGenerating commit message... failed\n" >&2
  fi

  return "$status"
}

generate_message() {
  local prompt raw out_file err_file
  prompt="$(build_prompt)"
  out_file="$(mktemp)"
  err_file="$(mktemp)"

  if ! run_codex_with_loading "$prompt" "$out_file" "$err_file"; then
    echo "Error: failed to generate commit message with model '$MODEL'." >&2
    if [ -s "$err_file" ]; then
      while IFS= read -r line; do
        echo "$line" >&2
      done < "$err_file"
    fi
    rm -f "$out_file" "$err_file"
    return 1
  fi

  raw="$(<"$out_file")"
  rm -f "$out_file" "$err_file"
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
