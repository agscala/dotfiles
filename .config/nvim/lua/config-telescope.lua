local actions = require('telescope.actions')

require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-c>"] = actions.close,
                -- ["<esc>"] = actions.close,
            },
            n = {
                ["<C-c>"] = actions.close,
                ["<esc>"] = actions.close,
            },
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
        },
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = "  ",
        path_display = { "smart" },
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        scroll_strategy = "cycle",
        layout_config = {
            horizontal = {
                mirror = false,
                preview_width = 0.5
            },
            vertical = {
                mirror = false
            }
        },
        file_sorter = require "telescope.sorters".get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require "telescope.sorters".get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
        color_devicons = true,
        use_less = true,
        set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
        file_previewer = require "telescope.previewers".vim_buffer_cat.new,
        grep_previewer = require "telescope.previewers".vim_buffer_vimgrep.new,
        qflist_previewer = require "telescope.previewers".vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require "telescope.previewers".buffer_previewer_maker
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                       -- the default case_mode is "smart_case"
        },
    }
}

require("telescope").load_extension("fzf")

local opt = {noremap = true, silent = true}

-- mappings
-- vim.api.nvim_set_keymap("n", "<Leader>ff", [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], opt)
-- vim.api.nvim_set_keymap(
    -- "n",
    -- "<Leader>fp",
    -- [[<Cmd>lua require('telescope').extensions.media_files.media_files()<CR>]],
    -- opt
-- )

-- vim.api.nvim_set_keymap("n", "<Leader>fs", [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], opt)
-- vim.api.nvim_set_keymap("n", "<Leader>fb", [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], opt)
-- vim.api.nvim_set_keymap("n", "<Leader>fh", [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], opt)
-- vim.api.nvim_set_keymap("n", "<Leader>fo", [[<Cmd>lua require('telescope.builtin').oldfiles()<CR>]], opt)
-- vim.api.nvim_set_keymap("n", "<Leader>fm", [[<Cmd> Neoformat<CR>]], opt)
-- vim.api.nvim_set_keymap("i", "<C-e>", [[<Cmd>lua require'telescope.builtin'.symbols() <CR>]], opt)


