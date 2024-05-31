return {
	"stevearc/conform.nvim",
	keys = {
		{ "<leader>fm", "<cmd>lua require('conform').format()<cr>", desc = "Format file" },
	},
	config = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- Use a sub-list to run only the first available formatter
			javascript = { { "prettierd", "prettier" }, "eslint_d" },
			typescript = { { "prettierd", "prettier" } },
			typescriptreact = { { "prettierd", "prettier" } },

			["*"] = { "codespell" },
			["_"] = { "trim_whitespace" },
		},
	},
	init = function()
		-- Uncomment for format on save:
		--
		--vim.api.nvim_create_autocmd("BufWritePre", {
		--pattern = "*",
		--callback = function(args)
		--require("conform").format({ bufnr = args.buf })
		--end,
		--})
	end,
}
