return {
	"olimorris/codecompanion.nvim",
	dependencies = {
    "nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = {
					adapter = "antigravity",
				},
				inline = {
					adapter = "antigravity",
				},
			},
			adapters = {
				antigravity = function()
					return require("codecompanion.adapters").extend("gemini", {
						name = "antigravity",
						env = {
							api_key = "GEMINI_API_KEY",
						},
						schema = {
							model = {
								default = "google-antigravity/gemini-3.1-pro",
							},
						},
					})
				end,
			},
		})
	end,
	keys = {
		{ "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Chat" },
		{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Actions" },
		{ "<leader>ae", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Inline Edit" },
	},
}
