return {
  -- color related stuff
  'siduck76/nvim-base16.lua', 'norcalli/nvim-colorizer.lua',
  'folke/tokyonight.nvim', 'shaunsingh/nord.nvim',
  'nathom/filetype.nvim',
  'pantharshit00/vim-prisma',
  -- lsp stuff
  --
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
  'hrsh7th/vim-vsnip-integ',

  'stevearc/dressing.nvim', -- unifies ui elements
  'mbbill/undotree',
  'onsails/lspkind-nvim',   -- lsp completion icons
  'sbdchd/neoformat',       -- reformat utility (,fm)
  'nvim-lua/plenary.nvim',  -- useful lua functions
  {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    config = function() require('lspsaga').setup({}) end,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      -- Please make sure you install markdown and markdown_inline parser
      { 'nvim-treesitter/nvim-treesitter' }
    }
  }, 'j-hui/fidget.nvim', -- LSP status indicator in bottom right
  -- use 'akinsho/nvim-bufferline.lua'
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
  }, -- use 'feline-nvim/feline.nvim'
  -- use 'glepnir/galaxyline.nvim' -- customizable line at the bottom
  'windwp/windline.nvim',
  { 'SmiteshP/nvim-gps', dependencies = 'nvim-treesitter/nvim-treesitter' },

  'LionC/nest.nvim', -- keybinding management
  -- file managing , picker etc
  'simrat39/symbols-outline.nvim', 'nvim-tree/nvim-web-devicons',
  'ryanoasis/vim-devicons',
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
    }
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  'nvim-telescope/telescope-symbols.nvim',
  'nvim-lua/popup.nvim',
  'preservim/nerdtree',
  'kevinhwang91/nvim-bqf',
  -- version control
  'airblade/vim-gitgutter',
  'rhysd/git-messenger.vim',
  -- misc
  'tweekmonster/startuptime.vim',
  '907th/vim-auto-save',
  'folke/which-key.nvim',
  'tpope/vim-abolish',
  'ggandor/leap.nvim',
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function() require('lsp_lines').setup() end
  },
  {
    'jackMort/ChatGPT.nvim',
    commit = '8820b99c', -- March 6th 2023, before submit issue
    config = function()
      require('chatgpt').setup({
        keymaps = {
          close = { '<C-c>' },
          submit = '<C-Enter>',
          yank_last = '<C-y>',
          yank_last_code = '<C-k>',
          scroll_up = '<C-u>',
          scroll_down = '<C-d>',
          toggle_settings = '<C-o>',
          new_session = '<C-n>',
          cycle_windows = '<Tab>',
          -- in the Sessions pane
          select_session = '<Space>',
          rename_session = 'r',
          delete_session = 'd'
        }
      })
    end,
    dependencies = {
      'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim'
    }
  },
  -- discord rich presence
  -- 'andweeb/presence.nvim',
  'lukas-reineke/indent-blankline.nvim',
  -- old vim config
  'bronson/vim-trailing-whitespace',
  'junegunn/vim-easy-align',
  -- 'Lokaltog/vim-easymotion',
  'luochen1990/rainbow', 'MarcWeber/vim-addon-local-vimrc',
  'mhinz/vim-startify', 'scrooloose/nerdcommenter', 'sheerun/vim-polyglot',
  'tmhedberg/matchit', 'tpope/vim-fugitive', 'tpope/vim-git',
  'tpope/vim-repeat', 'tpope/vim-surround',
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
  }
}
