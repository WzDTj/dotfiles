#!/usr/bin/env zsh
set -euo pipefail

find_available_port() {
  local start_port="$1"
  local port="$start_port"

  while true; do
    if ! lsof -Pi ":$port" -sTCP:LISTEN -t >/dev/null 2>&1 && \
       ! netstat -an 2>/dev/null | grep -q ".$port " && \
       ! ss -tln 2>/dev/null | grep -q ":$port "; then
      echo "$port"
      return 0
    fi
    ((port++))
    if [[ $port -gt $((start_port + 100)) ]]; then
      echo "Could not find available port in range $start_port-$port" >&2
      return 1
    fi
  done
}

session_name="$(basename "$PWD")"
branch="$(git -C "$PWD" symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
title="$session_name"
[[ -n "$branch" ]] && title="$session_name: $branch"

if tmux has-session -t "$session_name" 2>/dev/null; then
  :
else
  opencode_port="$(find_available_port 4096)"
  tmux new-session -d -s "$session_name" -c "$PWD" -x "$(tput cols)" -y "$(tput lines)"
  tmux new-window -d -c "$PWD" "opencode --port $opencode_port"
  tmux new-window -d -c "$PWD"
fi

tmux set-option -t "$session_name" set-titles on 2>/dev/null || true
tmux set-option -t "$session_name" set-titles-string "$title" 2>/dev/null || true
tmux attach-session -t "$session_name"
