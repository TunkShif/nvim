return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        lexical = {
          cmd = { "/home/tunkshif/.local/share/lexical/bin/start_lexical.sh" },
          mason = false,
        },
      },
    },
  },
}
