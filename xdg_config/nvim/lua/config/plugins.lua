-- Bootstrap packer installation
local packer_bootstrap = false
local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
   packer_bootstrap = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      packer_path,
   })
   vim.cmd([[packadd packer.nvim]])
end

local packer_augroup = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("bufwritepost", {
   pattern = "plugins.lua",
   command = "source <afile> | PackerCompile",
   desc = "Recompile plugin configuration",
   group = packer_augroup,
})

require("packer").startup({
   function(use)
      use("wbthomason/packer.nvim")

      use({
         "nvim-treesitter/nvim-treesitter",
         run = ":TSUpdate",
         requires = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
            "RRethy/nvim-treesitter-endwise",
            "JoosepAlviste/nvim-ts-context-commentstring",
         },
         config = 'require("config.treesitter")',
      })

      use({
         "neovim/nvim-lspconfig",
         config = 'require("config.lsp")',
         requires = {
            "jose-elias-alvarez/null-ls.nvim",
            "ray-x/lsp_signature.nvim",
         },
      })

      use({
         "hrsh7th/nvim-cmp",
         requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-emoji",
            "hrsh7th/cmp-cmdline",
            { "saadparwaiz1/cmp_luasnip", wants = "LuaSnip" },
         },
         wants = { "nvim-autopairs" },
         config = 'require("config.completion")',
      })

      use({ "L3MON4D3/LuaSnip", config = 'require("config.snippets")' })

      use({
         "danymat/neogen",
         wants = "LuaSnip",
         config = function()
            require("neogen").setup({
               enabled = true,
               snippet_engine = "luasnip",
            })
         end,
      })

      use({
         "nvim-telescope/telescope.nvim",
         requires = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
         },
         config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            telescope.setup({
               defaults = {
                  mappings = {
                     i = { ["<C-g>"] = actions.close },
                     n = { ["<C-g>"] = actions.close },
                  },
               },
            })

            telescope.load_extension("fzf")
         end,
      })

      use({
         "folke/todo-comments.nvim",
         requires = "nvim-lua/plenary.nvim",
         config = function()
            require("todo-comments").setup({
               keywords = {
                  TODO = { icon = " " },
                  NOTE = { icon = " ", alt = { "INFO", "HINT" } },
                  WARN = { icon = " " },
                  FIX = { icon = " " },
                  HACK = { icon = " " },
                  PERF = { icon = " " },
               },
            })
         end,
      })

      use({
         "folke/trouble.nvim",
         config = function()
            require("trouble").setup({
               use_diagnostic_signs = true,
            })
         end,
      })

      use({
         "numToStr/Comment.nvim",
         config = require("config.comment")
      })

      use({
         "kylechui/nvim-surround",
         config = function()
            require("nvim-surround").setup()
         end,
      })

      use({
         "lewis6991/gitsigns.nvim",
         config = require("config.gitsigns"),
      })

      use({ "~/src/show-keys.nvim/" })

      -- Colourschemes
      use({ "rose-pine/neovim", as = "rose-pine" })

      -- Background stuff
      use({
         "windwp/nvim-autopairs",
         config = function()
            require("nvim-autopairs").setup({ check_ts = true })
         end,
         wants = "nvim-treesitter",
      })
      use({
         "rcarriga/nvim-notify",
         config = function()
            vim.notify = require("notify")
         end,
      })
      use({
         "lewis6991/spellsitter.nvim",
         config = function()
            require("spellsitter").setup()
         end,
         wants = "nvim-treesitter",
      })
      use({
         "stevearc/dressing.nvim",
         config = function()
            require("dressing").setup({
               input = {
                  border = vim.g.border_style,
               },
               select = {
                  builtin = {
                     border = vim.g.border_style,
                  },
               },
            })
         end,
      })
      use({
         "kyazdani42/nvim-web-devicons",
         -- module = "nvim-web-devicons",
      })
      use("antoinemadec/FixCursorHold.nvim")

      if packer_bootstrap then
         require("packer").sync()
      end
   end,
   config = {
      profile = { enable = true, threshold = 0 },
      display = {
         open_fn = function()
            return require("packer.util").float({ border = vim.g.border_style })
         end,
         prompt_border = vim.g.border_style,
      },
   },
})
