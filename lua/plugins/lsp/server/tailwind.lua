return {
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
}
