(module mods.lsp.elixir-ls
  {autoload {lsp mods.lsp.lsp}})

(lsp.use :elixirls
         {:opts {:cmd ["elixir-ls"] }})
