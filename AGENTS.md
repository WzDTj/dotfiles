# PROJECT KNOWLEDGE BASE

**Generated:** 2026-02-26 08:19 CST
**Commit:** `5396efe`
**Branch:** `main`

## OVERVIEW
Personal dotfiles repository for macOS-focused shell, Neovim, tmux, and local workflow automation.
Main behavior is script-driven (`scripts/`) plus runtime tool config (`opencode/`).

## STRUCTURE
```text
dotfiles/
|- zsh/        # shell environment modules sourced by ~/.zshrc
|- nvim/       # Neovim core config + plugin specs
|- scripts/    # workflow entry scripts (tmux + git helpers)
|- tmux/       # tmux keybindings and pane/window behavior
|- opencode/   # opencode + oh-my-opencode runtime config
`- README.md
```

## WHERE TO LOOK
| Task | Location | Notes |
|---|---|---|
| Start/stop work session | `scripts/start-work.sh`, `scripts/stop-work.sh` | tmux session named from `basename "$PWD"` |
| Branch helper flows | `scripts/start-work.sh`, `scripts/git-checkout-by-keyword.sh` | keyword-to-branch fallback logic |
| AI commit subject flow | `scripts/git-generate-commit-message.sh` | depends on `codex` CLI and staged diff |
| Shell defaults and aliases | `zsh/.zshrc`, `zsh/general.zsh` | `.zshrc` sources `~/.config/zsh/*.zsh` |
| Git aliases | `zsh/git.zsh` | runs `git config --global alias.*` on shell load |
| Neovim startup and plugins | `nvim/init.lua`, `nvim/lua/plugins/*.lua` | lazy.nvim setup, LSP/completion |
| Opencode agent/runtime tuning | `opencode/opencode.json`, `opencode/oh-my-opencode.json` | model/category definitions |

## AGENTS HIERARCHY
Scoring result from repository scan:

| Path | Score | Decision | Reason |
|---|---:|---|---|
| `.` | root | Create | required root router |
| `zsh/` | 11 | Create | highest file density + shell entrypoint |
| `nvim/` | 8 | Create | distinct editor domain + init boundary |
| `scripts/` | 8 | Create | command orchestration hub |
| `opencode/` | 8 | Create | distinct runtime/tooling domain |
| `tmux/` | 6 | Skip | one-file domain; covered by root + scripts |

## CONVENTIONS
- No repo-level CI/task runner: no `.github/workflows/`, `Makefile`, `Justfile`, or test harness present.
- Most behavior is local-command driven; scripts are executed directly from `scripts/`.
- Editor behavior is contributor-local via `nvim/coc-settings.json` (format-on-save, eslint fix-on-save, prettier without repo config).
- `opencode/.gitignore` intentionally ignores runtime artifacts and also ignores `package.json` in that subtree.

## ANTI-PATTERNS (THIS PROJECT)
- Do not treat `opencode/node_modules/` or `opencode/.opencode/` as source-of-truth; they are dependency/runtime noise.
- Do not run git history rewrite helpers blindly on shared branches; `git-push-merge.sh` is direct and non-interactive.
- Do not assume `start-work.sh` is passive; it launches `lazygit` and `opencode --port 4096` automatically.
- Do not rely on centralized lint/test enforcement in this repo; there is no CI or canonical linter config.

## UNIQUE STYLES
- Work session model: project-name tmux session + fixed pane layout + editor/git/agent split.
- Branch naming fallback in `start-work.sh`: `<keyword>_dantong.jin_<YYYYMMDD>_`.
- Shell modularity: feature-specific files (`mise.zsh`, `java.zsh`, `android.zsh`) sourced from `.zshrc`.

## COMMANDS
```bash
# Start tmux work session (optional keyword -> branch flow)
./scripts/start-work.sh
./scripts/start-work.sh <keyword>

# Stop the project tmux session safely
./scripts/stop-work.sh

# AI-assisted commit subject (requires staged changes + codex)
./scripts/git-generate-commit-message.sh

# Git convenience helpers
./scripts/git-checkout-by-keyword.sh <pattern>
./scripts/git-push-merge.sh <target-branch>
```

## NOTES
- Prerequisites for default workflow: `tmux`, `lazygit`, `git`, `opencode`; plus `codex` for commit-message helper; plus `ripgrep` for FZF integration.
- `start-work.sh` uses tmux session naming: `basename "$PWD"` — relied on by `stop-work.sh` for safety checks.
- Branch naming fallback in `start-work.sh`: `<keyword>_dantong.jin_<YYYYMMDD>_`.
- AI commit helper enforces: max 50 chars, imperative mood, Conventional Commit style when appropriate.
- Git aliases in `zsh/git.zsh` use absolute paths — relocate repo or adjust aliases if installed elsewhere.
- For focused rules, read child files: `zsh/AGENTS.md`, `nvim/AGENTS.md`, `scripts/AGENTS.md`, `opencode/AGENTS.md`.
