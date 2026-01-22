return {
	-- {
	-- 	"neoclide/vim-jsx-improve",
	-- },

	-- {
	-- 	"HerringtonDarkholme/yats.vim",
	-- 	config = function()
	-- 		vim.g.yats_host_keyword = 1
	-- 		vim.re = 0
	-- 	end,
	-- },

	{
		"nvzone/minty",
		cmd = { "Shades", "Huefy" },
	},

	{
		"dmmulroy/tsc.nvim",
		config = function()
			require("tsc").setup({
				-- Your config here
			})
		end,
	},

	{
		"mattn/emmet-vim",
	},
}
