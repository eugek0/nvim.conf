return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				go = { "gofmt" },
				lua = { "stylua" },
				css = { "prettierd", "biome", stop_after_first = true },
				scss = { "prettierd", "biome", stop_after_first = true },
				html = { "prettierd", "biome", stop_after_first = true },
				javascript = { "prettierd", "biome", stop_after_first = true },
				typescript = { "prettierd", "biome", stop_after_first = true },
				javascriptreact = { "prettierd", "biome", stop_after_first = true },
				typescriptreact = { "prettierd", "biome", stop_after_first = true },
				json = { "prettierd", "biome", stop_after_first = true },
				sql = { "pgformatter" },
				toml = { "taplo" },
				python = { "autopep8" },
			},
		})
		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			conform.format({ async = true, lsp_format = "fallback", range = range })
		end, { range = true })
	end,
}
