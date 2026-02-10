return {
	{
		"vyfor/cord.nvim",
		event = "VeryLazy",
		build = ":Cord update",
		opts = {
			editor = {
				client = "neovim",
				tooltip = "Neovim",
			},

			display = {
				theme = "minecraft",
				flavor = "accent",
			},
		},
	},
}
