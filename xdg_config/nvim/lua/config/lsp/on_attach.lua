---Function to run upon attaching a LSP client, intended to be used from LSP server configuration
---@param client Lsp
---@param bufnr number
local on_attach = function(client, bufnr)

   ---Create a new buffer local mapping with default options: silent and noremap
   ---@param mode string | table<string> mode(s) to map for
   ---@param lhs string key sequence to map
   ---@param rhs string|function command or callback function
   ---@param opts string|table? Description or Non-default options
   local function map_local(mode, lhs, rhs, opts)
      local conf = {
         noremap = true,
         silent = true,
         expr = false,
         buffer = bufnr,
      }

      opts = opts or {}
      if type(opts) == "string" then
         conf.desc = opts
      else
         conf = vim.tbl_deep_extend("force", conf, opts)
      end
      vim.keymap.set(mode, lhs, rhs, conf)
   end

   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc()")
   vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

   -- Highlight symbol under cursor on Hold
   if client.resolved_capabilities.document_highlight then
      local augroup_lsp_highlight =
         vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
         callback = vim.lsp.buf.document_highlight,
         buffer = bufnr,
         group = augroup_lsp_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
         callback = vim.lsp.buf.clear_references,
         buffer = bufnr,
         group = augroup_lsp_highlight,
      })
   end

   require("lsp_signature").on_attach({
      bind = true,
      handler_opts = {
         border = vim.g.border_style,
      },
      hint_enable = false,
   }, bufnr)

   -- Documentation
   map_local({ "n", "v" }, "K", vim.lsp.buf.hover, "Show hover documentation")

   -- Gotos
   map_local(
      "n",
      "gD",
      "<cmd>lua vim.lsp.buf.declaration()<CR>",
      { buffer = bufnr, desc = "Goto declaration" }
   )
   map_local(
      "n",
      "<C-]>",
      "<cmd>lua vim.lsp.buf.definition()<CR>",
      { buffer = bufnr, desc = "Goto definition" }
   )
   map_local(
      "n",
      "gi",
      "<cmd>lua vim.lsp.buf.implementation()<CR>",
      { buffer = bufnr, desc = "Goto implementation" }
   )
   map_local(
      "n",
      "<localleader>D",
      "<cmd>lua vim.lsp.buf.type_definition()<CR>",
      { buffer = bufnr, desc = "Goto type definition" }
   )

   -- Gotos
   map_local(
      "n",
      "gD",
      "<cmd>lua vim.lsp.buf.declaration()<CR>",
      { buffer = bufnr, desc = "Goto declaration" }
   )
   map_local(
      "n",
      "<C-]>",
      "<cmd>lua vim.lsp.buf.definition()<CR>",
      { buffer = bufnr, desc = "Goto definition" }
   )
   map_local(
      "n",
      "gi",
      "<cmd>lua vim.lsp.buf.implementation()<CR>",
      { buffer = bufnr, desc = "Goto implementation" }
   )
   map_local(
      "n",
      "<localleader>D",
      "<cmd>lua vim.lsp.buf.type_definition()<CR>",
      { buffer = bufnr, desc = "Goto type definition" }
   )

   -- Code actions
   map_local(
      "n",
      "<localleader>rn",
      "<cmd>lua vim.lsp.buf.rename()<CR>",
      { buffer = bufnr, desc = "Rename symbol" }
   )
   map_local(
      "n",
      "<localleader>ca",
      "<cmd>lua vim.lsp.buf.code_action()<CR>",
      { buffer = bufnr, desc = "Code action" }
   )
   map_local(
      "v",
      "<localleader>ca",
      "<cmd>'<,'>lua vim.lsp.buf.range_code_action()<CR>",
      { buffer = bufnr, desc = "Code action" }
   )
   map_local(
      "n",
      "<localleader>q",
      "<cmd>lua vim.lsp.buf.formatting()<CR>",
      { buffer = bufnr, desc = "Format file" }
   )
   map_local(
      "v",
      "<localleader>q",
      "<cmd>'<,'>lua vim.lsp.buf.range_formatting()<CR>",
      { buffer = bufnr, desc = "Format range" }
   )

   -- Symbols
   map_local("n", "gr", function()
      require("telescope.builtin").lsp_references({ trim_text = true })
   end, { buffer = bufnr, desc = "Show references" })
   map_local("n", "go", function()
      require("telescope.builtin").lsp_document_symbols()
   end, { buffer = bufnr, desc = "Show document symbols" })
   map_local(
      "n",
      "gO",
      require("telescope.builtin").lsp_workspace_symbols,
      "Show workspace symbols"
   )
end

return on_attach
