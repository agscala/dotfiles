local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath) -- using { } for using different branch , loading plugin with certain commands etc

vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("lazy").setup({
    -- color related stuff
    'siduck76/nvim-base16.lua', 'norcalli/nvim-colorizer.lua',
    'folke/tokyonight.nvim', 'shaunsingh/nord.nvim',
    -- use {'Pocco81/Catppuccino.nvim', branch='old-catppuccino'}
    {'catppuccin/nvim', name = 'catppuccin'}, 'nathom/filetype.nvim',
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
    'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ',

    'stevearc/dressing.nvim', -- unifies ui elements
    'mbbill/undotree', 'windwp/nvim-autopairs',
    'nvim-treesitter/nvim-treesitter', 'onsails/lspkind-nvim', -- lsp completion icons
    'sbdchd/neoformat', -- reformat utility (,fm)
    'nvim-lua/plenary.nvim', -- useful lua functions
    {
        'glepnir/lspsaga.nvim',
        branch = 'main',
        config = function() require('lspsaga').setup({}) end,
        dependencies = {
            {'nvim-tree/nvim-web-devicons'},
            -- Please make sure you install markdown and markdown_inline parser
            {'nvim-treesitter/nvim-treesitter'}
        }
    }, 'j-hui/fidget.nvim', -- LSP status indicator in bottom right
    -- use 'akinsho/nvim-bufferline.lua'
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons', opt = true}
    }, -- use 'feline-nvim/feline.nvim'
    -- use 'glepnir/galaxyline.nvim' -- customizable line at the bottom
    'windwp/windline.nvim', {
        'lewis6991/gitsigns.nvim',
        dependencies = {'nvim-lua/plenary.nvim'}
        -- tag = 'release' -- To use the latest release
    }, --
    {'SmiteshP/nvim-gps', dependencies = 'nvim-treesitter/nvim-treesitter'},

    'LionC/nest.nvim', -- keybinding management
    -- file managing , picker etc
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function() require'nvim-tree'.setup {} end
    }, 'simrat39/symbols-outline.nvim', 'nvim-tree/nvim-web-devicons',
    'ryanoasis/vim-devicons', {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        dependencies = {{'nvim-lua/plenary.nvim'}}
    }, 
    -- {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
    'nvim-telescope/telescope-symbols.nvim', 'nvim-lua/popup.nvim',
    'preservim/nerdtree', 'kevinhwang91/nvim-bqf', -- version control
    'airblade/vim-gitgutter', 'rhysd/git-messenger.vim', -- misc
    'tweekmonster/startuptime.vim', '907th/vim-auto-save',
    'folke/which-key.nvim', 'tpope/vim-abolish', 'ggandor/leap.nvim', {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = function() require('lsp_lines').setup() end
    }, {
        'jackMort/ChatGPT.nvim',
        commit = '8820b99c', -- March 6th 2023, before submit issue
        config = function()
            require('chatgpt').setup({
                keymaps = {
                    close = {'<C-c>'},
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
    }, -- discord rich presence
    -- 'andweeb/presence.nvim',
    'rhysd/committia.vim', -- git commit preview
    'lukas-reineke/indent-blankline.nvim', -- old vim config
    'bronson/vim-trailing-whitespace', 'junegunn/vim-easy-align',
    -- 'Lokaltog/vim-easymotion',
    'luochen1990/rainbow', 'MarcWeber/vim-addon-local-vimrc',
    'mhinz/vim-startify', 'scrooloose/nerdcommenter', 'sheerun/vim-polyglot',
    'tmhedberg/matchit', 'tpope/vim-fugitive', 'tpope/vim-git',
    'tpope/vim-repeat', 'tpope/vim-surround', 'metakirby5/codi.vim', --  Scratchpad :Codi
    'wellle/targets.vim', --  Improved ca( ciw... etc
    'farmergreg/vim-lastplace', --  reopens files to last position
    'ConradIrwin/vim-bracketed-paste', --  auto :set paste
    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter',
            'antoinemadec/FixCursorHold.nvim', 'haydenmeade/neotest-jest'
        }
    }
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("neotest").setup({
    adapters = {
        require("neotest-jest")({
            jestCommand = "yarn test --",
            -- jestConfigFile = "custom.jest.config.ts",
            env = {CI = true},
            cwd = function(path) return vim.fn.getcwd() end
        })
    }
})

require('gitsigns').setup()
require("lsp_lines").setup()
require("symbols-outline").setup()

-- load all plugins
require "file-icons"

require "misc-utils"
-- require "top-bufferline"
-- require "statusline"
-- require "lualine-config"

require('config-cmp')
require('config-committia')
-- require('config-feline')
--
--
require('config-windline')

require("colorizer").setup()
-- require('feline').setup({
-- components = require('catppuccin.core.integrations.feline'),
-- })
--

-- lsp stuff

-- require("mason").setup()
-- require("mason-lspconfig").setup()
require "nvim-lspconfig"
-- mason_lspconfig = require("mason-lspconfig")
-- mason_lspconfig.setup({
-- ensure_installed = {
-- "sumneko_lua",
-- "tsserver",
-- }
-- })
-- mason_lspconfig.setup_handlers({
-- function(server_name)
-- require("lspconfig")[server_name].setup {
-- on_attach = function(client, bufnr)
-- require("nvim-lspconfig").on_attach(client, bufnr)
-- end
-- settings
-- }
-- end
-- })

local cmd = vim.cmd
local g = vim.g

g.auto_save = 0

-- colorscheme related stuff cmd "syntax on"
-- vim.g.tokyonight_style = "night"
-- cmd "colorscheme tokyonight"

require('config-catppuccin')

-- cmd "colorscheme nord"

-- require "custom_highlights"

-- leap
require('leap').add_default_mappings()

-- hop
-- vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
-- vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
-- require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }

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

g.neoformat_try_node_exe = 1
g.neoformat_basic_format_align = 1
g.neoformat_basic_format_retab = 1
g.neoformat_basic_format_trim = 1
g.neoformat_only_msg_on_error = 1

g.indentLine_enabled = 1
g.indent_blankline_char = "▏"

g.indent_blankline_filetype_exclude = {"help", "terminal"}
g.indent_blankline_buftype_exclude = {"terminal"}

g.indent_blankline_show_trailing_blankline_indent = true
g.indent_blankline_show_first_indent_level = true

require "config-treesitter"
-- require "mappings"

require "config-telescope"
require "config-autopairs"
require "nvimTree"

require "whichkey"

-- git signs , lsp symbols etc
require("lspkind").init()

-- persistent undo
vim.api.nvim_exec([[
    set undofile
    set undodir=~/.config/nvim/undofiles
]], false)

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

vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = {format = function(diagnostic) return "" end}
    -- virtual_lines = { only_current_line = true },
})

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
    {'<leader>D', "<cmd>lua vim.lsp.buf.type_definition()<CR>"},
    {'rn', "<cmd>lua vim.lsp.buf.rename()<CR>"},
    {'gD', "<Cmd>lua vim.lsp.buf.declaration()<CR>"},
    {'gd', "<Cmd>lua vim.lsp.buf.definition()<CR>"},
    {'ga', "<Cmd>lua vim.lsp.buf.code_action()<CR>"},
    {'gi', "<Cmd>lua vim.lsp.buf.implementation()<CR>"},
    {'gr', "<Cmd>lua vim.lsp.buf.references()<CR>"},
    {'K', "<cmd>lua vim.lsp.buf.hover()<CR>"},
    {'<C-k>', "<cmd>lua vim.lsp.buf.signature_help()<CR>"},
    {'[d', "<cmd>lua vim.diagnostic.goto_prev({float = false})<CR>"},
    {']d', "<cmd>lua vim.diagnostic.goto_next({float = false})<CR>"},
    -- { '<Leader>e', "<cmd>lua vim.diagnostic.open_float()<CR>" },
    {'<Leader>e', "<cmd>lua require('lsp_lines').toggle()<CR>"},
    {'<Leader>q', "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>"},
    {'<Leader>fm', "<Cmd>Neoformat<CR>"},
    {'<Leader>fm', "<cmd>lua vim.lsp.buf.format()<CR>"}, {
        '<leader>', {
            {
                't', { -- telescope pickers
                    {
                        's', ":SymbolsOutline<CR>",
                        {noremap = true, silent = true}
                    },
                    {
                        't', ":NvimTreeFindFileToggle<CR>",
                        {noremap = true, silent = true}
                    }, {'u', ":UndotreeToggle<CR>"}
                }
            }, {
                'f', { -- telescope pickers
                    {
                        't', ":NvimTreeFindFileToggle<CR>",
                        {noremap = true, silent = true}
                    }, {'u', ":UndotreeToggle<CR>"},
                    {
                        'f',
                        "<Cmd>lua require('telescope.builtin').find_files()<CR>"
                    },
                    {
                        's',
                        "<Cmd>lua require('telescope.builtin').live_grep()<CR>"
                    },
                    {'b', "<Cmd>lua require('telescope.builtin').buffers()<CR>"},
                    {
                        'h',
                        "<Cmd>lua require('telescope.builtin').help_tags()<CR>"
                    },
                    {
                        'o',
                        "<Cmd>lua require('telescope.builtin').oldfiles()<CR>"
                    },
                    {
                        'e',
                        "<Cmd>lua require('telescope.builtin').symbols() <CR>"
                    },
                    {'r', "<Cmd>lua require('telescope.builtin').resume() <CR>"}
                }
            }, {
                'g', { -- git stuff
                    {'m', "<Cmd>GitMessenger<CR>"}, {'b', "<Cmd>Git blame<CR>"},
                    {'s', "<Cmd>Git<CR>"}
                }
            }
        }
    },
    {
        mode = 'i',
        {{'<C-e>', "<Cmd>lua require'telescope.builtin'.symbols() <CR>"}}
    }
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
