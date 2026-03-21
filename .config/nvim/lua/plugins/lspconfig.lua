return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"bashls",
			"lua_ls",
			"ts_ls",
			"stylelint_lsp",
			"css_variables",
		},
	},
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {
				ensure_installed = {
					"stylua",
					"prettierd",
					"prettier",
					"black",
					"isort",
					"codespell",
				},
			},
		},
		"neovim/nvim-lspconfig",
	},
}
