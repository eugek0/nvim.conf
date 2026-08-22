local M = {}

local codex_terminal

local function ensure_codex()
	if vim.fn.executable("codex") == 1 then
		return true
	end

	vim.notify(
		"Codex CLI is not installed. See https://learn.chatgpt.com/docs/codex/cli",
		vim.log.levels.ERROR,
		{ title = "Codex" }
	)
	return false
end

local function terminal()
	if codex_terminal then
		return codex_terminal
	end

	local Terminal = require("toggleterm.terminal").Terminal
	codex_terminal = Terminal:new({
		cmd = "codex",
		dir = "git_dir",
		direction = "vertical",
		display_name = "Codex",
		hidden = true,
		close_on_exit = true,
		size = function()
			return math.floor(vim.o.columns * 0.5)
		end,
		on_open = function(term)
			vim.api.nvim_win_set_width(term.window, math.floor(vim.o.columns * 0.5))
			vim.cmd("startinsert")
			vim.keymap.set("t", "<C-j>", "<C-j>", {
				buffer = term.bufnr,
				desc = "Insert a new line in Codex",
			})
			vim.keymap.set("t", "<C-q>", function()
				term:toggle()
			end, { buffer = term.bufnr, desc = "Hide Codex" })
		end,
	})

	return codex_terminal
end

function M.toggle()
	if ensure_codex() then
		terminal():toggle()
	end
end

function M.auth_status()
	if not ensure_codex() then
		return
	end

	vim.system({ "codex", "login", "status" }, { text = true }, function(result)
		vim.schedule(function()
			local output = vim.trim(result.stdout ~= "" and result.stdout or result.stderr)
			local level = result.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
			vim.notify(output, level, { title = "Codex authentication" })
		end)
	end)
end

return M
