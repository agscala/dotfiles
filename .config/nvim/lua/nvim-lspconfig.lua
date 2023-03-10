local vim = vim

local lspconfig = require("lspconfig")
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "bashls", "sumneko_lua", "tsserver" },
})

local function default_on_attach(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- vim.keymap.set('n', '<c-]>', "<Cmd>lua vim.lsp.buf.definition()<CR>",
        -- bufopts)
    -- vim.keymap.set('n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
    -- vim.keymap.set('n', 'gh', "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
        -- bufopts)
    -- vim.keymap.set('n', 'ga', "<Cmd>lua vim.lsp.buf.code_action()<CR>", bufopts)
    -- vim.keymap.set('n', 'gi', "<Cmd>lua vim.lsp.buf.implementation()<CR>",
        -- bufopts)
    -- vim.keymap.set('n', 'gt', "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
        -- bufopts)
    -- vim.keymap.set('n', 'gr', "<Cmd>lua vim.lsp.buf.references()<CR>", bufopts)
    -- vim.keymap.set('n', 'rn', "<Cmd>lua vim.lsp.buf.rename()<CR>", bufopts)

    -- vim.keymap
        -- .set('n', '[d', "<Cmd>lua vim.diagnostic.goto_prev({float = false})<CR>", bufopts)
    -- vim.keymap
        -- .set('n', ']d', "<Cmd>lua vim.diagnostic.goto_next({float = false})<CR>", bufopts)
    -- vim.keymap.set('n', ']r', "<Cmd>lua vim.diagnostic.open_float()<CR>",
        -- bufopts)

    if client.supports_method("textDocument/prepareCallHeirarchy") then
        -- vim.keymap.set('n', 'gl', "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>",
            -- bufopts)
    end

    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            group = vim.api.nvim_create_augroup("SharedLspFormatting",
                { clear = true }),
            pattern = "*",
            command = "lua vim.lsp.buf.format()"
        })
    end
end

-- local default_on_attach = function(client)
-- -- require("mappings").keys_lsp()
-- client.resolved_capabilities.document_formatting = false
-- client.resolved_capabilities.document_range_formatting = false
-- end

local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
    on_attach = default_on_attach,
    capabilities = default_capabilities,
})

require("mason-lspconfig").setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({})
    end,
    ["sumneko_lua"] = function()
        lspconfig.sumneko_lua.setup({
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = { "vim", "use", "require" },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })
    end,
})

vim.fn.sign_define("LspDiagnosticsSignError", { text = "", numhl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "", numhl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "", numhl = "LspDiagnosticsDefaultInformation" })
vim.fn.sign_define("LspDiagnosticsSignHint", { text = "", numhl = "LspDiagnosticsDefaultHint" })
