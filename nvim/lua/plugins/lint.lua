return {
  -- LSP package manager + LSP configs
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  -- Syntax highlighting and folding
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
  },

  -- Diagnostics configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config({ virtual_text = false })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist)
    end,
  },

  -- LSP keymaps
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition)
      vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration)
      vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation)
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references)
      vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
      vim.keymap.set("n", "<leader>o", vim.lsp.buf.outgoing_calls)
      vim.keymap.set("n", "<leader>i", vim.lsp.buf.incoming_calls)
    end,
  },
}
