# NVIM KNOWLEDGE BASE

Scope: applies to files under `nvim/`.
For repository-wide rules, read `AGENTS.md` first.

## OVERVIEW
Neovim config split into core options/keymaps plus lazy.nvim plugin specs.

## WHERE TO LOOK
| Task | Location | Notes |
|---|---|---|
| Startup path | `nvim/init.lua` | bootstraps lazy.nvim and loads `config.*` |
| Core editor behavior | `nvim/lua/config/options.lua` | textwidth, diagnostics, folds, defaults |
| Keymap layer | `nvim/lua/config/keymaps.lua` | leader mappings and workflow shortcuts |
| LSP/completion stack | `nvim/lua/plugins/lsp.lua` | mason-lspconfig, nvim-cmp, treesitter |
| Search/editor UX | `nvim/lua/plugins/editor.lua` | telescope + input method switch |
| Visual layer | `nvim/lua/plugins/ui.lua` | nord, bufferline, lualine, gitsigns |
| COC local behavior | `nvim/coc-settings.json` | format-on-save and eslint fix-on-save |

## CONVENTIONS
- Plugin declarations are grouped by concern (`plugins/lsp.lua`, `plugins/editor.lua`, `plugins/ui.lua`).
- Core defaults and mappings stay under `lua/config/`, not inside plugin specs.
- Leader key is backtick and should stay consistent with existing mappings.

## ANTI-PATTERNS
- Do not duplicate keymaps between `config/keymaps.lua` and plugin `opts` unless a plugin requires local binding.
- Do not introduce a second colorscheme bootstrap path; `ui.lua` already owns colorscheme load.
- Do not assume repo-level lint/format config exists; editor behavior here may differ from other contributors.

## NOTES
- `coc-settings.json` keeps formatter/lint automation even though COC plugin block is currently commented in `plugins/lsp.lua`.
- Treesitter update runs through plugin build hook (`:TSUpdate`).
