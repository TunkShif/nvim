return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      use_treesitter = true,
      show_current_context = true,
      buftype_exclude = {
        "nofile",
        "terminal",
      },
      filetype_exclude = {
        "help",
        "startify",
        "aerial",
        "alpha",
        "dashboard",
        "lazy",
        "neogitstatus",
        "NvimTree",
        "neo-tree",
        "Trouble",
        "FTerm",
        "gitcommit",
        "TelescopePrompt",
        "undotree",
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        default_prompt = "➤ ",
        win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
      },
      select = {
        backend = { "telescope", "builtin" },
        builtin = { win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    command = "ToggleTerm",
    keys = {
      { "<C-`>", "<cmd>ToggleTerm<cr>", mode = { "n", "i", "t" }, desc = "Toggle terminal" },
    },
    opts = {},
  },
}
