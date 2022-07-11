---Get gutter width of the window
---@param winid number
---@return number
local get_gutter_width = function(winid)
   return vim.fn.getwininfo(winid)[1].textoff
end

---Remove fold marker from string if it is within a comment and trim trailing whitespace
---@param line string
---@param lnum number
---@return string
local mangle_line = function(line, lnum)
   local _, commentstring =
      pcall(require("ts_context_commentstring.internal").calculate_commentstring, {
         location = { lnum, 0 },
      })

   commentstring = vim.split(commentstring or vim.bo.commentstring, "%%s")[1]

   if vim.wo.foldmethod == "marker" then
      for _, marker in ipairs(vim.split(vim.wo.foldmarker, ",")) do
         line = vim.fn.substitute(line, commentstring .. "\\(.*\\)\\zs" .. marker, "", "g")
      end
   end
   return line:gsub('%s+$', "")
end

---Create prettier fold text, to be used with 'foldtext'
---@return string foldtext
local foldtext = function()
   local line = mangle_line(
      vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1],
      vim.v.foldstart
   )
   local win = vim.api.nvim_get_current_win()
   local line_count = vim.v.foldend - vim.v.foldstart + 1
   local fold_info = line_count .. " lines"
   local padding = vim.api.nvim_win_get_width(win) - get_gutter_width(win) - #line - #fold_info - 1
   return line .. string.rep(" ", padding) .. fold_info .. " "
end

return {
   foldtext = foldtext,
}
