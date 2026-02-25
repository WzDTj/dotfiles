#!/usr/bin/env bash
set -euo pipefail

session_name="$(basename "$PWD")"

if tmux has-session -t "$session_name" 2>/dev/null; then
  tmux attach-session -t "$session_name"
  exit 0
fi

tmux new-session -d -s "$session_name" -c "$PWD"
tmux split-window -h -t "${session_name}:1.1" -c "$PWD"
tmux resize-pane -t "${session_name}:1.1" -x 160
tmux split-window -v -t "${session_name}:1.2" -c "$PWD"

tmux send-keys -t "${session_name}:1.1" "e" C-m
tmux send-keys -t "${session_name}:1.2" "lazygit" C-m
tmux new-window -t "${session_name}:2" -c "$PWD"
tmux send-keys -t "${session_name}:2.1" "opencode --port 4096" C-m

tmux select-window -t "${session_name}:1"
tmux select-pane -t "${session_name}:1.1"
tmux attach-session -t "$session_name"
