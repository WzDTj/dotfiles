local opt = vim.opt

-- Appearance
opt.showmode = false
opt.fillchars = { eob = " " }
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.laststatus = 3
opt.cmdheight = 1
opt.showmatch = true
opt.colorcolumn = "120"
opt.textwidth = 120

-- File
opt.fileformat = "unix"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = { "utf-8", "ucs-bom", "GB2312", "big5" }
opt.autoread = true
opt.swapfile = false

-- Editor
opt.splitright = true
opt.splitbelow = true
opt.hidden = true
opt.mouse = "a"
opt.updatetime = 100
opt.backspace = { "indent", "eol", "start" }
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true
opt.ruler = true
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false

-- Search
opt.hlsearch = true
opt.smartcase = true
opt.ignorecase = true
opt.incsearch = true

-- Indent
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

-- Disable unused built-in plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
