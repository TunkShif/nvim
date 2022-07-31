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
   :mapping (cmp.mapping.preset.insert
              {:<CR> (cmp.mapping.confirm {:select true})
               :<Tab> (cmp.mapping on-tab-down [:i :s :c])})
   :sources (cmp.config.sources
              [{:name :nvim_lsp}
               {:name :vsnip}
               {:name :buffer}
               {:name :path}])})

(cmp.setup.cmdline
  ":" {:mapping (cmp.mapping.preset.cmdline)
       :sources [{:name :cmdline}]})

(cmp.setup.cmdline
  "/" {:mapping (cmp.mapping.preset.cmdline)
       :sources [{:name :buffer}]
       :view {:entries {:name :wildmenu
                        :separator :|}}})

(vim.cmd "imap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
          smap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
          imap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
          smap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'")

(let [cmp-autopairs (require :nvim-autopairs.completion.cmp)]
  (: cmp.event :on :confirm_done (cmp-autopairs.on_confirm_done {:map_char {:tex ""}})))
