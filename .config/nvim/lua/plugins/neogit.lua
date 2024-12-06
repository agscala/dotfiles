return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
		"ibhagwan/fzf-lua", -- optional
	},
	config = {
      commit_editor = {
        staged_diff_split_kind = "vsplit",
      },
    },
	keys = {
		{ "<leader>gg", "<cmd>Neogit kind=replace<cr>", desc = "NeoGit" },
	},
}
