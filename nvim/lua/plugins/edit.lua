return {
  -- Completion engine
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

  -- AI completion
  {
    "github/copilot.vim",
    lazy = false,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        -- Web/JavaScript ecosystem
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },

        -- Lua
        lua = { "stylua" },

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
      },

      format_on_save = function(bufnr)
        -- Organize imports via ts_ls before conform formats.
        local client = vim.lsp.get_clients({ bufnr = bufnr, name = "ts_ls" })[1]
        if client then
          local params = {
            textDocument = vim.lsp.util.make_text_document_params(bufnr),
            range = {
              start = { line = 0, character = 0 },
              ["end"] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
            },
            context = { only = { "source.organizeImports" }, diagnostics = {} },
          }
          local result = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
          for _, action in ipairs((result and result.result) or {}) do
            if action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
            elseif action.command then
              client:exec_cmd(action.command)
            end
          end
        end

        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    },
  },
}
