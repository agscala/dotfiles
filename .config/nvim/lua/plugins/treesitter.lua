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
        "go",
        "graphql",
        "ruby",
        "rust",
        "tsx",
        "yaml",
        "html",
        "css",
        "bash",
        "lua",
        "json",
        "python",
        "vimdoc"
      },
      highlight = {
        enable = true,
      }
    }
  end,
}
