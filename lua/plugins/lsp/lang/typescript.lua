return {
  {
    "jose-elias-alvarez/typescript.nvim",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    keys = {
      { "<localleader>ls", "<cmd>TypescriptOrganizeImports<cr>",      desc = "Sort imports" },
      { "<localleader>li", "<cmd>TypescriptAddMissingImports<cr>",    desc = "Add missing imports" },
      { "<localleader>ld", "<cmd>TypescriptRemoveUnused<cr>",         desc = "Removed unused" },
      { "<localleader>lr", "<cmd>TypescriptRenameFile<cr>",           desc = "Rename file" },
      { "<localleader>lg", "<cmd>TypescriptGoToSourceDefinition<cr>", desc = "Goto source definition" },
    },
    opts = {
      server = require("utils.lsp").make_opts({
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "non-relative",
          },
        },
      }),
    },
  },
}
