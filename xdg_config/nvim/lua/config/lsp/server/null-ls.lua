local nls = require("null-ls")
local formatting = nls.builtins.formatting
local diagnostics = nls.builtins.diagnostics
local code_actions = nls.builtins.code_actions
local nls_sources = {
   formatting.stylua,
   diagnostics.selene.with({
      condition = function(utils)
         return utils.root_has_file("selene.toml")
      end,
   }),

   diagnostics.fish,
   formatting.fish_indent,

   diagnostics.shellcheck,
   formatting.shfmt,

   code_actions.gitsigns,
}

return {
   sources = nls_sources,
   save_after_format = false,
   update_in_insert = true,
}
