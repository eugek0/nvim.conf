local groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"FloatBorder",
	"SignColumn",
	"EndOfBuffer",
	"MsgArea",
	"StatusLine",
	"StatusLineNC",
	"WinSeparator",
	"VertSplit",
	"FoldColumn",
}

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		for _, group in ipairs(groups) do
			vim.api.nvim_set_hl(0, group, { bg = "none" })
		end

		vim.cmd([[
  colorscheme gruvbox
  hi CursorLine guibg=NONE
]])

		vim.api.nvim_set_hl(0, "CursorLine", {
			bg = "#3c3836",
			blend = 30,
		})

		vim.api.nvim_set_hl(0, "CursorLineNr", {
			fg = "#fabd2f",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })
	end,
})
