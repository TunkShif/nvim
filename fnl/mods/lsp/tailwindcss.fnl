(module mods.lsp.tailwindcss
  {autoload {lsp mods.lsp.lsp
             document-color document-color}})

(lsp.use :tailwindcss
         {:opts {:init_options {:userLanguages {:elixir "html"
                                                :eelixir "html"
                                                :heex "html"}}}
          :hook (fn [client buffer]
                  (document-color.buf_attach buffer))})
