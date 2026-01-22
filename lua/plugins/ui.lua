return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "BufReadPost",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				options = {
					multilines = {
						enabled = true,
						always_show = true,
					},
				},
			})
		end,
	},

	{
		"nvzone/volt",
		lazy = true,
	},

	{
		"nvim-lualine/lualine.nvim",
		opts = {},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},

	{
		"echasnovski/mini.icons",
		version = "*",
		lazy = true,
		config = function()
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()
		end,
		specs = {
			{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	{
		"romgrk/barbar.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"lewis6991/gitsigns.nvim",
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {},
		version = "^1.0.0",
	},

	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				update_focused_file = {
					enable = true,
					update_root = true,
				},
			})
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"echasnovski/mini.animate",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.animate").setup()
		end,
	},

	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			require("notify").setup({
				stages = "slide",
				timeout = 3000,
				render = "wrapped-compact",
				background_colour = "#000000",
				minimum_width = 50,
				max_width = 75,
				fps = 60,
			})

			vim.notify = require("notify")
		end,
	},

	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		opts = {},
		cmd = "Trouble",
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},
}
