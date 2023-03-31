return {
    'neovim/nvim-lspconfig',
    config = function()
        require "nvim-lspconfig"
        require("lsp_lines").setup()
    end,
    dependencies = {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    }
}
