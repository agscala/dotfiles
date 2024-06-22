local icons = require("icons")

return {

	-- color related stuff
	"siduck76/nvim-base16.lua",
	"norcalli/nvim-colorizer.lua",
	--'nathom/filetype.nvim',
	"pantharshit00/vim-prisma",
	-- lsp stuff
	--
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"hrsh7th/cmp-buffer",
	},
	{
		"hrsh7th/cmp-path",
	},
	{
		"hrsh7th/cmp-cmdline",
	},
	{
		"hrsh7th/cmp-vsnip",
	},
	"hrsh7th/vim-vsnip",
	"hrsh7th/vim-vsnip-integ",

	"stevearc/dressing.nvim", -- unifies ui elements
	"mbbill/undotree",
	"onsails/lspkind-nvim", -- lsp completion icons
	"nvim-lua/plenary.nvim", -- useful lua functions
	"j-hui/fidget.nvim", -- LSP status indicator in bottom right
	-- use 'akinsho/nvim-bufferline.lua'
	--{
	--'nvim-lualine/lualine.nvim',
	--dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
	--},
	"windwp/windline.nvim",
	-- file managing , picker etc
	"ryanoasis/vim-devicons",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	"nvim-telescope/telescope-symbols.nvim",
	"nvim-lua/popup.nvim",
	"preservim/nerdtree",
	"kevinhwang91/nvim-bqf",
	-- version control
	--'rhysd/git-messenger.vim', -- gc blame popup
	-- misc
	"tweekmonster/startuptime.vim",
	"907th/vim-auto-save",
	"tpope/vim-abolish",
	-- discord rich presence
	-- 'andweeb/presence.nvim',
	"junegunn/vim-easy-align",
	-- 'Lokaltog/vim-easymotion',
	"HiPhish/rainbow-delimiters.nvim",
	"MarcWeber/vim-addon-local-vimrc",
	"mhinz/vim-startify",
	--'scrooloose/nerdcommenter',
	"tpope/vim-fugitive",
	"tpope/vim-git",
	"tpope/vim-repeat",
	"tpope/vim-surround",
	"farmergreg/vim-lastplace", --  reopens files to last position
	"ConradIrwin/vim-bracketed-paste", --  auto :set paste
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"haydenmeade/neotest-jest",
		},
	},
	"nvim-treesitter/nvim-treesitter-textobjects",
	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
	"echasnovski/mini.bracketed",
	"sickill/vim-pasta",
	{ "nvim-neotest/nvim-nio" }, -- Async I/O
	-- Diagnostics popover
	{
		"RaafatTurki/corn.nvim",
		keys = {
			{ "<leader>e", "<cmd>Corn toggle<cr>", desc = "toggle diagnostics popover" },
		},

		config = function()
			require("corn").setup({
				icons = {
					error = icons.diagnostics.Error,
					warn = icons.diagnostics.Warn,
					hint = icons.diagnostics.Hint,
					info = icons.diagnostics.Info,
				},
				item_preprocess_func = function(item)
					return item
				end,
				on_toggle = function(is_hidden)
					-- Toggle virtual text on/off
					-- vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
				end,
			})
		end,
	},
	--{ "echasnovski/mini.comment", config = {}},
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "<leader>cc", "<CMD>normal gcc<cr>", desc = "toggle comment on line" },
			{ "<leader>cc", "<CMD>'<,'>normal gcc<CR>'.", desc = "toggle comments linewise", mode = "x" },
			{ "<leader>cs", "<CMD>normal gbc<CR>'.", desc = "block comment" },
			{ "<leader>cs", "<CMD>normal gb<CR>", desc = "block comment", mode = "x" },
			{
				"<leader>cu",
				"<CMD>lua require('Comment.api').uncomment.blockwise.current()<CR>",
				desc = "toggle diagnostics popover",
			},
			{
				"<leader>cu",
				"<CMD>'<,'>lua require('Comment.api').uncomment.linewise.current()<CR>'.",
				desc = "invert comments",
				mode = "x",
			},
			{ "<leader>ci", "<CMD>'<,'>normal gcc<CR>'.", desc = "invert comments", mode = "x" },
			{
				"<leader>ci",
				"<CMD>lua require('Comment.api').toggle.linewise.current()<CR>",
				desc = "invert comment",
				mode = "n",
			},
		},
		opts = {
			-- add any options here
		},
		lazy = false,
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},

	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	{
		"mrcjkb/haskell-tools.nvim",
		version = "^3", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({})
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		"Bekaboo/dropbar.nvim",
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
		},
	},
	{
		"mistricky/codesnap.nvim",
		build = "make",

		-- keys = {
		-- 	{ "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
		-- 	{ "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
		-- },
		opts = {
			save_path = "~/Pictures",
			has_breadcrumbs = true,
			has_line_number = true,
            mac_window_bar = false,
			bg_theme = "dusk",
			watermark = "",
		},
	},
}
