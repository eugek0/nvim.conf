return {
	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewFileHistory",
			"DiffviewFocusFiles",
			"DiffviewToggleFiles",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			enhanced_diff_hl = true,
			view = {
				merge_tool = {
					layout = "diff3_mixed",
				},
			},
		},
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git. Review changes" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git. File history" },
			{ "<leader>gf", "<cmd>DiffviewFocusFiles<cr>", desc = "Git. Focus changed files" },
			{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Git. Close review" },
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
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")
					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
					end
					local function confirm_reset(range)
						if vim.fn.confirm("Discard this change?", "&Discard\n&Cancel", 2) == 1 then
							gitsigns.reset_hunk(range)
						end
					end

					map("n", "]h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end, "Git. Next hunk")
					map("n", "[h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, "Git. Previous hunk")

					map("n", "<leader>gp", gitsigns.preview_hunk_inline, "Git. Preview hunk")
					map("n", "<leader>gs", gitsigns.stage_hunk, "Git. Stage/unstage hunk")
					map("n", "<leader>gr", confirm_reset, "Git. Reset hunk")
					map("v", "<leader>gs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, "Git. Stage selected lines")
					map("v", "<leader>gr", function()
						confirm_reset({ vim.fn.line("."), vim.fn.line("v") })
					end, "Git. Reset selected lines")
					map("n", "<leader>gb", function()
						gitsigns.blame_line({ full = true })
					end, "Git. Blame line")
					map({ "o", "x" }, "ih", gitsigns.select_hunk, "Git hunk")
				end,
			})
		end,
	},
}
