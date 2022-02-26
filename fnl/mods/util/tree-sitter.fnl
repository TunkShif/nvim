(module mods.util.tree-sitter)

(let [tree-sitter-config (require :nvim-treesitter.configs)]
  (tree-sitter-config.setup
    {:ensure_installed :maintained
     :ignore_install []
     :highlight {:enable true
                 :disble []}}))
