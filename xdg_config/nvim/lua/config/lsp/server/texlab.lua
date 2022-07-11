return {
   settings = {
      texlab = {
         auxDirectory = ".",
         bibtexFormatter = "texlab",
         build = {
            executable = "latexmk",
            args = { "-lualatex", "-synctex=1", "%f" },
            forwardSearchAfter = false,
            onSave = true,
         },
         forwardSearch = {
            -- NOTE: nvim --remote does not yet support init commands, for now we still depend on nvim-remote
            executable = "zathura",
            args = {
               "--synctex-forward",
               "%l:1:%f",
               "--synctex-editor-command",
               "nvr --servername "
                  .. vim.fn.serverlist()[1]
                  .. " --remote-silent +%{line} %{input}",
               "%p",
            },
         },
         chktex = {
            onEdit = true,
            onOpenAndSave = true,
         },
      },
   },
}
