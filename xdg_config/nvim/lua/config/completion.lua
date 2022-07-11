local cmp = require("cmp")
cmp.setup({
   snippet = {
      expand = function(args)
         require("luasnip").lsp_expand(args.body)
      end,
   },
   window = {
      completion = cmp.config.window.bordered({ border = vim.g.border_style }),
      documentation = cmp.config.window.bordered({ border = vim.g.border_style }),
   },
   experimental = {
      ghost_text = true,
   },
   formatting = {
      format = function(_, item)
         local cmp_kinds = {
            Text = "  ",
            Method = "  ",
            Function = "  ",
            Constructor = "  ",
            Field = "  ",
            Variable = "  ",
            Class = "  ",
            Interface = "  ",
            Module = "  ",
            Property = "  ",
            Unit = "  ",
            Value = "  ",
            Enum = "  ",
            Keyword = "  ",
            Snippet = "  ",
            Color = "  ",
            File = "  ",
            Reference = "  ",
            Folder = "  ",
            EnumMember = "  ",
            Constant = "  ",
            Struct = "  ",
            Event = "  ",
            Operator = "  ",
            TypeParameter = "  ",
         }

         item.kind = (cmp_kinds[item.kind] or "") .. item.kind
         return item
      end,
   },
   mapping = cmp.mapping.preset.insert({
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
      ["<C-e>"] = cmp.mapping({
         i = cmp.mapping.abort(),
         c = cmp.mapping.close(),
      }),
   }),
   sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "nvim_lua" },
      { name = "emoji" },
   }, {
      {
         name = "buffer",
         keyword_length = 5,
         sorting = {
            comparators = {
               function(...)
                  return require("cmp_buffer"):compare_locality(...)
               end,
            },
         },
      },
   }),
})
cmp.setup.cmdline(
   "/",
   { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } }
)
cmp.setup.cmdline(
   ":",
   { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "path" }, { name = "cmdline" } } }
)

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
