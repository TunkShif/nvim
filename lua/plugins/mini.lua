require("mini.basics").setup()
require("mini.icons").setup()
require("mini.comment").setup()
require("mini.surround").setup()
require("mini.cursorword").setup()

require("mini.pairs").setup()

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lisp", "scheme", "clojure" },
    callback = function(args)
        -- Override mini.pairs' global mappings with normal buffer-local input.
        vim.keymap.set("i", "(", "(", { buffer = args.buf })
        vim.keymap.set("i", ")", ")", { buffer = args.buf })
    end,
})

require("mini.files").setup({
    windows = {
        max_number = 3,
        preview = true,
    },
})

require("mini.git").setup()
require("mini.diff").setup({
    view = {
        style = "sign",
        signs = { add = "+", change = "~", delete = "-" },
    },
})

local statusline = require("mini.statusline")
statusline.setup({
    use_icons = true,
    content = {
        active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git = statusline.section_git({ trunc_width = 40 })
            local diff = statusline.section_diff({ trunc_width = 75 })
            local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
            local filename = statusline.section_filename({ trunc_width = 140 })
            local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
            local search = statusline.section_searchcount({ trunc_width = 75 })

            return statusline.combine_groups({
                { hl = mode_hl, strings = { mode } },
                { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
                "%<",
                { hl = "MiniStatuslineFilename", strings = { filename } },
                "%=",
                { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
                { hl = mode_hl, strings = { search, "%l:%c" } },
            })
        end,
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

    -- Window width excludes its border. Reserve two columns for every
    -- bordered window so the complete layout still fits inside the editor.
    local border_width = 2
    local content_width = vim.o.columns - border_width * n
    local base_width = math.floor(content_width / n)
    local remainder = content_width % n

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

        -- mini.files initially sizes unfocused windows using `width_nofocus`.
        -- That narrow width can horizontally scroll their content. Resizing
        -- the window does not reset this view state, so restore the left edge.
        vim.api.nvim_win_call(win.win_id, function()
            local view = vim.fn.winsaveview()
            view.leftcol = 0
            vim.fn.winrestview(view)
        end)

        col = col + width + border_width
    end
end

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesWindowUpdate",
    callback = update_minifiles_windows,
})

require("which-key").setup({ preset = "helix" })

vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Navigate Files" })
vim.keymap.set("n", "<leader>E", function()
    local path = vim.api.nvim_buf_get_name(0)

    if path == "" or vim.fn.filereadable(path) == 0 then
        vim.notify("Current buffer is not a file", vim.log.levels.INFO)
        return
    end

    MiniFiles.open(path)
end, { desc = "Navigate Current File" })
