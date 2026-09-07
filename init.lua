vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

local number_toggle_group = vim.api.nvim_create_augroup("NumberToggle", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    pattern = "*",
    group = number_toggle_group,
    callback = function()
        if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
            vim.opt.relativenumber = true
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    pattern = "*",
    group = number_toggle_group,
    callback = function()
        if vim.o.nu then
            vim.opt.relativenumber = false
        end
    end,
})

vim.pack.add({
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/juniorsundar/refer.nvim",
    "https://github.com/folke/which-key.nvim",

    "https://github.com/mason-org/mason.nvim",

    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/saghen/blink.lib",
    "https://github.com/Saghen/blink.cmp",
    "https://github.com/stevearc/conform.nvim",
})

vim.cmd.colorscheme("catppuccin-macchiato")

require("plugins.mini")
require("plugins.refer")
require("plugins.coding")
