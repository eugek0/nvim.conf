-- Turn on neovim provided treesitter for .tsx and .jsx files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
	callback = function()
		vim.treesitter.start()
	end,
})
