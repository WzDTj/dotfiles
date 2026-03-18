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

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
