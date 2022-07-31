(module mods.lsp.tailwindcss
  {autoload {lsp mods.lsp.lsp}})

(lsp.use :tailwindcss
         {:opts {:init_options {:userLanguages {:elixir "html-eex"
                                                :eelixir "html-eex"
                                                :heex "html-eex"}}
                 :filetypes [:elixir
                             :eelixir
                             :html
                             :html-eex
                             :heex
                             :css
                             :less
                             :postcss
                             :sass
                             :scss
                             :javascript
                             :javascriptreact
                             :typescript
                             :typescriptreact
                             :vue
                             :rescript]}})
