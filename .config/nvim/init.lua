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
        use {"Pocco81/Catppuccino.nvim", branch="old-catppuccino"}

        -- lsp stuff
        use 'neovim/nvim-lspconfig'
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/cmp-vsnip'
        use 'hrsh7th/nvim-cmp'

        use "windwp/nvim-autopairs"
        use "nvim-treesitter/nvim-treesitter"

        use "onsails/lspkind-nvim" -- lsp completion icons
        use "sbdchd/neoformat" -- reformat utility (,fm)
        use "nvim-lua/plenary.nvim" -- useful lua functions
        use "glepnir/lspsaga.nvim" -- improved lsp functionality
        use "hrsh7th/vim-vsnip"
        use "hrsh7th/vim-vsnip-integ"

        use "akinsho/nvim-bufferline.lua"
        use {
          'nvim-lualine/lualine.nvim',
          requires = {'kyazdani42/nvim-web-devicons', opt = true}
        }
        -- use "glepnir/galaxyline.nvim" -- customizable line at the bottom

        use 'LionC/nest.nvim' -- keybinding management

        -- file managing , picker etc
        use {
          'kyazdani42/nvim-tree.lua',
          requires = 'kyazdani42/nvim-web-devicons',
          config = function() require'nvim-tree'.setup {} end
        }
        use "kyazdani42/nvim-web-devicons"
        use "ryanoasis/vim-devicons"
        use "nvim-telescope/telescope.nvim"
        use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
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

        -- use 'ggandor/lightspeed.nvim' -- quick movement
        use {'phaazon/hop.nvim', branch = 'v1'}


        -- discord rich presence
        --use "andweeb/presence.nvim"

        use "rhysd/committia.vim" -- git commit preview
        use "lukas-reineke/indent-blankline.nvim"

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
-- require "statusline"
--require "lualine-config"

require('config-cmp')
require('config-committia')

require("colorizer").setup()


-- lsp stuff

require "nvim-lspconfig"

local cmd = vim.cmd
local g = vim.g

g.mapleader = ","
g.auto_save = 0

-- colorscheme related stuff cmd "syntax on"
-- vim.g.tokyonight_style = "night"
-- cmd "colorscheme tokyonight"
local catppuccino = require("catppuccino")

catppuccino.setup(
    {
        colorscheme = "dark_catppuccino",
        transparency = false,
        styles = {
            comments = "italic",
            functions = "NONE",
            keywords = "italic",
            strings = "NONE",
            variables = "NONE",
        },
        integrations = {
            treesitter = true,
            native_lsp = {
                enabled = true,
                styles = {
                    errors = "italic",
                    hints = "italic",
                    warnings = "italic",
                    information = "italic"
                }
            },
            lsp_trouble = false,
            lsp_saga = false,
            gitgutter = false,
            gitsigns = false,
            telescope = false,
            nvimtree = {
                enabled = false,
                show_root = false,
            },
            which_key = true,
            indent_blankline = {
                enabled = true,
                colored_indent_levels = false,
            },
            dashboard = false,
            neogit = false,
            vim_sneak = false,
            fern = false,
            barbar = false,
            bufferline = false,
            markdown = false,
        }
    }
)
catppuccino.load()

-- cmd "colorscheme nord"

-- require "custom_highlights"

-- hop
vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }


-- lightspeed
-- require'lightspeed'.setup {
  -- jump_to_first_match = true,
  -- jump_on_partial_input_safety_timeout = 400,
  -- -- This can get _really_ slow if the window has a lot of content,
  -- -- turn it on only if your machine can always cope with it.
  -- highlight_unique_chars = false,
  -- grey_out_search_area = true,
  -- match_only_the_start_of_same_char_seqs = true,
  -- limit_ft_matches = 5,
  -- full_inclusive_prefix_key = '<c-x>',
  -- -- By default, the values of these will be decided at runtime,
  -- -- based on `jump_to_first_match`.
  -- labels = nil,
  -- -- cycle_group_fwd_key = nil,
  -- -- cycle_group_bwd_key = nil,
-- }

-- blankline

local indent = 4

g.indentLine_enabled = 1
g.indent_blankline_char = "▏"

g.indent_blankline_filetype_exclude = {"help", "terminal"}
g.indent_blankline_buftype_exclude = {"terminal"}

g.indent_blankline_show_trailing_blankline_indent = true
g.indent_blankline_show_first_indent_level = true

require "treesitter-nvim"
--require "mappings"

require "config-telescope"
require "config-autopairs"
require "nvimTree"

require "whichkey"

-- git signs , lsp symbols etc
require("lspkind").init()

-- hide line numbers in terminal windows
vim.api.nvim_exec([[
   au BufEnter term://* setlocal nonumber
]], false)

-- git-messenger
vim.api.nvim_exec([[
    let g:git_messenger_floating_win_opts = { "border": "single" }
    nmap gc <Plug>(git-messenger)
    let g:git_messenger_no_default_mappings = v:true
]], false)

-- KEYBINDINGS --
local nest = require('nest')
nest.applyKeymaps {
    -- { '<leader>',
        -- { 'w',
            -- { 'a', "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>" },
            -- { 'r', "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>" },
            -- { 'l', "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>" },
        -- },
    -- },

    -- LSP stuff
    { '<leader>D', "<cmd>lua vim.lsp.buf.type_definition()<CR>" },
    { 'rn', "<cmd>lua vim.lsp.buf.rename()<CR>" },
    { 'gD', "<Cmd>lua vim.lsp.buf.declaration()<CR>" },
    { 'gd', "<Cmd>lua vim.lsp.buf.definition()<CR>" },
    { 'ga', "<Cmd>lua vim.lsp.buf.code_action()<CR>" },
    { 'gi', "<Cmd>lua vim.lsp.buf.implementation()<CR>" },
    { 'gr', "<Cmd>lua vim.lsp.buf.references()<CR>" },
    { 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>" },
    { '<C-k>', "<cmd>lua vim.lsp.buf.signature_help()<CR>" },
    { '[d', "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>" },
    { ']d', "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>" },
    { '<Leader>e', "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>" },
    { '<Leader>q', "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>" },
    { '<Leader>fm', "<Cmd>Neoformat<CR>" },

    { '<leader>', {
        { 'f', { -- telescope pickers
            { 't', ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true }},
            { 'f', "<Cmd>lua require('telescope.builtin').find_files()<CR>" },
            { 's', "<Cmd>lua require('telescope.builtin').live_grep()<CR>" },
            { 'b', "<Cmd>lua require('telescope.builtin').buffers()<CR>" },
            { 'h', "<Cmd>lua require('telescope.builtin').help_tags()<CR>" },
            { 'o', "<Cmd>lua require('telescope.builtin').oldfiles()<CR>" },
            { 'e', "<Cmd>lua require('telescope.builtin').symbols() <CR>" },
        }},
        { 'g', { -- git stuff
            { 'm', "<Cmd>GitMessenger<CR>" },
            { 'b', "<Cmd>Git blame<CR>" },
            { 's', "<Cmd>Git<CR>" },
        }},
    }},
    { mode = 'i', {
        { '<C-e>', "<Cmd>lua require'telescope.builtin'.symbols() <CR>" },
    }},
}


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
    " nmap ga <Plug>(EasyAlign)
    let g:easy_align_ignore_groups = []
    "let g:easy_align_ignore_groups = ['Comment', 'String']

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

    nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
]], false)

