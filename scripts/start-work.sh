#!/usr/bin/env bash
set -euo pipefail

switch_branch_by_keyword() {
  local keyword="$1"
  local target_branch=""
  local base_ref=""

  if git ck "$keyword"; then
    return 0
  fi

  if command -v git.ck >/dev/null 2>&1; then
    if git.ck "$keyword"; then
      return 0
    fi
  fi

  target_branch="$keyword"
  if [[ "$target_branch" == *" "* ]]; then
    target_branch="${target_branch// /-}"
  fi

  if git show-ref --verify --quiet refs/heads/main; then
    base_ref="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    base_ref="master"
  elif git show-ref --verify --quiet refs/remotes/origin/main; then
    base_ref="origin/main"
  elif git show-ref --verify --quiet refs/remotes/origin/master; then
    base_ref="origin/master"
  else
    echo "No base branch found. Expected one of: main/master/origin/main/origin/master"
    return 1
  fi

  git checkout -b "$target_branch" "$base_ref"
}

if [[ $# -gt 0 ]]; then
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Keyword branch switching requires a git repository."
    exit 1
  fi

  switch_branch_by_keyword "$*"
fi

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
