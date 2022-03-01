(module mods.ui.lualine)

(let [lualine (require :lualine)
      gps (require :nvim-gps)]
  (lualine.setup
    {:options {:theme :onedark
               :component_separators "|"
               :section_separators {:left "" :right ""}
               :disabled_filetypes ["NvimTree"]}
     :sections {:lualine_a [:mode]
                :lualine_b [:branch :diff :diagnostics]
                :lualine_c [:filename
                            {1 gps.get_location :cond gps.is_available}]}}))
