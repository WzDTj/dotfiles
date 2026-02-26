# SCRIPTS KNOWLEDGE BASE

Scope: applies to files under `scripts/`.
For repository-wide rules, read `AGENTS.md` first.

## OVERVIEW
Operational entry scripts for daily work sessions and git helper flows.

## WHERE TO LOOK
| Task | Location | Notes |
|---|---|---|
| Start workspace | `scripts/start-work.sh` | tmux layout + optional keyword branch flow |
| Stop workspace | `scripts/stop-work.sh` | safety check: pane paths must match current repo |
| AI commit subject + commit | `scripts/git-generate-commit-message.sh` | requires staged diff + `codex` CLI |
| Branch by keyword | `scripts/git-checkout-by-keyword.sh` | chooses latest matching local branch |
| Push + merge helper | `scripts/git-push-merge.sh` | pushes current branch and merges into target |

## CONVENTIONS
- Scripts are direct executables; no Makefile/task runner wrapper.
- `start-work.sh` is the orchestration source-of-truth for tmux pane/window layout.
- Git helpers are intentionally small and non-interactive except commit-message chooser.

## ANTI-PATTERNS
- Do not run `git-push-merge.sh` on sensitive branches without reviewing target branch state first.
- Do not remove `set -euo pipefail` safeguards from scripts.
- Do not call `start-work.sh` assuming it only attaches tmux; it may create branches and launch external tools.

## COMMANDS
```bash
./scripts/start-work.sh
./scripts/start-work.sh <keyword>
./scripts/stop-work.sh
./scripts/git-generate-commit-message.sh
./scripts/git-checkout-by-keyword.sh <pattern>
./scripts/git-push-merge.sh <target-branch>
```

## NOTES
- `start-work.sh` uses base-branch fallback order: `main`, `master`, `origin/main`, `origin/master`.
- Default generated branch naming: `<keyword>_dantong.jin_<YYYYMMDD>_`.
