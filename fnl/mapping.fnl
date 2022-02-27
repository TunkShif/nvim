(module mapping
  {autoload {which-key which-key}})

(which-key.register
  {:f {:name "find"
       :f ["<cmd>Telescope find_files<cr>" "Find files"]
       :b ["<cmd>Telescope buffers<cr>"    "Find buffers"]
       :h ["<cmd>Telescope oldfiles<cr>"   "Find history"]
       :g ["<cmd>Telescope live_grep<cr>"  "Find by grep"]
       :p ["<cmd>Telescope projects<cr>"   "Find projects"]}

   :F {:name "file"
       :w ["<cmd>w<cr>" "Save file"]}

   :w {:name "window"
       :h ["<C-w>h" "Go to left window"]
       :j ["<C-w>j" "Go to down window"]
       :k ["<C-w>k" "Go to up window"]
       :l ["<C-w>l" "Go to right window"]
       :H ["<C-w>H" "Move window left"]
       :J ["<C-w>J" "Move window down"]
       :K ["<C-w>K" "Move window up"]
       :L ["<C-w>L" "Move window right"]
       :s ["<C-w>s" "Split window horizontally"]
       :v ["<C-w>v" "Split window vertically"]
       :x ["<C-w>x" "Swap current window with next"]
       :q ["<C-w>q" "Quit current window"]
       :w ["<C-w>w" "Switch windows"]}

   :p {:name "packs"
       :i ["<cmd>PackerInstall<cr>" "Install plugins"]
       :u ["<cmd>PackerUpdate<cr>"  "Update plugins"]
       :c ["<cmd>PackerCompile<cr>"  "Compile packer file"]
       :C ["<cmd>PackerClean<cr>"   "Clean plugins"]}

   :e     ["<cmd>NvimTreeToggle<cr>" "Toggle NvimTree"]
   :<Esc> ["<cmd>silent! nohls<cr>"  "Clear search highlight"]}

  {:prefix "<leader>"})

(which-key.register
  {:==             ["<cmd>lua vim.lsp.buf.formatting()<cr>" "Code format"]
   :<localleader>  ["\"+" "Using system clipboard register"]}

  {:prefix "<localleader>"})

(which-key.register
  {:<localleader>  ["\"+" "Using system clipboard register"]}

  {:prefix "<localleader>" :mode :v})
