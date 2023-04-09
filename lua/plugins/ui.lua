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
        "text",
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
  {
    "rebelot/heirline.nvim",
    event = "UiEnter",
    opts = {},
  },
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    version = "v3.*",
    keys = {
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>bn", "<cmd>BufferLineMoveNext<cr>", desc = "Move to next" },
      { "<leader>bp", "<cmd>BufferLineMovePrev<cr>", desc = "Move to previous" },
      { "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "Pick buffer to go" },
      { "<leader>bx", "<cmd>BufferLinePickClose<cr>", desc = "Pick buffer to close" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close left buffers" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close right buffers" },
    },
    opts = {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = " NeoTree",
            text_align = "left",
            highlight = "Directory",
            seperator = true
          },
        },
      },
    },
  },
}
