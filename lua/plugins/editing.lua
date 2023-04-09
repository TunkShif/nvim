return {
  {
    "ggandor/leap.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
    },
    config = function(_, opts)
      local cmp = require("cmp")
      local autopairs = require("nvim-autopairs")

      autopairs.setup(opts)
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
