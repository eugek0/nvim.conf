return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")

			treesitter.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
				indent = { enable = true },
				highlight = {
					additional_vim_regex_highlighting = false,
					enable = true,
				},
			})
			treesitter.install({
				"lua",
				"html",
				"css",
				"go",
				"javascript",
				"typescript",
				"tsx",
				"prisma",
				"python",
				"rust",
				"c_sharp",
				"cpp",
				"bash",
				"sql",
			})
		end,
	},
}
