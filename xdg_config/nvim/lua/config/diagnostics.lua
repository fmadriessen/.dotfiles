-- Configure nvims built-in diagnostic module
vim.diagnostic.config({
   underline = true,
   virtual_text = false,
   signs = true,
   float = {
      source = "if_many",
      border = vim.g.border_style,
      focusable = false,
   },
   update_in_insert = true,
   severity_sort = true,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
   local hl = "DiagnosticSign" .. type
   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
