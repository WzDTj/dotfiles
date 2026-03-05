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

-- LSP diagnostic
vim.diagnostic.config({ virtual_text = false })
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "<leader>d", vim.diagnostic.setloclist)

-- LSP navigation
map("n", "<leader>gd", vim.lsp.buf.definition)
map("n", "<leader>gD", vim.lsp.buf.declaration)
map("n", "<leader>gi", vim.lsp.buf.implementation)
map("n", "<leader>gr", vim.lsp.buf.references)
map("n", "<leader>gt", vim.lsp.buf.type_definition)

-- lsp code actions
map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "<leader>o", vim.lsp.buf.outgoing_calls)
map("n", "<leader>i", vim.lsp.buf.incoming_calls)
 
