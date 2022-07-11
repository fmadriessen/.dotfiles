local types = require("luasnip.util.types")

local luasnip = require("luasnip")
luasnip.config.set_config({
   history = true,
   update_events = "TextChanged,TextChangedI",
   enable_autosnippets = true,
   ext_opts = {
      [types.choiceNode] = {
         active = {
            virt_text = { { "●", "DiagnosticWarn" } },
         },
      },
      [types.insertNode] = {
         active = {
            virt_text = { { "●", "DiagnosticInfo" } },
         },
      },
   },
})

require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })

vim.api.nvim_create_user_command("LuaSnipEdit", function()
   require("luasnip.loaders.from_lua").edit_snippet_files()
end, { desc = "Edit snippets", force = false })
