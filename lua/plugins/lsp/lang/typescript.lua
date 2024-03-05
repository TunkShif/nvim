return {
  {
    "jose-elias-alvarez/typescript.nvim",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    opts = {
      server = require("utils.lsp").make_opts({
        on_attach = function(_client, bufnr)
          local wk = require("which-key")
          wk.register({
            l = {
              name = "lsp",
              s = { "<cmd>TypescriptOrganizeImports<cr>", "Sort imports" },
              i = { "<cmd>TypescriptAddMissingImports<cr>", "Add missing imports" },
              d = { "<cmd>TypescriptRemoveUnused<cr>", "Removed unused" },
              r = { "<cmd>TypescriptRenameFile<cr>", "Rename file" },
              g = { "<cmd>TypescriptGoToSourceDefinition<cr>", "Goto source definition" },
            },
          }, {
            buffer = bufnr,
            prefix = "<localleader>",
            silent = true,
          })
        end,
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "non-relative",
          },
        },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      }),
    },
  },
}
