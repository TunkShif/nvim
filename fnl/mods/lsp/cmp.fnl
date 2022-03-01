(module mods.lsp.cmp
  {autoload {cmp cmp}})

(set vim.o.completeopt "menu,menuone,noselect")

(defn- on-tab-down [fallback]
  (if (cmp.visible)
    (let [entry (cmp.get_selected_entry)]
      (if (not entry)
        (cmp.select_next_item {:behavior cmp.SelectBehavior.Select})
        (cmp.confirm)))
    (fallback)))

(cmp.setup
  {:snippet {:expand (fn [args]
                       ((. vim.fn :vsnip#anonymous) args.body))}
   :mapping {:<CR> (cmp.mapping.confirm {:select true})
             :<Tab> (cmp.mapping on-tab-down [:i :s :c])
             ;; :<S-Tab> (cmp.mapping on-s-tab-down [:i :s])
             }
   :sources (cmp.config.sources
              [{:name :nvim_lsp}
               {:name :vsnip}
               {:name :buffer}])})

(let [cmp-autopairs (require :nvim-autopairs.completion.cmp)]
  (: cmp.event :on :confirm_done (cmp-autopairs.on_confirm_done {:map_char {:tex ""}})))
