return {
  {
    "jose-elias-alvarez/typescript.nvim",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    opts = {
      server = require("utils.lsp").make_opts(),
    },
  },
}
