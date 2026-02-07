local map = vim.keymap.set

-- Fast enter normal mode
map("i", "jj", "<Esc>")

-- Fast quit
map("n", "<leader>q", "<cmd>q!<cr>", { desc = "Quit" })

-- Enter Neotree
map("n", "<leader>e", "<cmd>Neotree<cr>", { desc = "Focus Neotree" })

-- Save
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })

-- Switch between windows
map({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>")
map({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>")
map({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>")
map({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>")

-- Buffer manipulation
map("n", "<leader>x", "<cmd>BufferClose<cr>", { desc = "Close buffer" })
map("n", "<S-Tab>", "<cmd>BufferPrevious<cr>", { desc = "Previous buffer" })
map("n", "<Tab>", "<cmd>BufferNext<cr>", { desc = "Next buffer" })

-- Format
map("n", "<leader>fm", "<cmd>Format<cr>", { desc = "Format code" })

-- Split window
map("n", "\\", "<cmd>:vsplit<cr>", { desc = "Open split window" })

-- Trouble toggle
map("n", "<leader>lf", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Show diagnostics" })

-- Lsp code actions
map("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "Code actions" })
map("n", "<leader>ld", function()
	vim.lsp.buf.definition()
end, { desc = "Code. Go to definition" })
map("n", "<leader>lr", function()
	vim.lsp.buf.references()
end, { desc = "Code. Go to references" })
map("n", "<leader>ra", vim.lsp.buf.rename, { desc = "Code. Rename variable" })
map("n", "<leader>ori", "<cmd>TSToolsOrganizeImports<cr>", { desc = "Code. Organize imports" })

-- Alt rows replacement
map("n", "<A-j>", ":m .+1<CR>==")
map("n", "<A-k>", ":m .-2<CR>==")
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- Enter lazygit
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open Lazygit" })

-- Tabulation
map("v", ">", ">gv")
map("v", "<", "<gv")

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find with regex" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find old files" })

-- Terminal
map({ "n", "t" }, "<A-h>", function()
	require("toggleterm").toggle(1, nil, vim.fn.getcwd(), "horizontal")
end, { desc = "Open horizontal terminal" })
map({ "n", "t" }, "<A-i>", function()
	require("toggleterm").toggle(2, nil, vim.fn.getcwd(), "float")
end, { desc = "Open float terminal" })

-- Managers
map("n", "<leader>ml", "<cmd>Lazy<cr>", { desc = "Open Lazy" })
map("n", "<leader>mm", "<cmd>Mason<cr>", { desc = "Open Mason" })

-- AI Keymaps
map("n", "<leader>aii", "<cmd>PrtImplement<cr>", { desc = "AI. Implement commentary" })
map("n", "<leader>aia", "<cmd>PrtAsk<cr>", { desc = "AI. Ask AI" })
map("n", "<leader>aic", "<cmd>PrtChatToggle<cr>", { desc = "AI. Open chat" })
map("n", "<leader>air", "<cmd>PrtChatResponde<cr>", { desc = "AI. Response an answer in chat" })
