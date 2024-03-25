return {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
        local nls = require("null-ls")

        return {
            root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
            sources = {
                nls.builtins.formatting.fish_indent,
                nls.builtins.formatting.stylua,

                nls.builtins.diagnostics.fish,
                nls.builtins.diagnostics.flake8,

                --nls.builtins.diagnostics.eslint,
            },
        }
    end,
}
