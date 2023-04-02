return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "cool" })
      vim.cmd([[colorscheme onedark]])
      vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#a5b0c5", bg = "#242b38" })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#abb2bf", bg = "#242b38" })
    end,
  },
}
