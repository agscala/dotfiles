return {
	"stevearc/conform.nvim",
	keys = {
		{ "<leader>fm", "<cmd>lua require('conform').format()<cr>", desc = "Format file" },
	},
	config = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			["*"] = { "codespell" },
			["_"] = { "trim_whitespace" },
			gdscript = { "gdformat" },
		},
	},
}
