(module mods.ui.indent-line)

(let [indent-line (require :indent_blankline)]
  (indent-line.setup
    {:show_current_context true
     :filetype_exclude ["alpha"
                        "startify"
                        "dashboard"
                        "dotooagenda"
                        "log"
                        "fugitive"
                        "gitcommit"
                        "packer"
                        "vimwiki"
                        "markdown"
                        "json"
                        "txt"
                        "vista"
                        "help"
                        "todoist"
                        "NvimTree"
                        "peekaboo"
                        "git"
                        "TelescopePrompt"
                        "undotree"
                        "flutterToolsOutline"
                        "FTerm"
                        ;; for all buffers without filetype
                        ""]}))
