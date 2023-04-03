return {
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = {
      server = require("utils.lsp").make_opts(),
    },
  },
}
