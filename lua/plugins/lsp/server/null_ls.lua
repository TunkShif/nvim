return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")

      local sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.rufo,
        null_ls.builtins.formatting.biome.with({
          condition = function(utils)
            return utils.root_has_file({ "biome.json" })
          end,
        }),
        null_ls.builtins.formatting.prettier.with({
          condition = function(utils)
            return utils.root_has_file({
              ".prettierrc",
              "prettierrc.json",
              "prettierrc.yml",
              "prettierrc.yaml",
              "prettierrc.json5",
              ".prettierrc.js",
              ".prettierrc.mjs",
              ".prettierrc.cjs",
              ".prettierrc.config.js",
              ".prettierrc.config.mjs",
              ".prettierrc.config.cjs",
              ".prettierrc.toml",
            })
          end,
        }),
        -- null_ls.builtins.diagnostics.eslint.with({
        --   condition = function(utils)
        --     -- only enabled when eslint config detected
        --     return utils.root_has_file({
        --       ".eslintrc.js",
        --       ".eslintrc.cjs",
        --       ".eslintrc.yaml",
        --       ".eslintrc.yml",
        --       ".eslintrc.json",
        --     })
        --   end,
        -- }),
      }

      null_ls.setup({ sources = sources })
    end,
  },
}
