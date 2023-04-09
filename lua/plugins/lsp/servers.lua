return {
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
  elixirls = {
    cmd = { "elixir-ls" },
  },
  html = {},
  cssls = {},
  -- denols = {},
  tailwindcss = {
    init_options = {
      userLanguages = {
        elixir = "html-eex",
        eelixir = "html-eex",
        heex = "html-eex",
      },
    },
    settings = {
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "styled\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          "tw\\.\\w+`([^`]*)",
          "\\/\\* tw \\*\\/\\s+`([^`]*)",
        },
      },
    },
  },
  pyright = {},
  solargraph = {},
  zls = {},
}
