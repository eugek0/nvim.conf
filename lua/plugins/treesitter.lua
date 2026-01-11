return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			ensure_installed = {
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
			},
		},
	},
}
