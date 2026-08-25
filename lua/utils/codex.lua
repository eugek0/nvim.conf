local M = {}

local terminals = {}
local codex_executable
local active_terminal
local review_comments = require("utils.codex_review")

local function works(path)
	local result = vim.system({ path, "--version" }, { text = true }):wait()
	return result.code == 0 and result.signal == 0 and (result.stdout or ""):match("codex%-cli") ~= nil
end

local function executable()
	if codex_executable then
		return codex_executable
	end

	if vim.fn.executable("codex") == 1 and works("codex") then
		codex_executable = "codex"
		return codex_executable
	end

	-- The official VS Code extension bundles the CLI, but its directory is not
	-- necessarily present in PATH when Neovim is started outside VS Code.
	local extension_bin = vim.fn.glob("~/.vscode/extensions/openai.chatgpt-*/bin/*/codex", false, true)
	table.sort(extension_bin, function(a, b)
		return a > b
	end)
	for _, path in ipairs(extension_bin) do
		if vim.fn.executable(path) == 1 and works(path) then
			codex_executable = path
			return codex_executable
		end
	end

	return nil
end

local function ensure_codex()
	local path = executable()
	if path then
		return path
	end

	vim.notify(
		"Codex CLI is not installed. Run: npm install -g @openai/codex",
		vim.log.levels.ERROR,
		{ title = "Codex" }
	)
end

local function terminal(mode)
	mode = mode or "new"
	if terminals[mode] then
		return terminals[mode]
	end

	local Terminal = require("toggleterm.terminal").Terminal
	local command = vim.fn.shellescape(assert(executable()))
	if mode == "resume" then
		command = command .. " resume --last"
	end

	terminals[mode] = Terminal:new({
		cmd = command,
		dir = "git_dir",
		direction = "vertical",
		display_name = "Codex",
		hidden = true,
		-- Keep the buffer open when Codex crashes so its error remains visible.
		close_on_exit = false,
		size = function()
			return math.floor(vim.o.columns * 0.5)
		end,
		on_open = function(term)
			active_terminal = term
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
		on_exit = function(_, _, exit_code)
			if exit_code ~= 0 then
				vim.schedule(function()
					vim.notify("Codex exited with code " .. exit_code, vim.log.levels.ERROR, { title = "Codex" })
				end)
			end
		end,
	})

	return terminals[mode]
end

function M.toggle()
	if ensure_codex() then
		active_terminal = terminal()
		active_terminal:toggle()
	end
end

function M.resume()
	if ensure_codex() then
		active_terminal = terminal("resume")
		active_terminal:toggle()
	end
end

function M.review()
	vim.cmd("DiffviewOpen")
end

function M.add_review_comment(line_start, line_end)
	review_comments.add(line_start, line_end)
end

function M.add_file_review_comment()
	review_comments.add_file()
end

function M.list_review_comments()
	review_comments.list()
end

function M.clear_review_comments()
	review_comments.clear()
end

function M.send_review_comments()
	local prompt, count = review_comments.prompt()
	if not prompt then
		return
	end
	if not active_terminal or not active_terminal.job_id or vim.fn.jobwait({ active_terminal.job_id }, 0)[1] ~= -1 then
		vim.notify("Start Codex with <leader>aic or <leader>air before sending comments", vim.log.levels.ERROR, {
			title = "Codex review",
		})
		return
	end

	if not active_terminal:is_open() then
		active_terminal:open()
	end
	vim.defer_fn(function()
		active_terminal:send(prompt, false)
		vim.notify(string.format("Sent %d review comment(s) to Codex", count), vim.log.levels.INFO, {
			title = "Codex review",
		})
	end, 100)
end

function M.auth_status()
	local path = ensure_codex()
	if not path then
		return
	end

	vim.system({ path, "login", "status" }, { text = true }, function(result)
		vim.schedule(function()
			local output = vim.trim(result.stdout ~= "" and result.stdout or result.stderr)
			local level = result.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
			vim.notify(output, level, { title = "Codex authentication" })
		end)
	end)
end

function M.doctor()
	local path = ensure_codex()
	if not path then
		return
	end

	vim.system({ path, "doctor", "--summary", "--no-color" }, { text = true }, function(result)
		vim.schedule(function()
			local output = vim.trim(result.stdout ~= "" and result.stdout or result.stderr)
			local level = result.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
			vim.notify(output, level, { title = "Codex doctor", timeout = 10000 })
		end)
	end)
end

return M
