return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    cmd = "Neotree",
    keys = {
      {"<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer"}
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  }
}
