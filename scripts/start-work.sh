#!/usr/bin/env zsh
set -euo pipefail

# Find an available port starting from the given port
find_available_port() {
  local start_port="$1"
  local port="$start_port"
  
  while true; do
    # Check if port is available (no process listening)
    if ! lsof -Pi ":$port" -sTCP:LISTEN -t >/dev/null 2>&1 && \
       ! netstat -an 2>/dev/null | grep -q ".$port " && \
       ! ss -tln 2>/dev/null | grep -q ":$port "; then
      echo "$port"
      return 0
    fi
    ((port++))
    # Safety limit: don't search forever
    if [[ $port -gt $((start_port + 100)) ]]; then
      echo "Could not find available port in range $start_port-$port" >&2
      return 1
    fi
  done
}

switch_branch_by_keyword() {
  local keyword="$1"
  local normalized_keyword=""
  local date_str=""
  local default_branch_name=""
  local input_branch_name=""
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

  normalized_keyword="${keyword// /-}"
  date_str="$(date +%Y%m%d)"
  default_branch_name="${normalized_keyword}_dantong.jin_${date_str}_"

  if [[ -t 0 ]]; then
    if whence -w vared >/dev/null 2>&1; then
      input_branch_name="$default_branch_name"
      vared -p "Branch name: " input_branch_name
      target_branch="${input_branch_name:-$default_branch_name}"
    else
      read -r "input_branch_name?Branch name [${default_branch_name}]: "
      target_branch="${input_branch_name:-$default_branch_name}"
    fi
  else
    target_branch="$default_branch_name"
  fi

  if [[ -z "$target_branch" ]]; then
    echo "Branch name cannot be empty."
    return 1
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

  if git show-ref --verify --quiet "refs/heads/${target_branch}"; then
    git checkout "$target_branch"
    return 0
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

# Find available port for opencode (starting from 4096)
opencode_port=$(find_available_port 4096)
tmux new-session -d -s "$session_name" -c "$PWD" -x "$(tput cols)" -y "$(tput lines)"
tmux new-window -d -c "$PWD" "opencode --port $opencode_port"
tmux attach-session -t "$session_name"
