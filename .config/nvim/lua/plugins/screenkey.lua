return {
    "NStefan002/screenkey.nvim",
    lazy = false,
    version = "*", -- or branch = "main", to use the latest commit
    keys = {
      { "<leader>tk", "<cmd>lua require('screenkey').toggle()<cr>", desc = "Screenkey toggle" },
    },
}
