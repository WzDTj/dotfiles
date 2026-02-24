git config --global alias.ck '!git checkout `git branch --format "%(refname:short)" | grep "$1" | tail -n 1` #'
git config --global alias.pm '!$HOME/WorkSpace/scripts/git-push-merge/run.sh'
git config --global alias.gcm '!$HOME/WorkSpace/dotfiles/scripts/generate-commit-message.sh'
