return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        -- char = "▏",
        char = "│",
        buftype_exclude = { "terminal" },
        filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "terminal" },
        show_trailing_blankline_indent = true,
        show_current_context = false,
        show_first_indent_level = true,
    },
}
