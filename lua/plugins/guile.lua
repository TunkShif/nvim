-- Guile REPL over a unix domain socket, driven by Conjure's guile.socket client.
-- :GuileStart  start (or reuse) a `guile --listen` server for the project and connect Conjure
-- :GuileStop   disconnect Conjure, stop the server and remove the socket

vim.g["conjure#filetype#scheme"] = "conjure.client.guile.socket"

local servers = {} -- root -> { job = id, sock = path }

local function project_root(buf)
    return vim.fs.root(buf, { ".git" }) or vim.fs.dirname(vim.api.nvim_buf_get_name(buf)) or vim.uv.cwd()
end

local function socket_path(root)
    return vim.fs.joinpath(vim.fn.stdpath("run"), "guile-" .. vim.fn.sha256(root):sub(1, 12) .. ".sock")
end

local function exists(path)
    return vim.uv.fs_stat(path) ~= nil
end

local function stop(root)
    local s = servers[root]
    if not s then
        return false
    end
    servers[root] = nil
    vim.fn.jobstop(s.job)
    os.remove(s.sock)
    return true
end

local function start(buf)
    local root = project_root(buf)
    local sock = socket_path(root)
    vim.b[buf]["conjure#client#guile#socket#pipename"] = sock

    local s = servers[root]
    if not (s and vim.fn.jobwait({ s.job }, 0)[1] == -1) then
        servers[root] = nil
        os.remove(sock)
        -- jobstart keeps stdin open as a pipe; `guile --listen` exits on stdin EOF.
        local job = vim.fn.jobstart({ "guile", "--listen=" .. sock }, {
            cwd = root,
            on_exit = function(id, code)
                if servers[root] and servers[root].job == id then
                    servers[root] = nil
                    os.remove(sock)
                    vim.schedule(function()
                        vim.notify(("Guile server exited (%d): %s"):format(code, root), vim.log.levels.WARN)
                    end)
                end
            end,
        })
        if job <= 0 then
            vim.notify("Failed to start guile", vim.log.levels.ERROR)
            return
        end
        servers[root] = { job = job, sock = sock }

        if not vim.wait(5000, function()
            return exists(sock)
        end, 50) then
            stop(root)
            vim.notify("Timed out waiting for guile socket: " .. sock, vim.log.levels.ERROR)
            return
        end
    end

    vim.cmd("ConjureConnect")
end

vim.api.nvim_create_user_command("GuileStart", function()
    start(vim.api.nvim_get_current_buf())
end, { desc = "Start a Guile socket REPL for the project and connect Conjure" })

vim.api.nvim_create_user_command("GuileStop", function()
    local root = project_root(0)
    pcall(vim.cmd, "ConjureGuileDisconnect")
    if not stop(root) then
        vim.notify("No Guile server running for " .. root, vim.log.levels.INFO)
    end
end, { desc = "Disconnect Conjure and stop the project's Guile REPL" })

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        for root in pairs(servers) do
            stop(root)
        end
    end,
})
