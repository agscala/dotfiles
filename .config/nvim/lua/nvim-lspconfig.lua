local lspconfig = require("lspconfig")
local navic = require("nvim-navic")
local icons = require("icons")

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "lua_ls",
        "tsserver",
    }
})

local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

require("mason-lspconfig").setup_handlers({
    function(server_name) lspconfig[server_name].setup({}) end,
    ["tsserver"] = function()
        lspconfig.tsserver.setup({
            on_attach = on_attach,
            init_options = {
                preferences = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                    importModuleSpecifierPreference = 'non-relative',
                },
            },
        })
    end,
    ["eslint"] = function()
        lspconfig.eslint.setup({

        })
    end,
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
            on_attach = on_attach,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim", "use", "require" } },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false
                    },
                    telemetry = { enable = false }
                }
            }
        })
    end
})

vim.fn.sign_define("LspDiagnosticsSignError",
    { text = icons.diagnostics.Error, numhl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("LspDiagnosticsSignWarning",
    { text = icons.diagnostics.Warn, numhl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation",
    { text = icons.diagnostics.Info, numhl = "LspDiagnosticsDefaultInformation" })
--vim.fn.sign_define("LspDiagnosticsSignHint",
    --{ text = icons.diagnostics.Info, numhl = "LspDiagnosticsDefaultHint" })

require('lspkind').init({
    -- defines how annotations are shown
    -- default: symbol
    -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
    mode = 'symbol_text',
});
