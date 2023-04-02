(module mods.lsp.tsserver
  {autoload {lsp mods.lsp.lsp
             which-key which-key
             typescript typescript}})

(typescript.setup {:server {:on_attach (lsp.make-on-attach)}})

;; (lsp.use :tsserver
;;          {:hook (fn [client buffer]
;;                   ;; disable tsserver formatting, using formatting via null-ls instead
;;                   (set client.resolved_capabilities.document_formatting false)
;;                   (set client.resolved_capabilities.document_range_formatting false)
;;                   (ts-utils.setup {:enable_formatting true})
;;                   (ts-utils.setup_client client)
;;                   (which-key.register
;;                     {:l {:name "LSP"
;;                          :o [ "<cmd>TSLspOrganize<cr>"  "Organize imports"]
;;                          :i [ "<cmd>TSLspImportAll<cr>" "Import missing imports"]
;;                          :r [ "<cmd>TSLspRenameFile<cr>"    "Rename file"]}}
;;                     {:prefix "<localleader>"
;;                      :buffer buffer
;;                      :silent true}))
;;           :opts {:init_options ts-utils.init_options}})
