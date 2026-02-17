local map = vim.keymap.set

-- General
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>-", ":vs ", { desc = "Vertical split" })
map("n", "<leader>=", ":sp ", { desc = "Horizontal split" })

-- Buffer
map("n", "<leader>db", "<cmd>bd<cr>", { desc = "Delete buffer" })
map("n", "<leader>ls", ":ls<cr>:b ", { desc = "List buffers" })

-- Copy & Paste (system clipboard)
map("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
map("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })

-- Tab
map("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprev<cr>", { desc = "Prev tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- Clear search highlight
map("n", "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear highlight" })
