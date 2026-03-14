#!/usr/bin/env zsh
set -euo pipefail

script_dir="${0:A:h}"
current_dir="${PWD:A}"

typeset -A tmux_layout_bindings=(
  "$HOME/WorkSpace/comiru-app" "$script_dir/tmux-layout-react-native.sh"
  "$HOME/WorkSpace/comiru-recorder" "$script_dir/tmux-layout-react-native.sh"
)

tmux_layout_script="${tmux_layout_bindings[$current_dir]:-$script_dir/tmux-layout.sh}"

if [[ $# -gt 0 ]]; then
  "$script_dir/git-checkout-or-create.sh" "$*"
fi

"$tmux_layout_script"
