local wk = require("which-key")

wk.register({
  f = { name = "find", },
  w = {
    name = "window",
    h = { "<C-w>h", "Go to left window" },
    j = { "<C-w>j", "Go to down window" },
    k = { "<C-w>k", "Go to up window" },
    l = { "<C-w>l", "Go to right window" },
    H = { "<C-w>H", "Move window left" },
    J = { "<C-w>J", "Move window down" },
    K = { "<C-w>K", "Move window up" },
    L = { "<C-w>L", "Move window right" },
    s = { "<C-w>s", "Split window horizontally" },
    v = { "<C-w>v", "Split window vertically" },
    x = { "<C-w>x", "Swap current window with next" },
    q = { "<C-w>q", "Quit current window" },
    w = { "<C-w>w", "Switch windows" }
  },
  ["<esc>"] = { "<cmd>silent! nohls<cr>", "Clear search highlight" }
}, { prefix = "<leader>" })

wk.register({
  ["<localleader>"] = { "\"+", "Using system clipboard register" }
}, { prefix = "<localleader>" })

wk.register({
  ["<localleader>"] = { "\"+", "Using system clipboard register" }
}, { prefix = "<localleader>", mode = "v" })

-- (which-key.register
--
--    :b {:name "buffer"
--        :n ["<cmd>BufferLineMoveNext<cr>"   "Move to next"]
--        :p ["<cmd>BufferLineMovePrev<cr>"   "Move to previous"]
--        :b ["<cmd>BufferLinePick<cr>"       "Pick buffer to go"]
--        :x ["<cmd>BufferLinePickClose<cr>"  "Pick buffer to close"]
--        :h ["<cmd>BufferLineCloseLeft<cr>"  "Close left buffers"]
--        :l ["<cmd>BufferLineCloseRight<cr>" "Close right buffers"]}
--
--   {:prefix "<leader>"})
--
-- (which-key.register
--   {"[b" ["<cmd>BufferLineCyclePrev<cr>" "Previous buffer"]
--    "]b" ["<cmd>BufferLineCycleNext<cr>" "Next buffer"]})
