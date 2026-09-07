require("mini.basics").setup()
require("mini.ai").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.cursorword").setup()

require("mini.files").setup({
    windows = {
        max_number = 4,
        preview = true,
    },
})

local function update_minifiles_windows()
    local state = MiniFiles.get_explorer_state()
    if not state then
        return
    end

    local windows = state.windows
    local n = #windows

    if n == 0 then
        return
    end

    local height = 15
    local row = vim.o.lines - height - 2

    local total_width = vim.o.columns
    local base_width = math.floor(total_width / n)
    local remainder = total_width % n

    local col = 0

    for i, win in ipairs(windows) do
        local width = base_width

        -- Distribute the remaining columns among the first windows.
        if i <= remainder then
            width = width + 1
        end

        local config = vim.api.nvim_win_get_config(win.win_id)

        config.width = width
        config.height = height
        config.row = row
        config.col = col

        vim.api.nvim_win_set_config(win.win_id, config)

        col = col + width
    end
end

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesWindowUpdate",
    callback = update_minifiles_windows,
})

require("which-key").setup({ preset = "helix" })

vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Navigate Files" })
