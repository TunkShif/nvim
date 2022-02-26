(module mods.lsp.tsserver
  {autoload {lsp mods.lsp.lsp
             ts-utils nvim-lsp-ts-utils}})

(lsp.use :tsserver
         {:hook (fn [client buffer]
                  ;; disable tsserver formatting, using formatting via null-ls instead
                  (set client.resolved_capabilities.document_formatting false)
                  (set client.resolved_capabilities.document_range_formatting false)
                  (ts-utils.setup {:enable_formatting true})
                  (ts-utils.setup_client client))
          :opts {:init_options ts-utils.init_options}})
