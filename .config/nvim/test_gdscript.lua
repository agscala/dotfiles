local lspconfig = require("lspconfig")
print(vim.inspect(lspconfig.gdscript.document_config.default_config.cmd))
