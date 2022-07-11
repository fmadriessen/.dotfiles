local augroup_highlight_yank = vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
   callback = function()
      vim.highlight.on_yank()
   end,
   desc = "Highlight yanked area",
   group = augroup_highlight_yank,
})

-- Restore cursor on opening buffer
-- Automatically opens fold (if needed) and centers the view
local augroup_restore_cursor = vim.api.nvim_create_augroup("restore_cursor", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
   callback = function()
      local ignore_filetype = { "gitcommit", "gitrebase" }
      local ignore_buftype = { "quickfix", "nofile", "help" }

      for _, ft in pairs(ignore_filetype) do
         if vim.bo.filetype == ft then
            return
         end
      end

      for _, bt in pairs(ignore_buftype) do
         if vim.bo.buftype == bt then
            return
         end
      end

      local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
      if row > 0 and row <= vim.api.nvim_buf_line_count(0) then
         vim.api.nvim_win_set_cursor(0, { row, col })

         if vim.api.nvim_eval("foldclosed('.')") ~= -1 then
            vim.api.nvim_input("zv")
         end
      end
   end,
   desc = "Restore cursor to last known position",
   group = augroup_restore_cursor,
})
