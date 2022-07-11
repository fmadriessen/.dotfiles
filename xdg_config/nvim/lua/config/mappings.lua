---Create a new mapping with default options: silent and noremap
---@param mode string | table<string> mode(s) to map for
---@param lhs string key sequence to map
---@param rhs string|function command or callback function
---@param opts table? Non-default options
local map = function(mode, lhs, rhs, opts)
   local conf = {
      noremap = true,
      silent = true,
      expr = false,
   }

   opts = opts or {}
   if type(opts) == "string" then
      conf.desc = opts
   else
      conf = vim.tbl_deep_extend("force", conf, opts)
   end
   vim.keymap.set(mode, lhs, rhs, conf)
end

-- Telescope
map("n", "<leader>ff", function()
   require("telescope.builtin").find_files()
end, { desc = "Find files", silent = false })
map("n", "<leader>hh", function()
   require("telescope.builtin").help_tags()
end, { desc = "Search help tags" })
map("n", "<leader>b", require("telescope.builtin").buffers, "Find buffer")

-- Doc gen
map("n", "<leader>n", function()
   require("neogen").generate({})
end, { desc = "Generate documentation" })

-- Snippets
local luasnip = require("luasnip")
map({ "i", "s" }, "<C-j>", function()
   if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
   end
end)

map({ "i", "s" }, "<C-k>", function()
   if luasnip.jumpable(-1) then
      luasnip.jump(-1)
   end
end)

map({ "i", "s" }, "<C-l>", function()
   if luasnip.choice_active() then
      luasnip.change_choice(1)
      -- require("luasnip.extras.select_choice")()
   end
end)

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic" })

map("n", "<leader>tt", "<cmd>TroubleToggle todo<cr>")

-- WARN: The following mappings override defaults
-- Center and open folds on searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Reselect after indenting
map("v", ">", ">gv")
map("v", "<", "<gv")

-- Set jump list if jumping more lines at a time and jump visual lines if no count is given
-- FIX: Does not work as expected, ignores count
map({ "n", "v" }, "k", function()
   if not vim.v.count then
      return "gk"
   end

   return (vim.v.count > 5 and "m'" .. vim.v.count or "") .. "k"
end, { expr = true })
map({ "n", "v" }, "j", function()
   if not vim.v.count then
      return "gj"
   end

   return (vim.v.count > 5 and "m'" .. vim.v.count or "") .. "j"
end, { expr = true })

-- Speed up execution of autocmds
map("n", "@", function()
   vim.fn.execute('noautocmd norm! " . v:count1 . "@" . getcharstr()')
end)
map("x", "@", [[<C-U>execute "noautocmd '<,'>norm! " . v:count1 . "@" . getcharstr()<CR>]])
