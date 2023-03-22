return {
  'nvim-treesitter/nvim-treesitter',
  config = function()
    require("nvim-treesitter.configs").setup {
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
  end,
}
