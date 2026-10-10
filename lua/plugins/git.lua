-- Git helpers built on top of mini.git / mini.diff

local function relative_time(ts)
    local diff = os.time() - ts
    local units = {
        { 365 * 24 * 3600, "year" },
        { 30 * 24 * 3600, "month" },
        { 7 * 24 * 3600, "week" },
        { 24 * 3600, "day" },
        { 3600, "hour" },
        { 60, "minute" },
    }
    for _, u in ipairs(units) do
        if diff >= u[1] then
            local n = math.floor(diff / u[1])
            return ("%d %s%s ago"):format(n, u[2], n > 1 and "s" or "")
        end
    end
    return "just now"
end

local function parse_porcelain(lines)
    local info = {}
    info.sha = lines[1] and lines[1]:match("^(%x+)")
    for _, l in ipairs(lines) do
        local k, v = l:match("^(%S+) (.*)$")
        if k == "author" then info.author = v
        elseif k == "author-mail" then info.mail = v
        elseif k == "author-time" then info.time = tonumber(v)
        elseif k == "summary" then info.summary = v
        elseif k == "previous" then info.previous = v:match("^(%x+)")
        end
    end
    return info
end

local function show_commit(sha, src_win)
    if src_win and vim.api.nvim_win_is_valid(src_win) then
        vim.api.nvim_set_current_win(src_win)
    end
    vim.cmd("Git show --stat --patch " .. sha)
end

-- Popup with blame info for the current line (works with unsaved edits)
local function blame_line()
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    local path = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(buf))
    if not path then
        return vim.notify("Buffer is not a file on disk", vim.log.levels.WARN)
    end

    local data = MiniGit.get_buf_data(buf)
    local cwd = data and data.root or vim.fs.dirname(path)
    local lnum = vim.api.nvim_win_get_cursor(win)[1]
    local contents = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"

    local cmd = { "git", "blame", "--porcelain", "-L", lnum .. "," .. lnum, "--contents", "-", "--", path }
    vim.system(cmd, { cwd = cwd, stdin = contents, text = true }, function(res)
        vim.schedule(function()
            if res.code ~= 0 then
                return vim.notify(vim.trim(res.stderr), vim.log.levels.WARN)
            end
            local info = parse_porcelain(vim.split(res.stdout, "\n"))
            if not info.sha then return end

            local lines
            if info.sha:match("^0+$") then
                lines = { "Not committed yet" }
            else
                lines = {
                    ("%s  %s %s"):format(info.sha:sub(1, 8), info.author or "?", info.mail or ""),
                    ("%s (%s)"):format(os.date("%Y-%m-%d %H:%M", info.time), relative_time(info.time)),
                    "",
                    info.summary or "",
                    "",
                    "<CR> show commit   <BS> show parent   q close",
                }
            end

            local fbuf, fwin = vim.lsp.util.open_floating_preview(lines, "", {
                border = "rounded",
                focus_id = "git_blame_line",
                title = " Blame ",
            })
            local ns = vim.api.nvim_create_namespace("git_blame_line")
            local function hl(group, row, col_end)
                vim.hl.range(fbuf, ns, group, { row, 0 }, { row, col_end or -1 })
            end
            if #lines > 1 then
                hl("Identifier", 0, 8)
                hl("Comment", 1)
                hl("Title", 3)
                hl("NonText", 5)
            end

            local function map(lhs, fn)
                vim.keymap.set("n", lhs, function()
                    vim.api.nvim_win_close(fwin, true)
                    fn()
                end, { buffer = fbuf, nowait = true })
            end
            if not info.sha:match("^0+$") then
                map("<CR>", function() show_commit(info.sha, win) end)
                if info.previous then
                    map("<BS>", function() show_commit(info.previous, win) end)
                end
            end
        end)
    end)
end

local map = vim.keymap.set
map("n", "<leader>gb", blame_line, { desc = "Blame Line (popup)" })
map({ "n", "x" }, "<leader>gl", "<Cmd>lua MiniGit.show_at_cursor()<CR>", { desc = "Line/Range History" })
map("n", "<leader>go", function() MiniDiff.toggle_overlay(0) end, { desc = "Toggle Diff Overlay" })
map("n", "<leader>gd", "<Cmd>Git diff -- %<CR>", { desc = "Diff File" })
