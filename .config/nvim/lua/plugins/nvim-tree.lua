return {
  'nvim-tree/nvim-tree.lua',
  lazy = true,
  enabled = false,
  cmd = {
    "NvimTreeFindFileToggle",
  },
  keys = {
    { "<leader>ft", "<CMD>NvimTreeFindFileToggle<CR>", desc = "Open file tree for current file" },
    { "<leader>tt", "<CMD>NvimTreeFindFileToggle<CR>", desc = "Open file tree for current file" },
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup()
  end
}
