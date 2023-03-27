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

-- load all plugins
require "misc-utils"
require "options"
require('config-windline')

-- lsp stuff
require "nvim-lspconfig"

local g = vim.g

vim.cmd.colorscheme "catppuccin"

-- blankline
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
        't', { -- telescope pickers
        {
            's', ":SymbolsOutline<CR>",
            { noremap = true, silent = true }
        },
        { 'u', ":UndotreeToggle<CR>" }
    }
    }, {
    'f', { -- telescope pickers
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
    'g', { -- git stuff
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

    " Startify.vim settings
    let g:startify_change_to_dir = 0
    autocmd FileType startify setlocal buftype=

    nnoremap q: <nop>
    nnoremap Q <nop>

    nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
]], false)
