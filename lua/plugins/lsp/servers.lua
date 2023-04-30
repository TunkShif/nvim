return {
  lua_ls = require("plugins.lsp.server.lua_ls"),
  elixirls = { cmd = { "elixir-ls" } },
  html = {},
  cssls = {},
  jsonls = require("plugins.lsp.server.json_ls"),
  tailwindcss = require("plugins.lsp.server.tailwind"),
  pyright = {},
  solargraph = {},
  zls = {},
}
