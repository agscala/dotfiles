return {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    lazy= false,
    config = function ()
        require("nvim-navic").setup {
            icons = require("icons").kinds,
            lsp = {
                auto_attach = false,
                preference = nil,
            },
            highlight = false,
            separator = " > ",
            depth_limit = 0,
            depth_limit_indicator = "..",
            safe_output = true
        }

        --vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end
}
