return {
	{
		"frankroeder/parrot.nvim",
		dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
		-- optionally include "folke/noice.nvim" or "rcarriga/nvim-notify" for beautiful notifications
		config = function()
			require("parrot").setup({
				-- Providers must be explicitly set up to make them available.
				providers = {
					perplexity = {
						name = "perplexity",
						api_key = os.getenv("PERPLEXITY_API_KEY"),
						endpoint = "https://api.perplexity.ai/chat/completions",
						headers = function(self)
							return {
								["Content-Type"] = "application/json",
								["Accept"] = "application/json",
								["Authorization"] = "Bearer " .. self.api_key,
							}
						end,
						topic = {
							model = "r1-1776",
							params = {
								max_tokens = 64,
							},
						},
						models = {
              "gpt-5.2",
							"sonar",
							"sonar-pro",
							"sonar-deep-research",
							"sonar-reasoning",
							"sonar-reasoning-pro",
							"r1-1776",
						},
					},
				},
			})
		end,
	},
}
