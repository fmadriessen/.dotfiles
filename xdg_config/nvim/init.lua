-- ./init.lua: set built in options and chain-load other configuration files
-- ./filetype.lua: filetype detection configuration
-- ./after/ftplugins/: contains overrides for options per filetype
-- ./lua/config/: contains split-out configuration files
-- ./snippets: snippets for LuaSnip

-- HINT: NVIM Lua can pretty print output when using :lua =function()
-- WARN: experimental: Enable filetype.lua filetype detection
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.g.mapleader = " "
vim.g.maplocalleader = vim.g.mapleader
vim.g.tex_flavor = "latex"
vim.g.border_style = "single"
vim.g.cursorhold_updatetime = 500

-- Basic options
local opt = vim.opt
opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.fillchars = {
   diff = "╱",
   foldopen = "",
   foldclose = "",
   foldsep = " ",
}
opt.foldtext = 'v:lua.require("config.fold").foldtext()'
opt.ignorecase = true
opt.list = true
opt.listchars = {
   trail = "•",
   extends = "»",
   precedes = "«",
   nbsp = "•",
   tab = "> ",
}
opt.mouse = "a"
opt.number = true
opt.pumblend = 0
opt.relativenumber = true
opt.scrolloff = 5
opt.shiftwidth = 0
opt.signcolumn = "auto:1-2"
opt.smartcase = true
opt.spelllang = { "en_gb", "nl" }
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 4
opt.termguicolors = true
opt.tildeop = true
opt.undofile = true

-- Load other configuration files
local config_files = { "plugins", "mappings", "diagnostics", "autocmds" }
for _, file in pairs(config_files) do
   require("config." .. file)
end

-- Set colourscheme
vim.cmd([[colorscheme rose-pine]])
opt.background = "dark"
