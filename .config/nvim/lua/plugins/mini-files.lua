return {
  'echasnovski/mini.files',
  keys = {
    { "<leader>tb", "<cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0))<cr>", desc = "mini.files browser" },
  },
  version = '*',
  config = {
    windows = {
      preview = true,
      width_preview = 50,
    }
  }
}
