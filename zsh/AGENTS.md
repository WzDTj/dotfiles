# ZSH KNOWLEDGE BASE

Scope: applies to files under `zsh/`.
For repository-wide rules, read `AGENTS.md` first.

## OVERVIEW
Shell bootstrap and environment modules loaded by `.zshrc`.

## WHERE TO LOOK
| Task | Location | Notes |
|---|---|---|
| Root shell bootstrap | `zsh/.zshrc` | sources all module files |
| Global aliases and proxy | `zsh/general.zsh` | includes `start-work` and `stop-work` aliases |
| Git shortcuts | `zsh/git.zsh` | writes global git aliases on shell startup |
| Runtime managers | `zsh/nvm.zsh`, `zsh/pnpm.zsh`, `zsh/bun.zsh`, `zsh/rvm.zsh` | PATH + completion setup |
| Platform SDK setup | `zsh/android.zsh`, `zsh/java.zsh` | exports Android/JDK paths |

## CONVENTIONS
- Keep each tool/runtime in a dedicated module file; do not pack everything into `.zshrc`.
- `.zshrc` is only a source-order router; keep logic in module files.
- Alias naming is short and task-oriented (`e`, `fm`, `start-work`, `stop-work`).

## ANTI-PATTERNS
- Do not add heavyweight shell logic to `.zshrc`; place it in a module.
- Do not remove PATH guards (`case ":$PATH:"`) in runtime modules.
- Do not move `git config --global alias.*` commands out of `zsh/git.zsh` unless you replace that bootstrap behavior explicitly.

## NOTES
- `.zshrc` sources from `~/.config/zsh/*.zsh`; this repo assumes symlinked deployment.
- Proxy defaults in `zsh/general.zsh` are local-machine assumptions (`127.0.0.1` ports).
