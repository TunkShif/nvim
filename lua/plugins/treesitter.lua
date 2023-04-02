return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash", "c", "comment", "css", "cpp", "dockerfile", "diff", "ebnf", "eex", "elixir", "erlang", "gitattributes",
        "gitcommit", "gitignore", "graphql", "heex", "haskell", "html", "java", "javascript", "json", "jsonc", "kotlin",
        "lua", "markdown", "markdown_inline", "ocaml", "ocaml_interface", "python", "racket", "rasi", "regex", "ruby",
        "rust", "scala", "scheme", "sql", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml", "zig"
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      -- incremental_selection = {
      --   enable = true,
      --   keymaps = {
      --     init_selection = "gnn", -- set to `false` to disable one of the mappings
      --     node_incremental = "grn",
      --     scope_incremental = "grc",
      --     node_decremental = "grm",
      --   },
      -- },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  }
}
