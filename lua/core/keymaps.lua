local buffers = require("utils.buffers")
local map = vim.keymap.set

-- Fast enter normal mode
map("i", "jj", "<Esc>")

-- Fast quit
map("n", "<leader>q", "<cmd>q!<cr>", { desc = "Quit" })

-- Enter Neotree
map("n", "<leader>e", "<cmd>Neotree reveal<cr>", { desc = "Focus Neotree" })

-- Save
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })

-- Switch between windows
map({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>")
map({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>")
map({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>")
map({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>")

-- Buffer manipulation
map("n", "<leader>x", function()
	buffers.safe_buffer_close()
end, { desc = "Close buffer" })
map("n", "<leader>X", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

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

-- Codex
map({ "n", "t" }, "<leader>aic", function()
	require("utils.codex").toggle()
end, { desc = "AI. Toggle Codex" })
map("n", "<leader>ais", function()
	require("utils.codex").auth_status()
end, { desc = "AI. Codex authentication status" })
map("n", "<leader>air", function()
	require("utils.codex").resume()
end, { desc = "AI. Resume last Codex session" })
map("n", "<leader>aid", function()
	require("utils.codex").doctor()
end, { desc = "AI. Diagnose Codex" })
map("n", "<leader>aiv", function()
	require("utils.codex").review()
end, { desc = "AI. Review Codex changes" })
map("n", "<leader>aim", function()
	local line = vim.fn.line(".")
	require("utils.codex").add_review_comment(line, line)
end, { desc = "AI. Add review comment" })
map("v", "<leader>aim", function()
	require("utils.codex").add_review_comment(vim.fn.line("v"), vim.fn.line("."))
end, { desc = "AI. Add review comment" })
map("n", "<leader>aiM", function()
	require("utils.codex").add_file_review_comment()
end, { desc = "AI. Add file review comment" })
map("n", "<leader>ail", function()
	require("utils.codex").list_review_comments()
end, { desc = "AI. List review comments" })
map("n", "<leader>aif", function()
	require("utils.codex").send_review_comments()
end, { desc = "AI. Send review feedback" })
map("n", "<leader>aiX", function()
	require("utils.codex").clear_review_comments()
end, { desc = "AI. Clear review comments" })

vim.api.nvim_create_user_command("Codex", function()
	require("utils.codex").toggle()
end, { desc = "Toggle Codex CLI" })

vim.api.nvim_create_user_command("CodexStatus", function()
	require("utils.codex").auth_status()
end, { desc = "Show Codex authentication status" })

vim.api.nvim_create_user_command("CodexResume", function()
	require("utils.codex").resume()
end, { desc = "Resume the last Codex CLI session" })

vim.api.nvim_create_user_command("CodexDoctor", function()
	require("utils.codex").doctor()
end, { desc = "Diagnose Codex CLI" })

vim.api.nvim_create_user_command("CodexReview", function()
	require("utils.codex").review()
end, { desc = "Review changes made by Codex" })

vim.api.nvim_create_user_command("CodexComment", function(opts)
	require("utils.codex").add_review_comment(opts.line1, opts.line2)
end, { range = true, desc = "Add a review comment for Codex" })

vim.api.nvim_create_user_command("CodexFileComment", function()
	require("utils.codex").add_file_review_comment()
end, { desc = "Add a file-level review comment for Codex" })

vim.api.nvim_create_user_command("CodexComments", function()
	require("utils.codex").list_review_comments()
end, { desc = "List review comments for Codex" })

vim.api.nvim_create_user_command("CodexCommentsClear", function()
	require("utils.codex").clear_review_comments()
end, { desc = "Clear review comments for Codex" })

vim.api.nvim_create_user_command("CodexReviewSend", function()
	require("utils.codex").send_review_comments()
end, { desc = "Send review comments to Codex" })
