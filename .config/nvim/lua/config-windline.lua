local windline = require('windline')
local helper = require('windline.helpers')
local b_components = require('windline.components.basic')
local state = _G.WindLine.state

local lsp_comps = require('windline.components.lsp')
local git_comps = require('windline.components.git')

local navic = require('nvim-navic');

local hl_list = {
    Black = { 'white', 'black' },
    White = { 'black', 'white' },
    Inactive = { 'InactiveFg', 'InactiveBg' },
    Active = { 'ActiveFg', 'ActiveBg' },
}
local basic = {}

local breakpoint_width = 90
basic.divider = { b_components.divider, '' }
basic.bg = { ' ', 'StatusLine' }

local colors_mode = {
    Normal = { 'black', 'red' },
    Insert = { 'black', 'green' },
    Visual = { 'black', 'yellow' },
    Replace = { 'black', 'blue_light' },
    Command = { 'black', 'magenta' },
}

basic.vi_mode = {
    name = 'vi_mode',
    hl_colors = colors_mode,
    text = function()
        return { { '  ', state.mode[2] } }
    end,
}
basic.square_mode = {
    hl_colors = colors_mode,
    text = function()
        return {
            { " ",           state.mode[2] },
            { state.mode[1], state.mode[2] },
            { " ",           state.mode[2] },
        }
    end,
}

basic.lsp_diagnos = {
    name = 'diagnostic',
    hl_colors = {
        red = { 'red', 'black' },
        yellow = { 'yellow', 'black' },
        blue = { 'blue', 'black' },
    },
    width = breakpoint_width,
    text = function(bufnr)
        if lsp_comps.check_lsp(bufnr) then
            return {
                { lsp_comps.lsp_error({ format = '  %s', show_zero = false }),   'red' },
                { lsp_comps.lsp_warning({ format = '  %s', show_zero = false }), 'yellow' },
                { lsp_comps.lsp_hint({ format = '  %s', show_zero = false }),    'blue' },
            }
        end
        return ''
    end,
}

basic.fileStats = {
    name = 'fileStats',
    hl_colors = {
        default = hl_list.Black,
        white = { 'white', 'black' },
        magenta = { 'magenta', 'black' },
    },
    text = function(_, _, width)
        return {
            { ' ',                            '' },
            { b_components.cache_file_size(), 'default' },
            { b_components.line_col_lua,      'white' },
            { b_components.progress_lua,      '' },
        }
    end,
}

basic.file = {
    name = 'file',
    hl_colors = {
        default = hl_list.Black,
        white = { 'white', 'black' },
        magenta = { 'magenta', 'black' },
    },
    text = function(_, _, width)
        local color = "white"
        if vim.bo.modified then
            color = "magenta"
        end

        return {
            { ' ',                                                 hl_list.Black },
            { b_components.cache_file_name('[No Name]', 'unique'), color },
            { ' ',                                                 '' },
            { b_components.file_modified(' '),                  'magenta' },
        }
    end,
}

basic.file_right = {
    hl_colors = {
        default = hl_list.Black,
        white = { 'white', 'black' },
        magenta = { 'magenta', 'black' },
    },
    text = function(_, _, width)
        if width < breakpoint_width then
            return {
                { b_components.line_col_lua, 'white' },
                { b_components.progress_lua, '' },
            }
        end
    end,
}

basic.symbol_outline = {
    text = function(_, _, width)
        return {
            { navic.get_location(), 'magenta' },
        }
    end,
}

basic.git = {
    name = 'git',
    hl_colors = {
        green = { 'green', 'black' },
        red = { 'red', 'black' },
        blue = { 'blue', 'black' },
    },
    width = breakpoint_width,
    text = function(bufnr)
        if git_comps.is_git(bufnr) then
            return {
                { git_comps.diff_added({ format = '  %s', show_zero = true }),   'green' },
                { git_comps.diff_removed({ format = '  %s', show_zero = true }), 'red' },
                { git_comps.diff_changed({ format = ' 󰏬 %s', show_zero = true }),  'blue' },
            }
        end
        return ''
    end,
}

