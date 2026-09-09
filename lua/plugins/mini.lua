require("mini.basics").setup()
require("mini.icons").setup()
require("mini.surround").setup()
require("mini.cursorword").setup()

require("mini.pairs").setup()

require("mini.files").setup({
    windows = {
        max_number = 3,
        preview = true,
    },
})

local treesitter_spec = require("mini.ai").gen_spec.treesitter
require("nvim-treesitter-textobjects").setup()
require("mini.ai").setup({
    custom_textobjects = {
        f = treesitter_spec({ a = "@function.outer", i = "@function.inner" }, {}),
        c = treesitter_spec({ a = "@class.outer", i = "@class.inner" }, {}),
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
