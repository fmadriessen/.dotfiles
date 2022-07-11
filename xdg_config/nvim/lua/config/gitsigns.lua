require("gitsigns").setup({
   on_attach = function(bufnr)
      ---Create a new buffer local mapping with default options: silent and noremap
      ---@param mode string | table<string> mode(s) to map for
      ---@param lhs string key sequence to map
      ---@param rhs string|function command or callback function
      ---@param opts table? Non-default options
      local map_local = function(mode, lhs, rhs, opts)
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

      local gs = package.loaded.gitsigns

      map_local("n", "]c", function()
         if vim.wo.diff then
            return "]c"
         end
         vim.schedule(function()
            gs.next_hunk()
         end)
         return "<Ignore>"
      end, { expr = true, desc = "Goto next changed hunk" })

      map_local("n", "[c", function()
         if vim.wo.diff then
            return "[c"
         end
         vim.schedule(function()
            gs.prev_hunk()
         end)
         return "<Ignore>"
      end, { expr = true, desc = "Goto previous changed hunk" })

      map_local({ "n", "v" }, "<localleader>gs", gs.stage_hunk, "Stage hunk")
      map_local({ "n", "v" }, "<localleader>gr", gs.reset_hunk, "Reset hunk")
      map_local("n", "<localleader>gu", gs.undo_stage_hunk, "Undo stage hunk")
      map_local("n", "<localleader>gp", gs.preview_hunk, "Preview hunk")
      map_local("n", "<localleader>gd", gs.diffthis, "Diff hunk")

      -- Text object
      map_local({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
   end,
})
