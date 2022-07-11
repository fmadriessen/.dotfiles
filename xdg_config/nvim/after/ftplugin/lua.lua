-- Default settings for lua files
vim.opt_local.tabstop = 3
vim.opt_local.shiftwidth = 0
vim.opt_local.textwidth = 120

---Helper function to find the right file for gf in lua files
---Width first traversal combination of 'path' and 'suffixesadd'
---@param fname string
---@return string
_G._lua_includeexpr = function(fname)
   fname = string.gsub(fname, "%.", "/")

   local paths = vim.split(vim.bo.path, ",")
   local exts = vim.split(vim.bo.suffixesadd, ",")

   for _, path in ipairs(paths) do
      path = string.match(path, '/$') and path or path .. '/'
      for _, ext in ipairs(exts) do
         local f = string.format("%s%s", fname, ext)
         if vim.fn.filereadable(path .. f) == 1 then
            return f
         end
      end
   end

   return fname
end

-- Fix gf for neovim configuration
vim.opt_local.suffixesadd:prepend({ "/init.lua", ".lua" })
vim.opt_local.path:prepend({ ".", "lua/" })
vim.opt_local.includeexpr = "v:lua._lua_includeexpr(v:fname)"
