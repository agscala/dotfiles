return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
        -- char = "▏",
        indent = {
            char = "│",
        },
        exclude = {
            buftypes = { "terminal" },
            filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "terminal" },
        },
        scope = {
            enabled = false,
            show_start = true,
        },
        whitespace = {
            remove_blankline_trail = true,
        },
    },
}
