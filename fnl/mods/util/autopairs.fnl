(module mods.util.autopairs)

(let [autopairs (require :nvim-autopairs)]
  (autopairs.setup
    {:disable_filetype ["TelescopePrompt" "fennel"]}))
