return {
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  keys = {
    { "<leader>ft", "<CMD>NvimTreeFindFileToggle<CR>", desc="Open file tree for current file" },
    { "<leader>tt", "<CMD>NvimTreeFindFileToggle<CR>", desc="Open file tree for current file" },
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup()
  end
}
