vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = false

vim.o.incsearch = true

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99 -- keep all folds open by default when opening a file
vim.opt.foldlevelstart = 99

vim.o.laststatus = 2 -- always show status line
vim.o.statusline = "%m %f %=%l:%c %y"
vim.o.winborder = "single"

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
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

    "https://github.com/saghen/blink.lib",
    "https://github.com/Saghen/blink.cmp",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
})

vim.cmd.colorscheme("catppuccin-macchiato")

require("plugins.mini")
require("plugins.refer")
require("plugins.coding")
require("plugins.formatting")
