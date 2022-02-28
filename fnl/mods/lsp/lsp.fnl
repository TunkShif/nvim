(module mods.lsp.lsp
  {autoload {lsp-config lspconfig
             cmp-lsp cmp_nvim_lsp
             which-key which-key}})

(def- border
  [[ "╭" :FloatBorder ]
   [ "─" :FloatBorder ]
   [ "╮" :FloatBorder ]
   [ "│" :FloatBorder ]
   [ "╯" :FloatBorder ]
   [ "─" :FloatBorder ]
   [ "╰" :FloatBorder ]
   [ "│" :FloatBorder ]])

(defn- make-on-attach [hook]
  (fn [client buffer]
    (which-key.register
      {:gD [ "<cmd>lua vim.lsp.buf.declaration()<cr>"    "Goto declaration"]
       :gd [ "<cmd>lua vim.lsp.buf.definition()<cr>"     "Goto definition"]
       :gi [ "<cmd>lua vim.lsp.buf.implementation()<cr>" "Goto implementation"]
       :gr [ "<cmd>lua vim.lsp.buf.references()<cr>"     "Goto references"]
       :K  [ "<cmd>lua vim.lsp.buf.hover()<cr>"          "Hover"]}
      {:buffer buffer
       :silent true})
    (which-key.register
      {:c {:name "code"
           :r [ "<cmd>lua vim.lsp.buf.rename()<cr>"         "Rename"]
           :a [ "<cmd>lua vim.lsp.buf.code_action()<cr>"    "Code action"]
           :f [ "<cmd>lua vim.lsp.buf.formatting()<cr>"     "Format"]
           :k [ "<cmd>lua vim.lsp.buf.signature_help()<cr>" "Signature help"]
           }}
      {:prefix "<leader>"
       :buffer buffer
       :silent true})
    (tset vim.lsp.handlers "textDocument/hover" (vim.lsp.with vim.lsp.handlers.hover {:border border}))
    (when hook
      (hook client buffer))))

(defn use [name config]
  (let [server (. lsp-config name)
        opts (or (. config :opts) {})
        hook (. config :hook)]
    (tset opts :on_attach (make-on-attach hook))
    (tset opts :capabilities (cmp-lsp.update_capabilities (vim.lsp.protocol.make_client_capabilities)))
    (server.setup opts))
  nil)

(let [servers [:bashls
               :clangd
               :html
               :emmet_ls
               :ocamllsp
               :pyright
               :crystalline
               :clojure_lsp
               :racket_langserver
               :erlangls
               :solargraph]]
  (each [_ server (ipairs servers)]
    (use server {})))

(require :mods.lsp.null-ls)
(require :mods.lsp.tsserver)
(require :mods.lsp.elixir-ls)
(require :mods.lsp.lua-language-server)
