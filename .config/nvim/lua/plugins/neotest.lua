return {
  "nvim-neotest/neotest",
  dependencies = {
    "marilari88/neotest-vitest",
  },
  keys = {
      { "<leader>tv", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle Vitest" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest")({
          filter_dir = function(name, rel_path, root)
            return name ~= "node_modules"
          end,
        }),
      }
    })
  end,
}
