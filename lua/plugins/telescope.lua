return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope oldfiles<cr>", desc = "Find history" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find by grep" },
      { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Find projects" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "ahmedkhalf/project.nvim",
        config = function()
          require("project_nvim").setup()
          require("telescope").load_extension("projects")
        end,
      },
    },
    opts = {
      defaults = {
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
    },
  },
}
