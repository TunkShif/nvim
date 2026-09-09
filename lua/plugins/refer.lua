local refer = require("refer")

refer.setup({
    min_height = 10,
    extras = {
        find_file = true,
    },
})
refer.setup_ui_select()

local SEVERITIES = { "ERROR", "WARN", "INFO", "HINT" }
local function diagnostics_picker(opts)
    local diagnostics = vim.diagnostic.get(opts)
    if #diagnostics == 0 then
        vim.notify("No diagnostics found", vim.log.levels.INFO)
        return
    end

    local items = {}
    for _, d in ipairs(diagnostics) do
        local bufname = vim.api.nvim_buf_get_name(d.bufnr)
        local relpath = vim.fn.fnamemodify(bufname, ":~:.")
        local severity = d.severity or vim.diagnostic.severity.HINT
        local label = SEVERITIES[severity] or "UNKOWN"

        table.insert(items, {
            text = string.format("%s [%s:%d:%d] %s", label, relpath, d.lnum + 1, d.col + 1, d.message),
            data = { bufnr = d.bufnr, filename = bufname, lnum = d.lnum + 1, col = d.col },
        })
    end

    refer.pick(items, function(_selection, data)
        vim.api.nvim_win_set_buf(0, data.bufnr)
        vim.api.nvim_win_set_cursor(0, { data.lnum, data.col })
    end, {
        prompt = "Diagnostics > ",
        preview = { enabled = true },
        keymaps = {
            ["<CR>"] = "select_entry",
        },
        parser = function(selection)
            local path, l, c = selection:match("%[([^:]+):(%d+):(%d+)%]")
            if path then
                return { filename = path, lnum = tonumber(l), col = tonumber(c) }
            end
            return nil
        end,
    })
end

refer.add_command({ "Diagnostics", "Buffer" }, function()
    diagnostics_picker(0)
end)

refer.add_command({ "Diagnostics", "Workspace" }, function()
    diagnostics_picker()
end)

vim.keymap.set("n", "<leader>fx", "<cmd>Refer Diagnostics Buffer<cr>", { desc = "View Buffer Diagnostics" })
vim.keymap.set("n", "<leader>fX", "<cmd>Refer Diagnostics Workspace<cr>", { desc = "View Workspace Diagnostics" })
vim.keymap.set("n", "<leader>ff", "<cmd>Refer Files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fF", "<cmd>Refer Extras FindFile<cr>", { desc = "View Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Refer Grep<cr>", { desc = "Grep File" })
vim.keymap.set("n", "<leader>fb", "<cmd>Refer Buffers<cr>", { desc = "View Buffers" })
vim.keymap.set("n", "<leader>fd", "<cmd>Refer Definitions<cr>", { desc = "View LSP Definitions" })
vim.keymap.set("n", "<leader>fD", "<cmd>Refer Declarations<cr>", { desc = "View LSP Declarations" })
vim.keymap.set("n", "<leader>fr", "<cmd>Refer References<cr>", { desc = "View LSP References" })
vim.keymap.set("n", "<leader>fI", "<cmd>Refer Implementations<cr>", { desc = "View LSP Implementations" })
vim.keymap.set("n", "<leader>fS", "<cmd>Refer Symbols<cr>", { desc = "View LSP Symbols" })
