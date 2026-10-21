local M = {}

local function read_package(path)
	local file = io.open(path, "r")
	if not file then
		return
	end
	local contents = file:read("*a")
	file:close()
	local ok, package = pcall(vim.json.decode, contents)
	if ok and type(package) == "table" then
		return package
	end
end

-- Resolve from the buffer, not cwd: this also handles hoisted dependencies and
-- packages with different TypeScript versions in the same workspace.
local function find_typescript(name)
	for dir in vim.fs.parents(name) do
		for _, package_name in ipairs({ "typescript", "@typescript/native-preview" }) do
			local package_dir = vim.fs.joinpath(dir, "node_modules", package_name)
			local package = read_package(vim.fs.joinpath(package_dir, "package.json"))
			if package then
				local major = tonumber(tostring(package.version):match("^(%d+)%."))
				local bin = package.bin
				if type(bin) == "table" then
					bin = bin.tsc or bin.tsgo
				end
				return {
					native = major ~= nil and major >= 7,
					cmd = type(bin) == "string" and vim.fs.joinpath(package_dir, bin) or nil,
				}
			end
		end
	end
end

function M.setup()
	local native_commands = {}
	local function root_dir(native)
		return function(bufnr, on_dir)
			local name = vim.api.nvim_buf_get_name(bufnr)
			-- Keep LSP away from Diffview history and other virtual buffers.
			if name == "" or name:match("^%w+://") or vim.bo[bufnr].buftype ~= "" then
				return
			end
			local package = find_typescript(name)
			if (package ~= nil and package.native) ~= native then
				return
			end
			local root = require("typescript-tools.utils").get_root_dir(bufnr)
			if native then
				if not package.cmd or vim.fn.executable(package.cmd) ~= 1 then
					vim.notify(
						"TypeScript 7: local LSP executable is missing; reinstall project dependencies",
						vim.log.levels.WARN
					)
					return
				end
				-- Separate nested packages even when they share a tsconfig.
				root = vim.fs.root(bufnr, "package.json") or root
				native_commands[root] = package.cmd
			end
			on_dir(root)
		end
	end

	vim.lsp.config("tsc", {
		root_dir = root_dir(true),
		cmd = function(dispatchers, config)
			return vim.lsp.rpc.start({ assert(native_commands[config.root_dir]), "--lsp", "--stdio" }, dispatchers)
		end,
	})
	vim.lsp.enable("tsc")
	require("typescript-tools").setup({ root_dir = root_dir(false) })
end

return M
