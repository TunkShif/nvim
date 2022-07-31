(module mods.lsp.null-ls
  {autoload {null-ls null-ls}})

(null-ls.setup
  {:sources [null-ls.builtins.formatting.stylua
             null_ls.builtins.formatting.autopep8
             (null-ls.builtins.formatting.prettier.with {:only_local "node_modules/.bin"})]})
