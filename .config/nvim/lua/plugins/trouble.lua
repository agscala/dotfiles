return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
    },
    keys = {
        { "<leader>xx", "<cmd>TroubleToggle<cr>" },
        { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
        { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>" },
        { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>" },
        { "<leader>xl", "<cmd>TroubleToggle loclist<cr>" },
        --{ "gR",         "<cmd>TroubleToggle lsp_references<cr>" },
    }
}
