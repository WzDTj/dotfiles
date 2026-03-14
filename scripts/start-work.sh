#!/usr/bin/env zsh
set -euo pipefail

script_dir="${0:A:h}"

if [[ $# -gt 0 ]]; then
  "$script_dir/git-checkout-or-create.sh" "$*"
fi

"$script_dir/tmux-layout.sh"
