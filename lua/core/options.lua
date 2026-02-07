vim.opt.number = true
vim.opt.relativenumber = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.syntax_on = false
vim.opt.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.scrolloff = 8
vim.opt.wrap = false

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.cmd("colorscheme bamboo-multiplex")
vim.o.background = "dark"
