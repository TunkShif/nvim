(module mods.lsp.null-ls
  {autoload {null-ls null-ls}})

(null-ls.setup
  {:sources [null-ls.builtins.formatting.stylua
             ;; null-ls.builtins.formatting.fnlfmt
             (null-ls.builtins.formatting.prettier.with {:only_local "node_modules/.bin"})]})
