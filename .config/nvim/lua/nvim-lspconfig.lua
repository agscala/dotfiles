local lspconfig = require("lspconfig")
local navic = require("nvim-navic")
local icons = require("icons")

vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = { 
      prefix = "●",
      -- format = function(diagnostic) return "" end ,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      },
    }
    -- virtual_lines = { only_current_line = true },
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "lua_ls",
        "tsserver",
        "stylelint_lsp",
        "css_variables",
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
    ["css_variables"] = function()
      lspconfig.css_variables.setup({
        filetypes = { "typescriptreact", "tsx", "jsx", "css", "scss" },
        root_dir = lspconfig.util.root_pattern(".git"),
      })
    end,

    ["stylelint_lsp"] = function()
      lspconfig.stylelint_lsp.setup({
        filetypes = { "typescriptreact", "tsx", "jsx", "css", "scss" },
        --root_dir = require("lspconfig").util.root_pattern("package.json", ".git"),
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
