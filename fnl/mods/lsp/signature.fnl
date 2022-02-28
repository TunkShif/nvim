(module mods.lsp.signature)

(let [signature (require :lsp_signature)]
  (signature.setup
    {:hint_prefix " "}))
