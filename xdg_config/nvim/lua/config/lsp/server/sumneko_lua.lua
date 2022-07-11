local settings = {
   -- INFO: These settings are not used if a .luarc.json is found (I think)
   settings = {
      Lua = {
         runtime = {
            version = "LuaJIT",
            path = vim.list_extend(vim.split(package.path, ";"), {
               "lua/?.lua",
               "lua/?/init.lua",
            }),
         },
         workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            useGitIgnore = true,
         },
         completion = {
            keywordSnippet = "Replace",
            callSnippet = "Replace",
            displayContext = 10,
            autoRequire = true,
         },
         format = {
            enable = true,
            defaultConfig = {
               -- INFO: Can be overridden by .editorconfig
               indent_style = "space",
               indent_size = "3",
            },
         },
         diagnostics = {
            globals = { "vim" },
            neededFileStatus = {
               ["codestyle-check"] = "Any",
            },
         },
         telemetry = {
            enable = false,
         },
      },
   },
}

return settings
