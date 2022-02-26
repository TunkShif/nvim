(module packs
  {autoload {packer packer}})

(defn safe-require [mod]
  (let [(ok? val-or-err) (pcall require (.. :mods. mod))]
    (when (not ok?)
      (print (.. "failed to load config for 'mods." mod "': " val-or-err)))))

(defn- use [...]
  (let [packs [...]]
    (packer.startup
      {1 (fn [use]
            (for [i 1 (length packs) 2]
              (let [name (. packs i)
                    opts (. packs (+ i 1))]
                (-?> (. opts :mod) (safe-require))
                (table.insert opts 1 name)
                (use opts))))
       :config {:display {:open_fn (. (require :packer.util) :float)}}}))
  nil)

(use
  ;; bootstrap
  :wbthomason/packer.nvim {}
  :Olical/aniseed {}
  :lewis6991/impatient.nvim {}
  
  ;; ui
  :navarasu/onedark.nvim {:mod :ui.onedark}
  :lukas-reineke/indent-blankline.nvim {:mod :ui.indent-line}
  :kyazdani42/nvim-tree.lua {:mod :ui.nvim-tree :requires [[:kyazdani42/nvim-web-devicons]]}
  :goolord/alpha-nvim {:mod :ui.alpha}
  :folke/which-key.nvim {:mod :ui.which-key}
  
  ;; util
  :nvim-telescope/telescope.nvim {:requires [[:nvim-lua/popup.nvim] [:nvim-lua/plenary.nvim]]}
  :ahmedkhalf/project.nvim {:mod :util.project}
  
  ;; lsp
  :neovim/nvim-lspconfig {:mod :lsp.lsp}
  :jose-elias-alvarez/null-ls.nvim {:mod :lsp.null-ls}

  ;; completion
  :hrsh7th/nvim-cmp {:mod :lsp.cmp}
  :hrsh7th/cmp-nvim-lsp {}
  :hrsh7th/cmp-buffer {}
  :hrsh7th/cmp-path {}
  :hrsh7th/cmp-cmdline {}
  :hrsh7th/cmp-vsnip {}
  :hrsh7th/vim-vsnip {}

  ;;tree-sitter
  :nvim-treesitter/nvim-treesitter {:mod :util.tree-sitter}

  ;; lang
  :jose-elias-alvarez/nvim-lsp-ts-utils {})
