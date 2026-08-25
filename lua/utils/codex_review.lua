local M = {}

local namespace = vim.api.nvim_create_namespace("codex-review-comments")
local cache = {}

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "Codex review" })
end

local function state_path(root)
	local directory = vim.fn.stdpath("state") .. "/codex-review"
	vim.fn.mkdir(directory, "p")
	return directory .. "/" .. vim.fn.sha256(root) .. ".json"
end

local function load(root)
	if cache[root] then
		return cache[root]
	end

	local path = state_path(root)
	if vim.fn.filereadable(path) == 0 then
		cache[root] = {}
		return cache[root]
	end

	local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
	cache[root] = ok and type(decoded) == "table" and decoded or {}
	if not ok then
		notify("Could not read saved comments: " .. path, vim.log.levels.ERROR)
	end
	return cache[root]
end

local function save(root)
	local ok, encoded = pcall(vim.json.encode, load(root))
	if not ok or vim.fn.writefile({ encoded }, state_path(root)) ~= 0 then
		notify("Could not save review comments", vim.log.levels.ERROR)
		return false
	end
	return true
end

local function root_for_file(filename)
	if filename == "" or filename:match("^diffview://") then
		return nil
	end
	return vim.fs.root(filename, ".git")
end

local function relative_path(root, filename)
	return vim.fs.relpath(root, filename) or filename
end

local function current_root()
	local filename = vim.api.nvim_buf_get_name(0)
	return root_for_file(filename) or vim.fs.root(vim.uv.cwd(), ".git")
end

local function render_buffer(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local root = root_for_file(filename)
	if not root then
		return
	end

	local file = relative_path(root, filename)
	local line_count = vim.api.nvim_buf_line_count(bufnr)
	for _, comment in ipairs(load(root)) do
		local line = comment.kind == "file" and 1 or comment.line_start
		if comment.file == file and line and line <= line_count then
			local text = comment.text:gsub("\n", " ")
			if #text > 80 then
				text = text:sub(1, 77) .. "..."
			end
			local prefix = comment.kind == "file" and " FILE REVIEW: " or " REVIEW: "
			vim.api.nvim_buf_set_extmark(bufnr, namespace, line - 1, 0, {
				sign_text = "R",
				sign_hl_group = "DiagnosticWarn",
				virt_text = { { prefix .. text, "DiagnosticVirtualTextWarn" } },
				virt_text_pos = "eol",
			})
		end
	end
end

local function current_file()
	local bufnr = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local root = root_for_file(filename)
	if not root then
		notify("Place the cursor in a working-tree file (the right Diffview pane)", vim.log.levels.ERROR)
		return nil
	end
	return {
		bufnr = bufnr,
		root = root,
		file = relative_path(root, filename),
	}
end

local function current_location(line_start, line_end)
	local location = current_file()
	if not location then
		return nil
	end

	line_start, line_end = math.min(line_start, line_end), math.max(line_start, line_end)
	location.line_start = line_start
	location.line_end = line_end
	location.code = vim.api.nvim_buf_get_lines(location.bufnr, line_start - 1, line_end, false)
	return location
end

function M.add(line_start, line_end)
	local location = current_location(line_start, line_end)
	if not location then
		return
	end

	local label = location.file .. ":" .. location.line_start
	if location.line_end ~= location.line_start then
		label = label .. "-" .. location.line_end
	end

	vim.ui.input({ prompt = "Review comment for " .. label .. ": " }, function(text)
		text = text and vim.trim(text) or ""
		if text == "" then
			return
		end

		table.insert(load(location.root), {
			kind = "line",
			file = location.file,
			line_start = location.line_start,
			line_end = location.line_end,
			text = text,
			code = location.code,
		})
		if save(location.root) then
			render_buffer(location.bufnr)
			notify("Comment saved for " .. label)
		end
	end)
end

function M.add_file()
	local location = current_file()
	if not location then
		return
	end

	vim.ui.input({ prompt = "File review comment for " .. location.file .. ": " }, function(text)
		text = text and vim.trim(text) or ""
		if text == "" then
			return
		end

		table.insert(load(location.root), {
			kind = "file",
			file = location.file,
			text = text,
		})
		if save(location.root) then
			render_buffer(location.bufnr)
			notify("File comment saved for " .. location.file)
		end
	end)
end

function M.list()
	local root = current_root()
	if not root then
		notify("Current directory is not a Git repository", vim.log.levels.ERROR)
		return
	end

	local items = {}
	for _, comment in ipairs(load(root)) do
		local is_file = comment.kind == "file"
		table.insert(items, {
			filename = root .. "/" .. comment.file,
			lnum = is_file and 1 or comment.line_start,
			end_lnum = is_file and 1 or comment.line_end,
			col = 1,
			text = (is_file and "[FILE] " or "") .. comment.text,
		})
	end

	if #items == 0 then
		notify("There are no review comments")
		return
	end

	vim.fn.setqflist({}, " ", { title = "Codex review comments", items = items })
	vim.cmd("copen")
end

function M.clear()
	local root = current_root()
	if not root or #load(root) == 0 then
		notify("There are no review comments")
		return
	end
	if vim.fn.confirm("Delete all review comments for this repository?", "&Delete\n&Cancel", 2) ~= 1 then
		return
	end

	cache[root] = {}
	save(root)
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) then
			vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
		end
	end
	notify("Review comments cleared")
end

function M.prompt()
	local root = current_root()
	if not root then
		notify("Current directory is not a Git repository", vim.log.levels.ERROR)
		return nil
	end

	local comments = load(root)
	if #comments == 0 then
		notify("There are no review comments", vim.log.levels.WARN)
		return nil
	end

	local lines = {
		"Please address all of the following code review comments in the current repository.",
		"Inspect the current code before editing. Make the necessary changes and then summarize how each comment was addressed.",
		"",
	}
	for index, comment in ipairs(comments) do
		if comment.kind == "file" then
			table.insert(lines, string.format("%d. File: %s", index, comment.file))
			table.insert(lines, "File-level review comment: " .. comment.text)
		else
			local location = comment.file .. ":" .. comment.line_start
			if comment.line_end ~= comment.line_start then
				location = location .. "-" .. comment.line_end
			end
			table.insert(lines, string.format("%d. %s", index, location))
			table.insert(lines, "Review comment: " .. comment.text)
			table.insert(lines, "Code at the time of review:")
			for _, code_line in ipairs(comment.code or {}) do
				table.insert(lines, "    " .. code_line)
			end
		end
		table.insert(lines, "")
	end
	return table.concat(lines, "\n"), #comments
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
	group = vim.api.nvim_create_augroup("CodexReviewComments", { clear = true }),
	callback = function(args)
		render_buffer(args.buf)
	end,
})

return M
