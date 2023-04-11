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
--require "misc-utils"
require('config-windline')

require "options"
require "keymaps"

-- lsp stuff

local g = vim.g

vim.cmd.colorscheme "catppuccin"

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

-- Old Vim Config Stuff
vim.api.nvim_exec([[
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    " nmap ga <Plug>(EasyAlign)
    let g:easy_align_ignore_groups = []
    "let g:easy_align_ignore_groups = ['Comment', 'String']

    " Startify.vim settings
    let g:startify_change_to_dir = 0
    autocmd FileType startify setlocal buftype=
]], false)
