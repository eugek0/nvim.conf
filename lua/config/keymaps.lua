-- Fast enter normal mode
vim.keymap.set("i", "jj", "<Esc>")

-- Fast quit
vim.keymap.set("n", "<leader>q", "<cmd>q!<cr>")

-- Enter NvimTree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<cr>")

-- Save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")

-- Switch between windows
vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>")
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>")
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>")
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>")

-- Buffer manipulation
vim.keymap.set("n", "<leader>x", "<cmd>BufferClose<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferPrevious<cr>")
vim.keymap.set("n", "<Tab>", "<cmd>BufferNext<cr>")

-- Format
vim.keymap.set("n", "<leader>fm", "<cmd>Format<cr>")

-- Split window
vim.keymap.set("n", "\\", "<cmd>:vsplit<cr>")

-- Trouble toggle
vim.keymap.set("n", "<leader>lf", "<cmd>Trouble diagnostics toggle<cr>")

-- Lsp code actions
vim.keymap.set("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end)
vim.keymap.set("n", "<leader>ld", function()
	vim.lsp.buf.definition()
end)
vim.keymap.set("n", "<leader>lr", function()
	vim.lsp.buf.references()
end)

-- Alt rows replacement
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- Enter lazygit
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open Lazygit" })

-- Tabulation
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>")

-- Terminal
vim.keymap.set({ "n", "t" }, "<A-h>", function()
	require("toggleterm").toggle(1, nil, vim.fn.getcwd(), "horizontal")
end)
vim.keymap.set({ "n", "t" }, "<A-i>", function()
	require("toggleterm").toggle(2, nil, vim.fn.getcwd(), "float")
end)
