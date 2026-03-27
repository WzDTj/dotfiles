export EDITOR=nvim
alias e=$EDITOR

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
export FILE_MANAGER=y
alias fm=$FILE_MANAGER

# FZF
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'

# Proxy by surge
export https_proxy=http://127.0.0.1:6152
export http_proxy=http://127.0.0.1:6152
export all_proxy=socks5://127.0.0.1:6153
export NO_PROXY=localhost,127.0.0.1

# Maestro
export PATH=$PATH:$HOME/.maestro/bin

# map <C-e> to open the current directory in yazi
bindkey -s '^e' '$FILE_MANAGER\n'


alias start-work='$HOME/WorkSpace/dotfiles/scripts/start-work.sh'
alias stop-work='$HOME/WorkSpace/dotfiles/scripts/stop-work.sh'

start_work_update_title() {
  local dir branch title tmux_session
  dir="${PWD##*/}"

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
  else
    branch=""
  fi

  title="$dir"
  [[ -n $branch ]] && title="$dir: $branch"

  if [[ -n ${TMUX:-} ]]; then
    if command -v tmux >/dev/null 2>&1; then
      tmux_session="$(tmux display-message -p '#S' 2>/dev/null || true)"
      if [[ -n "$tmux_session" ]]; then
        tmux set-option -t "$tmux_session" set-titles on 2>/dev/null || true
        tmux set-option -t "$tmux_session" set-titles-string "$title" 2>/dev/null || true
      fi
    fi
    # Pass OSC through tmux so outer terminal tab title updates correctly.
    printf '\ePtmux;\e\e]0;%s\a\e\\' "$title"
  else
    printf '\e]0;%s\a' "$title"
  fi
}

if [[ -z ${START_WORK_TITLE:-} && -n ${TMUX:-} ]] && command -v tmux >/dev/null 2>&1; then
  typeset tmux_start_work_title
  tmux_start_work_title="$(tmux show-environment -g START_WORK_TITLE 2>/dev/null || true)"
  if [[ "$tmux_start_work_title" == START_WORK_TITLE=* ]]; then
    export START_WORK_TITLE="${tmux_start_work_title#START_WORK_TITLE=}"
  fi
fi

if [[ -n ${START_WORK_TITLE:-} ]]; then
  autoload -Uz add-zsh-hook
  # Keep tab title as current directory during start-work sessions.
  (( ${+functions[omz_termsupport_preexec]} )) && add-zsh-hook -d preexec omz_termsupport_preexec
  (( ${+functions[omz_termsupport_precmd]} )) && add-zsh-hook -d precmd omz_termsupport_precmd
  (( ${precmd_functions[(I)start_work_update_title]:-0} == 0 )) && add-zsh-hook precmd start_work_update_title
  (( ${chpwd_functions[(I)start_work_update_title]:-0} == 0 )) && add-zsh-hook chpwd start_work_update_title
  start_work_update_title
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
