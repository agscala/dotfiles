local icons = require("icons")

vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = {
        prefix = "●",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
        },
    },
})

vim.fn.sign_define("LspDiagnosticsSignError", { text = icons.diagnostics.Error, numhl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("LspDiagnosticsSignWarning", { text = icons.diagnostics.Warn, numhl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation", { text = icons.diagnostics.Info, numhl = "LspDiagnosticsDefaultInformation" })

require("lspconfig.ui.windows").default_options.border = "single"

vim.lsp.config("gdscript", {
    cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
})

vim.lsp.config("ts_ls", {
    init_options = {
        preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            importModuleSpecifierPreference = "non-relative",
        },
    },
})

vim.lsp.config("css_variables", {
    filetypes = { "typescriptreact", "tsx", "jsx", "css", "scss" },
})

vim.lsp.config("stylelint_lsp", {
    filetypes = { "css", "scss" },
    settings = {
        stylelintplus = {
            autoFixOnSave = true,
            autoFixOnFormat = true,
        },
    },
    on_attach = function(client)
        client.server_capabilities.document_formatting = false
    end,
})

vim.lsp.config("lua_ls", {
    on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, bufnr)
        end
    end,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "use", "require" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

for _, server in ipairs({
    "gdscript",
    "bashls",
    "lua_ls",
    "ts_ls",
    "stylelint_lsp",
    "css_variables",
}) do
    vim.lsp.enable(server, true)
end

require("lspkind").init({ mode = "symbol_text" })

vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover({ border = "rounded" })
end, { desc = "Hover Documentation" })
