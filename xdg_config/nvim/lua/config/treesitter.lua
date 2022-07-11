require("nvim-treesitter.configs").setup({
   ensure_installed = "all",
   highlight = { enable = true },
   indent = { enable = true },
   textobjects = {
      select = {
         enable = true,
         lookahead = true,
         keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
         },
      },
      move = {
         enable = true,
         set_jumps = true,
         goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer'
         },
         goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer'
         },
         goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer'
         },
         goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer'
         }
      },
   },
   context_commentstring = {
      enable = true,
      enable_autocmd = false,
   },
   incremental_selection = {
      enable = true,
      keymaps = {
         init_selection = "<C-n>",
         node_incremental = "<C-n>",
         node_decremental = "<C-r>",
      },
   },
   endwise = {
      enable = true
   },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
