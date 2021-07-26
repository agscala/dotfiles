local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

local packer = require("packer")
local use = packer.use


-- using { } for using different branch , loading plugin with certain commands etc
require("packer").startup(
    function()
        use "wbthomason/packer.nvim"

        -- color related stuff
        use "siduck76/nvim-base16.lua"
        use "norcalli/nvim-colorizer.lua"
        use 'folke/tokyonight.nvim'
        use 'shaunsingh/nord.nvim'

        -- lsp stuff
        use "windwp/nvim-autopairs"
        use "nvim-treesitter/nvim-treesitter"
        use "neovim/nvim-lspconfig"
        use "hrsh7th/nvim-compe"
        use "onsails/lspkind-nvim" -- lsp completion icons
        use "sbdchd/neoformat" -- reformat utility (,fm)
        use "nvim-lua/plenary.nvim" -- useful lua functions
        use "glepnir/lspsaga.nvim" -- improved lsp functionality
        use "hrsh7th/vim-vsnip"
        use "hrsh7th/vim-vsnip-integ"

        use "akinsho/nvim-bufferline.lua"
        use "glepnir/galaxyline.nvim" -- customizable line at the bottom

        -- file managing , picker etc
        use "kyazdani42/nvim-tree.lua"
        use "kyazdani42/nvim-web-devicons"
        use "ryanoasis/vim-devicons"
        use "nvim-telescope/telescope.nvim"
        use "nvim-telescope/telescope-media-files.nvim"
        use "nvim-telescope/telescope-symbols.nvim"
        use "nvim-lua/popup.nvim"
        use "preservim/nerdtree"
        use "kevinhwang91/nvim-bqf"

        -- version control
        use "airblade/vim-gitgutter"
        use "rhysd/git-messenger.vim"

        -- misc
        use "tweekmonster/startuptime.vim"
        use "907th/vim-auto-save"
        use "folke/which-key.nvim"

        use 'ggandor/lightspeed.nvim' -- quick movement


        -- discord rich presence
        --use "andweeb/presence.nvim"

        use {"lukas-reineke/indent-blankline.nvim", branch = "lua"}

        -- old vim config
        use 'bronson/vim-trailing-whitespace'
        use 'junegunn/vim-easy-align'
        -- use 'Lokaltog/vim-easymotion'
        use 'luochen1990/rainbow'
        use 'MarcWeber/vim-addon-local-vimrc'
        use 'mhinz/vim-startify'
        use 'scrooloose/nerdcommenter'
        use 'sheerun/vim-polyglot'
        use 'tmhedberg/matchit'
        use 'tpope/vim-fugitive'
        use 'tpope/vim-git'
        use 'tpope/vim-repeat'
        use 'tpope/vim-surround'
        use 'metakirby5/codi.vim'              --  Scratchpad :Codi
        use 'wellle/targets.vim'               --  Improved ca( ciw... etc
        use 'farmergreg/vim-lastplace'         --  reopens files to last position
        use 'ConradIrwin/vim-bracketed-paste'  --  auto :set paste
    end,
    {
        display = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
        }
    }
)

-- load all plugins
require "file-icons"

require "misc-utils"
require "top-bufferline"
require "statusline"

require("colorizer").setup()

-- lsp stuff

require "nvim-lspconfig"
require "compe-completion"

local cmd = vim.cmd
local g = vim.g

g.mapleader = ","
g.auto_save = 0

-- colorscheme related stuff cmd "syntax on"
vim.g.tokyonight_style = "night"
cmd "colorscheme tokyonight"
-- cmd "colorscheme nord"

local base16 = require "base16"
base16(base16.themes["onedark"], true)

require "custom_highlights"

-- lightspeed
require'lightspeed'.setup {
  jump_to_first_match = true,
  jump_on_partial_input_safety_timeout = 400,
  -- This can get _really_ slow if the window has a lot of content,
  -- turn it on only if your machine can always cope with it.
  highlight_unique_chars = false,
  grey_out_search_area = true,
  match_only_the_start_of_same_char_seqs = true,
  limit_ft_matches = 5,
  full_inclusive_prefix_key = '<c-x>',
  -- By default, the values of these will be decided at runtime,
  -- based on `jump_to_first_match`.
  labels = nil,
  -- cycle_group_fwd_key = nil,
  -- cycle_group_bwd_key = nil,
}

-- blankline

local indent = 4

g.indentLine_enabled = 1
g.indent_blankline_char = "▏"

g.indent_blankline_filetype_exclude = {"help", "terminal"}
g.indent_blankline_buftype_exclude = {"terminal"}

g.indent_blankline_show_trailing_blankline_indent = true
g.indent_blankline_show_first_indent_level = true

require "treesitter-nvim"
require "mappings"

require "telescope-nvim"
require "nvimTree"

require "whichkey"

-- git signs , lsp symbols etc
require("nvim-autopairs").setup()
require("lspkind").init()

-- hide line numbers in terminal windows
vim.api.nvim_exec([[
   au BufEnter term://* setlocal nonumber
]], false)

-- git-messenger
vim.api.nvim_exec([[
    let g:git_messenger_floating_win_opts = { "border": "single" }
]], false)

----------------------
-- Old Vim Config Stuff
vim.api.nvim_exec([[
    set backspace=indent,eol,start
    set cursorcolumn
    set cursorline
    set encoding=utf-8
    set fileformats=unix,dos,mac
    set hidden
    set laststatus=2
    set nohlsearch
    " set lazyredraw
    set magic
    set nocompatible
    set number
    set ruler
    set scrolloff=3
    set shortmess=a
    set sidescroll=1
    set sidescrolloff=10
    set splitbelow
    set splitright
    set ttyfast
    set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/.node_modules
    set wildmenu
    set wildmode=list:longest

    set list
    set listchars=tab:»\ ,trail:·

    " No annoying sound on errors
    set noerrorbells
    set novisualbell
    set t_vb=
    set tm=500

    nnoremap j gj
    nnoremap k gk
    "reindent text after p
    nnoremap p p=`]

    " Reselect visual block after indent
    vnoremap < <gv
    vnoremap > >gv

    " Don't save deleted text
    vnoremap p "_dP

    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
    let g:easy_align_ignore_groups = []
    "let g:easy_align_ignore_groups = ['Comment', 'String']

    " Show Git Diff in window split when committing
    autocmd FileType gitcommit silent DiffGitCached | wincmd p | resize 15

    noremap <C-k> <C-w><Up>
    noremap <C-j> <C-w><Down>
    noremap <C-l> <C-w><Right>
    noremap <C-h> <C-w><Left>

    " Fix [<section> commands so that it matches both formats of function braces
    map [[ ?{<CR>w99[{
    map ][ /}<CR>b99]}
    map \]\] j0[[%/{<CR>
    map [] k$][%?}<CR>

    " NERD_Commenter.vim settings
    let NERDSpaceDelims = 1
    let NERDCompactSexyComs = 1

    " Startify.vim settings
    let g:startify_change_to_dir = 0
    autocmd FileType startify setlocal buftype=

    nnoremap q: <nop>
    nnoremap Q <nop>
]], false)

