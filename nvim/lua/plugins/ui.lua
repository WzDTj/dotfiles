return {
  -- Nord colorscheme
  {
    "nordtheme/vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nord")
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_b = {
          { "diff" },
        },
        lualine_c = {
          { "diagnostics" }
        },
        lualine_x = {
          { 'filename', path = 1 },
        },
        lualine_y = {
          { "filetype", icon_only = true },
        },
        lualine_z = {
          { "location" },
        },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
      },
      current_line_blame = true,
    },
  },
}
