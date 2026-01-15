return {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				toggler = {
					line = "<Space>/",
				},
				opleader = {
					line = "<Space>/",
				},
			})
		end,
	},

	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
	},

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
		"nvim-mini/mini.diff",
		version = "*",
		config = function()
			require("mini.diff").setup({
				view = {
					style = vim.opt.number and "number" or "sign",
				},
			})
		end,
	},

	{
		"echasnovski/mini.pairs",
		config = function()
			require("mini.pairs").setup({
				mappings = {
					["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
					[">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
				},
			})
		end,
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
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup()
		end,
		event = "BufReadPost",
	},

	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
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
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 200,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			})
		end,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
}
