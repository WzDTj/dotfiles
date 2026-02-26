# Dotfiles Environment Loader
# Loads environment variables from ~/.config/.env

DOTFILES_ENV="${HOME}/.config/.env"

# Load .env file if it exists
if [[ -f "$DOTFILES_ENV" ]]; then
  # Use 'source' with a subshell to export all variables
  # This handles both KEY=value and export KEY=value formats
  set -a
  source "$DOTFILES_ENV" 2>/dev/null || true
  set +a
fi
