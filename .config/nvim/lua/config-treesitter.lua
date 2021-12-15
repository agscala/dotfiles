local ts_config = require("nvim-treesitter.configs")

ts_config.setup {
    -- ensure_installed = "all",
    ensure_installed = {
        "javascript",
        "typescript",
        "markdown",
        "elixir",
        "c_sharp",
        "c",
        "rust",
        "go",
        "graphql",
        "ruby",
        "rust",
        "svelte",
        "tsx",
        "vue",
        "yaml",
        "html",
        "css",
        "bash",
        "lua",
        "json",
        "python"
    },
    highlight = {
        enable = true,
        use_languagetree = true
    }
}
