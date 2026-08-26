#!/usr/bin/env zsh
set -euo pipefail

session_name="$(basename "$PWD")"
branch="$(git -C "$PWD" symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
title="$session_name"
[[ -n "$branch" ]] && title="$session_name: $branch"

if tmux has-session -t "$session_name" 2>/dev/null; then
  :
else
  tmux new-session -d -s "$session_name" -c "$PWD" -x "$(tput cols)" -y "$(tput lines)"
  tmux new-window -d -c "$PWD"
fi

tmux set-option -t "$session_name" set-titles on 2>/dev/null || true
tmux set-option -t "$session_name" set-titles-string "$title" 2>/dev/null || true
tmux attach-session -t "$session_name"
