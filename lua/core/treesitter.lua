-- Turn on neovim provided treesitter
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact", "markdown" },
	callback = function()
		vim.treesitter.start()
	end,
})
