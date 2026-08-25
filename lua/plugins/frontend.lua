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
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {
			root_dir = function(bufnr, on_dir)
				local name = vim.api.nvim_buf_get_name(bufnr)
				-- Diffview's historical side uses virtual buffer names such as
				-- `diffview://...`, which typescript-tools intentionally rejects.
				if name == "" or name:match("^diffview://") or vim.bo[bufnr].buftype ~= "" then
					return
				end
				on_dir(require("typescript-tools.utils").get_root_dir(bufnr))
			end,
		},
	},

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
