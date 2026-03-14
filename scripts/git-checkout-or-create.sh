#!/usr/bin/env zsh
set -euo pipefail

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

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <keyword>"
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Keyword branch switching requires a git repository."
  exit 1
fi

switch_branch_by_keyword "$*"
