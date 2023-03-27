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

require("lazy").setup('plugins')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("neotest").setup({
    adapters = {
        require("neotest-jest")({
            jestCommand = "yarn test --",
            -- jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            cwd = function() return vim.fn.getcwd() end
        })
    }
})

require("lsp_lines").setup()
require("symbols-outline").setup()

-- load all plugins
require "misc-utils"
-- require "top-bufferline"
-- require "statusline"
-- require "lualine-config"

-- require('config-cmp')
-- require('config-committia')
-- require('config-feline')
--
--
require('config-windline')

require("colorizer").setup()

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

-- cmd "colorscheme nord"
vim.cmd.colorscheme "catppuccin"

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

vim.opt.swapfile = false

g.neoformat_try_node_exe = 1
g.neoformat_basic_format_align = 1
g.neoformat_basic_format_retab = 1
g.neoformat_basic_format_trim = 1
g.neoformat_only_msg_on_error = 1

g.indentLine_enabled = 1
g.indent_blankline_char = "▏"

g.indent_blankline_filetype_exclude = { "help", "terminal" }
g.indent_blankline_buftype_exclude = { "terminal" }

g.indent_blankline_show_trailing_blankline_indent = true
g.indent_blankline_show_first_indent_level = true

-- require "mappings"

require "config-telescope"
-- require "nvimTree"

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
    virtual_text = { format = function(diagnostic) return "" end }
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
    { '<leader>D',  "<cmd>lua vim.lsp.buf.type_definition()<CR>" },
    { 'rn',         "<cmd>lua vim.lsp.buf.rename()<CR>" },
    { 'gD',         "<Cmd>lua vim.lsp.buf.declaration()<CR>" },
    { 'gd',         "<Cmd>lua vim.lsp.buf.definition()<CR>" },
    { 'ga',         "<Cmd>lua vim.lsp.buf.code_action()<CR>" },
    { 'gi',         "<Cmd>lua vim.lsp.buf.implementation()<CR>" },
    { 'gr',         "<Cmd>lua vim.lsp.buf.references()<CR>" },
    { 'K',          "<cmd>lua vim.lsp.buf.hover()<CR>" },
    { '<C-k>',      "<cmd>lua vim.lsp.buf.signature_help()<CR>" },
    { '[d',         "<cmd>lua vim.diagnostic.goto_prev({float = false})<CR>" },
    { ']d',         "<cmd>lua vim.diagnostic.goto_next({float = false})<CR>" },
    -- { '<Leader>e', "<cmd>lua vim.diagnostic.open_float()<CR>" },
    { '<Leader>e',  "<cmd>lua require('lsp_lines').toggle()<CR>" },
    { '<Leader>q',  "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>" },
    { '<Leader>fm', "<Cmd>Neoformat<CR>" },
    { '<Leader>fm', "<cmd>lua vim.lsp.buf.format()<CR>" }, {
    '<leader>', {
    {
        't', {         -- telescope pickers
        {
            's', ":SymbolsOutline<CR>",
            { noremap = true, silent = true }
        },
        { 'u', ":UndotreeToggle<CR>" }
    }
    }, {
    'f', {             -- telescope pickers
    {
        't', ":NvimTreeFindFileToggle<CR>",
        { noremap = true, silent = true }
    }, { 'u', ":UndotreeToggle<CR>" },
    {
        'f',
        "<Cmd>lua require('telescope.builtin').find_files()<CR>"
    },
    {
        's',
        "<Cmd>lua require('telescope.builtin').live_grep()<CR>"
    },
    { 'b', "<Cmd>lua require('telescope.builtin').buffers()<CR>" },
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
    { 'r', "<Cmd>lua require('telescope.builtin').resume() <CR>" }
}
}, {
    'g', {             -- git stuff
    { 'm', "<Cmd>GitMessenger<CR>" }, { 'b', "<Cmd>Git blame<CR>" },
    { 's', "<Cmd>Git<CR>" }
}
}
}
},
    {
        mode = 'i',
        { { '<C-e>', "<Cmd>lua require'telescope.builtin'.symbols() <CR>" } }
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
