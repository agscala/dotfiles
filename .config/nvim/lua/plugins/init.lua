return {
    -- color related stuff
    'siduck76/nvim-base16.lua', 'norcalli/nvim-colorizer.lua',
    'nathom/filetype.nvim',
    'pantharshit00/vim-prisma',
    -- lsp stuff
    --
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    {
        'hrsh7th/cmp-nvim-lsp',
    },
    {
        'hrsh7th/cmp-buffer',
    },
    {
        'hrsh7th/cmp-path',
    },
    {
        'hrsh7th/cmp-cmdline',
    },
    {
        'hrsh7th/cmp-vsnip',
    },
    'hrsh7th/vim-vsnip',
    'hrsh7th/vim-vsnip-integ',

    'stevearc/dressing.nvim', -- unifies ui elements
    'mbbill/undotree',
    'onsails/lspkind-nvim',   -- lsp completion icons
    'nvim-lua/plenary.nvim',  -- useful lua functions
    'j-hui/fidget.nvim', -- LSP status indicator in bottom right
    -- use 'akinsho/nvim-bufferline.lua'
    --{
    --'nvim-lualine/lualine.nvim',
    --dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    --},
    'windwp/windline.nvim',
    -- file managing , picker etc
    'simrat39/symbols-outline.nvim',
    'ryanoasis/vim-devicons',
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        dependencies = {
            'nvim-lua/plenary.nvim',
        }
    },
    { 'nvim-telescope/telescope-fzf-native.nvim',    build = 'make' },
    'nvim-telescope/telescope-symbols.nvim',
    'nvim-lua/popup.nvim',
    'preservim/nerdtree',
    'kevinhwang91/nvim-bqf',
    -- version control
    'rhysd/git-messenger.vim',
    -- misc
    'tweekmonster/startuptime.vim',
    '907th/vim-auto-save',
    'tpope/vim-abolish',
    {
        'ggandor/leap.nvim',
        config = function()
            require('leap').add_default_mappings()
        end,
    },
    -- discord rich presence
    -- 'andweeb/presence.nvim',
    'bronson/vim-trailing-whitespace',
    'junegunn/vim-easy-align',
    -- 'Lokaltog/vim-easymotion',
    'luochen1990/rainbow',
    'MarcWeber/vim-addon-local-vimrc',
    'mhinz/vim-startify',
    'scrooloose/nerdcommenter',
    'sheerun/vim-polyglot',
    'tmhedberg/matchit',
    'tpope/vim-fugitive',
    'tpope/vim-git',
    'tpope/vim-repeat',
    'tpope/vim-surround',
    'metakirby5/codi.vim',             --  Scratchpad :Codi
    'wellle/targets.vim',              --  Improved ca( ciw... etc
    'farmergreg/vim-lastplace',        --  reopens files to last position
    'ConradIrwin/vim-bracketed-paste', --  auto :set paste
    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter',
            'antoinemadec/FixCursorHold.nvim', 'haydenmeade/neotest-jest'
        }
    },
    "nvim-treesitter/nvim-treesitter-textobjects",
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    "echasnovski/mini.bracketed",
    'folke/neodev.nvim',
    'sickill/vim-pasta',
}
