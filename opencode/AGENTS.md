# OPENCODE KNOWLEDGE BASE

Scope: applies to files under `opencode/`.
For repository-wide rules, read `AGENTS.md` first.

## OVERVIEW
Runtime and model/category configuration for opencode + oh-my-opencode plugin behavior.

## WHERE TO LOOK
| Task | Location | Notes |
|---|---|---|
| Core opencode config | `opencode/opencode.json` | schema + theme + plugin enablement |
| Agent/category tuning | `opencode/oh-my-opencode.json` | models, variants, tmux layout, categories |
| Plugin dependency pin | `opencode/package.json` | `@opencode-ai/plugin` dependency |
| Runtime ignore policy | `opencode/.gitignore` | ignores runtime artifacts and local package metadata |

## CONVENTIONS
- Runtime behavior is config-first; changes should happen in JSON, not generated dependencies.
- Agent model routing is centralized in `oh-my-opencode.json` (`agents` + `categories`).
- Keep dependency surface minimal in `package.json`.

## ANTI-PATTERNS
- Do not edit `node_modules/` or `.opencode/` internals; these are generated/vendor paths.
- Do not assume ignored files (`package.json`, lockfiles, runtime account artifacts) are stable source-of-truth.
- Do not change model IDs/variants casually; they alter behavior across all categories and agents.

## NOTES
- `.gitignore` in this subtree intentionally excludes runtime artifacts (`antigravity-*`, logs) and local dependency state.
- `oh-my-opencode.json` includes both direct agents (`oracle`, `explore`, `librarian`) and category mappings (`quick`, `deep`, `writing`, etc.).
- `opencode/.opencode/` is runtime workspace state and should remain out of authored documentation logic.
