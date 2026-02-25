#!/usr/bin/env zsh
set -euo pipefail

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux is not installed."
  exit 1
fi

session_name="$(basename "$PWD")"

if ! tmux has-session -t "$session_name" 2>/dev/null; then
  echo "No running work session found for '$session_name'."
  exit 0
fi

pane_paths="$(tmux list-panes -t "$session_name" -F "#{pane_current_path}" 2>/dev/null)"

matches_current_dir=0
while IFS= read -r pane_path; do
  if [[ "$pane_path" == "$PWD" || "$pane_path" == "$PWD"/* ]]; then
    matches_current_dir=1
    break
  fi
done <<< "$pane_paths"

if [[ "$matches_current_dir" -ne 1 ]]; then
  echo "Refusing to stop '$session_name': session panes are not under '$PWD'."
  echo "Run this command from the same project directory used by start-work.sh."
  exit 1
fi

tmux kill-session -t "$session_name"
echo "Stopped work session '$session_name'."
