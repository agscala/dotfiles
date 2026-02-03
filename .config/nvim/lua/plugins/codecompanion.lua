return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		-- NOTE: The log_level is in `opts.opts`
		opts = {
			log_level = "DEBUG", -- or "TRACE"
		},
		adapters = {
			http = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						env = {
							api_key = "ANTHROPIC_API_KEY",
						},
					})
				end,
			},
		},
	},
}
