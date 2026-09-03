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

require("mini.basics").setup()
require("mini.ai").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.cursorword").setup()

require("which-key").setup({
    preset = "helix",
})

require("refer").setup({
    extras = {
        find_file = true,
    },
})
require("refer").setup_ui_select()

vim.keymap.set("n", "<leader>ff", "<cmd>Refer Files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fF", "<cmd>Refer Extras FindFile<cr>", { desc = "View Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Refer Grep<cr>", { desc = "Grep File" })
vim.keymap.set("n", "<leader>fb", "<cmd>Refer Buffers<cr>", { desc = "View Buffers" })
vim.keymap.set("n", "<leader>fd", "<cmd>Refer Definitions<cr>", { desc = "View LSP Definitions" })
vim.keymap.set("n", "<leader>fD", "<cmd>Refer Declarations<cr>", { desc = "View LSP Declarations" })
vim.keymap.set("n", "<leader>fr", "<cmd>Refer References<cr>", { desc = "View LSP References" })
vim.keymap.set("n", "<leader>fI", "<cmd>Refer Implementations<cr>", { desc = "View LSP Implementations" })
vim.keymap.set("n", "<leader>fS", "<cmd>Refer Symbols<cr>", { desc = "View LSP Symbols" })

require("blink.cmp").build():pwait()
require("blink.cmp").setup({
    keymap = {
        preset = "super-tab",
    },
})

require("mason").setup()

vim.lsp.config("lua_ls", {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
                    vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                },
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = vim.api.nvim_get_runtime_file('', true),
            },
        })
    end,
    settings = {
        Lua = {},
    },
})
vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")
vim.lsp.enable("vtsls")

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
    },
    format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
    },
})
