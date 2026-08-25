# mise manages runtime versions for Node.js, Ruby, and other tools.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
