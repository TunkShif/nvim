(module mods.ui.alpha)

(let [alpha (require :alpha)
      dashboard (require :alpha.themes.dashboard)]
  (set dashboard.section.header.val
       ["                                                     "
        "                                                     "
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ "
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ "
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ "
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ "
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ "
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ "
        "                                                     "])
  (set dashboard.section.buttons.val
       [(dashboard.button "e"       "  > New file"  "<cmd>ene <cr>")
        (dashboard.button "SPC f f" "  > Find file")
        (dashboard.button "SPC f h" "  > Find history")
        (dashboard.button "SPC f g" "  > Find word")
        (dashboard.button "SPC f p" "  > Find project")
        (dashboard.button "q"       "  > Quit" ":qa<CR>")])
  (alpha.setup (. dashboard :opts)))
