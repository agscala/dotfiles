vim.lsp.set_log_level("debug")
require("lspconfig").gdscript.setup({
  cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
  on_attach = function(client, bufnr)
    print("GDScript LSP attached!")
  end
})
