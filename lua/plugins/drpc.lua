return {
	{
		"vyfor/cord.nvim",
		event = "VeryLazy",
		build = ":Cord update",
		opts = {
			editor = {
				client = "nvchad",
				tooltip = "NvChad",
			},

			display = {
				theme = "atom",
				flavor = "accent",
			},
		},
	},
}
