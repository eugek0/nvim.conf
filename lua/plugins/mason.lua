return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			automatic_enable = true,
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
				"html-lsp",
				"css-lsp",
				"prettierd",
				"eslint_d",
				"gopls",
				"golangci-lint",
				-- "typescript-language-server",
				"vtsls",
				"eslint-lsp",
				"prisma-language-server",
				"rust-analyzer",
				"emmet-language-server",
				"clangd",
				"clang-format",
				"bash-language-server",
				"omnisharp",
				"basedpyright",
				"json-lsp",
				"tailwindcss-language-server",
				"postgres-language-server",
				"pgformatter",
				"taplo",
				"flake8",
				"autopep8",
			},
		},
	},
}
