(module mods.lsp.cmp
  {autoload {cmp cmp}})

(set vim.o.completeopt "menu,menuone,noselect")

(defn- has-words-before? []
  (let [(line col) (unpack (vim.api.nvim_win_get_cursor 0))]
    (and (not= col 0)
         (= (-> (vim.api.nvim_buf_get_lines 0 (- line 1) line true)
                (. 1)
                (: :sub col col)
                (: :match "%s"))
            nil))))

(defn- feedkey [key mode]
  (vim.api.nvim_feedkeys (vim.api.nvim_replace_termcodes key true true true) mode true))

(defn- on-tab-down [fallback]
  (if
    (cmp.visible)
    (cmp.select_next_item)
    (= ((. vim.fn :vsnip#available) 1) 1)
    (feedkey "<Plug>(vsnip-expand-or-jump)" "")
    (has-words-before?)
    (cmp.complete)
    (fallback)))

(defn- on-s-tab-down []
  (if
    (cmp.visible)
    (cmp.select_prev_item)
    (= ((. vim.fn :vsnip#jumpable) (- 1)) 1)
    (feedkey "<Plug>(vsnip-jump-prev)" "")))

(cmp.setup
  {:snippet {:expand (fn [args]
                       ((. vim.fn :vsnip#anonymous) args.body))}
   :mapping {:<CR> (cmp.mapping.confirm {:select true})
             :<Tab> (cmp.mapping on-tab-down [:i :s])
             :<S-Tab> (cmp.mapping on-s-tab-down [:i :s])}
   :sources (cmp.config.sources
              [{:name :nvim_lsp}
               {:name :vsnip}
               {:name :buffer}])})

(let [cmp-autopairs (require :nvim-autopairs.completion.cmp)]
  (: cmp.event :on :confirm_done (cmp-autopairs.on_confirm_done {:map_char {:tex ""}})))
