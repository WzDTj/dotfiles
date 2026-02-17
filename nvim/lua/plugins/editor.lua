return {
  -- Fuzzy finder (replaces fzf.vim)
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>rg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fz", "<cmd>Telescope live_grep<cr>", desc = "Live grep (alias)" },
      { "<leader><leader>", "<cmd>Telescope commands<cr>", desc = "Commands" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          file_ignore_patterns = { ".git/", "node_modules/", "dist/", "vendor/" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
            },
            n = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
            },
          },
        },
      }
    end,
  },

  -- Comment (replaces nerdcommenter)
  {
    "numToStr/Comment.nvim",
    keys = {
      { "//", "<Plug>(comment_toggle_linewise_current)", desc = "Toggle comment" },
      { "//", "<Plug>(comment_toggle_linewise_visual)", mode = "v", desc = "Toggle comment" },
    },
    opts = {},
  },

  -- Input method switch (replaces smartim)
  {
    "keaising/im-select.nvim",
    event = "InsertLeave",
    opts = {
      default_im_select = "com.apple.keylayout.ABC",
    },
  },
}
