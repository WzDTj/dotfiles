return {
  -- Input method switch (replaces smartim)
  {
    "keaising/im-select.nvim",
    event = "InsertLeave",
    opts = {
      default_im_select = "com.apple.keylayout.ABC",
    },
  },
}
