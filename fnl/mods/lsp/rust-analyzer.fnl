(module mods.lsp.rust-analyzer
  {autoload {lsp mods.lsp.lsp}})

(lsp.use :rust_analyzer
         {:hook (fn [client buffer]
                  (let [rust-tools (require :rust-tools)]
                    (rust-tools.setup {})))})
