return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*"
  opts = {
    snippet_engine = "luasnip",
    --languages = {
      --['typescriptreact.tsdoc'] = require('neogen.configurations.tsdoc')
    --}
  },
  keys = {
    {"<leader>gd", "<CMD>Neogen<CR>", desc="generate documentation"}
  }
}