local quickfix = {
    filetypes = { 'qf', 'Trouble' },
    active = {
        { '🚦 Quickfix ',              { 'white', 'black' } },
        { helper.separators.slant_right, { 'black', 'black_light' } },
        {
            function()
                return vim.fn.getqflist({ title = 0 }).title
            end,
            { 'cyan', 'black_light' },
        },
        { ' Total : %L ',                { 'cyan', 'black_light' } },
        { helper.separators.slant_right, { 'black_light', 'InactiveBg' } },
        { ' ',                           { 'InactiveFg', 'InactiveBg' } },
        basic.divider,
        { helper.separators.slant_right, { 'InactiveBg', 'black' } },
        { '🧛 ',                       { 'white', 'black' } },
    },
    always_active = true,
    show_last_status = true,
}

local explorer = {
    filetypes = { 'fern', 'NvimTree', 'lir' },
    active = {
        { '  ',                       { 'black', 'red' } },
        { helper.separators.slant_right, { 'red', 'NormalBg' } },
        { b_components.divider,          '' },
        { b_components.file_name(''), { 'white', 'NormalBg' } },
    },
    always_active = true,
    show_last_status = true,
}

basic.lsp_name = {
    width = breakpoint_width,
    name = 'lsp_name',
    hl_colors = {
        magenta = { 'magenta', 'black' },
    },
    text = function(bufnr)
        if lsp_comps.check_lsp(bufnr) then
            return {
                { lsp_comps.lsp_name(), 'magenta' },
            }
        end
        return {
            { b_components.cache_file_type({ icon = true }), 'magenta' },
        }
    end,
}

basic.gitlab_pipeline_status = {
    width = breakpoint_width,
    name = 'gitlab_pipeline_status',
    hl_colors = {
        magenta = { 'magenta', 'black' },
    },
    text = function(bufnr)
        if lsp_comps.check_lsp(bufnr) then
            return {
                { lsp_comps.lsp_name(), 'magenta' },
            }
        end
        return {
            { b_components.cache_file_type({ icon = true }), 'magenta' },
        }
    end,
}


local default = {
    filetypes = { 'default' },
    active = {
        basic.square_mode,
        -- basic.vi_mode,
        basic.file,
        basic.lsp_diagnos,
        --basic.symbol_outline,
        basic.divider,
        basic.file_right,
        basic.lsp_name,
        basic.git,
        { git_comps.git_branch(), { 'magenta', 'black' }, breakpoint_width },
        basic.fileStats,
        { ' ',                    hl_list.Black },
    },
    inactive = {
        { b_components.full_file_name, hl_list.Inactive },
        basic.file_name_inactive,
        basic.divider,
        basic.divider,
        { b_components.line_col,       hl_list.Inactive },
        { b_components.progress,       hl_list.Inactive },
    },
}

local winbar = {
    filetypes = { 'winbar' },
    active = {
        {
            function(bufnr)
                return navic.get_location({ highlight = true }, bufnr)
            end
        },
    },
    inactive = {
        { ' ', { 'white', 'InactiveBg' } },
        { '%=' },
        {
            function(bufnr)
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                local path = vim.fn.fnamemodify(bufname, ':~:.')
                return path
            end,
            { 'white', 'InactiveBg' },
        },
    },
    --- enable=function(bufnr,winid)  return true end --a function to disable winbar on some window or filetype
}

windline.setup({
    colors_name = function(colors)
        -- print(vim.inspect(colors))
        -- ADD MORE COLOR HERE ----
        colors.black = "#000000"
        return colors
    end,
    statuslines = {
        default,
        quickfix,
        explorer,
        -- winbar,
    },
})



-- Fix: Prevent WindLine from forcing a local statusline on floating windows
-- (which causes a statusline to overlap snacks.nvim pickers)
local M = require('windline')
local old_on_win_enter = M.on_win_enter
M.on_win_enter = function(bufnr, winid)
    winid = winid or vim.api.nvim_get_current_win()
    if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_config(winid).relative ~= '' then
        -- It's a floating window, abort early so we don't set a local statusline
        return
    end
    return old_on_win_enter(bufnr, winid)
end
