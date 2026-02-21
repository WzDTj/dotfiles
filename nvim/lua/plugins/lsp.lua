return {

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
  },

  {
    "github/copilot.vim",
    lazy = false,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<TAB>'] = cmp.mapping(function (fallback) 
            if cmp.visible() then
              cmp.confirm({ select = true })
             else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({ 
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'path' },
        }, {
          { name = 'buffer' }, 
        })
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })

    end,
  },

  -- {
  --   "neoclide/coc.nvim",
  --   branch = "release",
  --   lazy = false,
  --   init = function()
  --     vim.g.coc_global_extensions = {
  --       "coc-lua",
  --       "coc-css",
  --       "coc-eslint",
  --       "coc-html",
  --       "coc-json",
  --       "coc-prettier",
  --       "coc-pairs",
  --       "coc-tsserver",
  --     }
  --   end,
  --   config = function()

  --     local keyset = vim.keymap.set

  --     local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

  --     -- Use `[g` and `]g` to navigate diagnostics
  --     -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
  --     keyset('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
  --     keyset('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })

  --     -- GoTo code navigation
  --     keyset('n', 'gd', '<Plug>(coc-definition)', { silent = true })
  --     keyset('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
  --     keyset('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
  --     keyset('n', 'gr', '<Plug>(coc-references)', { silent = true })



  --     -- Apply codeAction to the selected region
  --     -- Example: `<leader>aap` for current paragraph
  --     local opts = { silent = true, nowait = true }
  --     keyset('x', '<leader>a', '<Plug>(coc-codeaction-selected)', opts)
  --     keyset('n', '<leader>a', '<Plug>(coc-codeaction-selected)', opts)

  --     -- Remap keys for apply code actions at the cursor position.
  --     keyset('n', '<leader>ac', '<Plug>(coc-codeaction-cursor)', opts)
  --     -- Remap keys for apply source code actions for current file.
  --     keyset('n', '<leader>as', '<Plug>(coc-codeaction-source)', opts)
  --     -- Apply the most preferred quickfix action on the current line.
  --     keyset('n', '<leader>qf', '<Plug>(coc-fix-current)', opts)

  --     -- Remap keys for apply refactor code actions.
  --     keyset('n', '<leader>re', '<Plug>(coc-codeaction-refactor)', { silent = true })
  --     keyset('x', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', { silent = true })
  --     keyset('n', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', { silent = true })

  --     -- Add `:Format` command to format current buffer
  --     vim.api.nvim_create_user_command('Format', "call CocAction('format')", {})

  --     -- " Add `:Fold` command to fold current buffer
  --     vim.api.nvim_create_user_command('Fold', "call CocAction('fold', <f-args>)", { nargs = '?' })

  --     -- Add `:OR` command for organize imports of the current buffer
  --     vim.api.nvim_create_user_command('OR', "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})


  --     -- Mappings for CoCList
  --     -- code actions and coc stuff
  --     ---@diagnostic disable-next-line: redefined-local
  --     local opts = { silent = true, nowait = true }
  --     -- Show all diagnostics
  --     keyset('n', '<space>a', ':<C-u>CocList diagnostics<cr>', opts)
  --     -- Manage extensions
  --     keyset('n', '<space>e', ':<C-u>CocList extensions<cr>', opts)
  --     -- Show commands
  --     keyset('n', '<space>c', ':<C-u>CocList commands<cr>', opts)
  --     -- Find symbol of current document
  --   end,
  -- },
}
