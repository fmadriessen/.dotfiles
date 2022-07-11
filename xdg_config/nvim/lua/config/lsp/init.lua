---Default configuration options
local default_opts = {
   on_attach = require("config.lsp.on_attach"),
   capabilities = require("cmp_nvim_lsp").update_capabilities(
      vim.lsp.protocol.make_client_capabilities()
   ),
   handlers = require("config.lsp.handlers"),
   flags = {
      debounce_text_changes = 150,
   },
}

local lsp = require("lspconfig")
local servers = {
   sumneko_lua = require("config.lsp.server.sumneko_lua"),
   texlab = require("config.lsp.server.texlab"),
   bashls = {},
}

for server, config in pairs(servers) do
   lsp[server].setup(vim.tbl_deep_extend("force", default_opts, config))
end

-- NULL-LS
require("null-ls").setup(vim.tbl_deep_extend("force", default_opts, require("config.lsp.server.null-ls")))
