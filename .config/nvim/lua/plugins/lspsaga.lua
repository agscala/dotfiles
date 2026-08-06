return {
  'glepnir/lspsaga.nvim',
  branch = 'main',
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    require('lspsaga').setup({
      lightbulb = {
        enable = false,
        enable_in_insert = false,
        sign = false,
        sign_priority = 40,
        virtual_text = false,
      },
      symbol_in_winbar = {
        enable = false,
      },
    })
  end,
}
