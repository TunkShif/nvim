(module mods.lsp.html
  {autoload {lsp mods.lsp.lsp}})

(lsp.use :html
         {:hook (fn [client buffer]
                  ;; disable formatting, using formatting via null-ls instead
                  (set client.server_capabilities.documentFormattingProvider false)
                  (set client.server_capabilities.documentRangeFormattingProvider false))})
