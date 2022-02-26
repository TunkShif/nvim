(module mods.ui.onedark)

(let [onedark (require :onedark)]
  (onedark.setup
    {:style "cool"
     :toggle_style_key "<nop>"})
  (onedark.load))
