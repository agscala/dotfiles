return {
  'stevearc/aerial.nvim',
  opts = {
    layout = {
      resize_to_content = true,
      min_width = 50,
      default_direction = "prefer_right",
    }
  },
  -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
}
