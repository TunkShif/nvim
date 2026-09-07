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
