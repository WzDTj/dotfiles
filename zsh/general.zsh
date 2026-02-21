export EDITOR=nvim
alias e=$EDITOR

export FILE_MANAGER=yazi
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
bindkey -s '^e' 'yazi\n'


