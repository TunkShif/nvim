(module mods.util.tree-sitter)

(let [tree-sitter-config (require :nvim-treesitter.configs)]
  (tree-sitter-config.setup
    {:ensure_installed :maintained
     :ignore_install []
     :highlight {:enable true
                 :disble []}
     :autotag {:enable true}
     :textobjects {:select {:enable true
                            :lookahead true
                            :keymaps {:af "@function.outer"
                                      :if "@function.inner"
                                      :ac "@class.outer"
                                      :ic "@class.inner"
                                      :ab "@block.outer"
                                      :ib "@block.inner"}}}}))
