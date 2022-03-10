(module mods.lsp.rust-analyzer
  {autoload {lsp mods.lsp.lsp}})

(let [rust-tools (require :rust-tools)]
  (rust-tools.setup
    {:server {:on_attach (lsp.make-on-attach)}}))
