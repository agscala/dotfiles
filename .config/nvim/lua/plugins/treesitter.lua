return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- New main branch API for nvim-treesitter
    require('nvim-treesitter').setup {}
    require('nvim-treesitter').install({
        "javascript",
        "typescript",
        "markdown",
        "elixir",
        "heex",
        "eex",
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
        "vimdoc",
        "gdscript",
        "godot_resource",
        "gdshader"
    })
    
    -- In the new rewrite, you must manually enable native Neovim treesitter highlighting
    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
