-- Project-aware web formatter selection.
-- Nearest config wins (monorepo-friendly); ties: biome > oxfmt > prettier.
-- Fallback: oxfmt + oxlint.
local web_markers = {
    biome = { "biome.json", "biome.jsonc", ".biome.json", ".biome.jsonc" },
    oxfmt = function(name)
        return name:match("^%.oxfmtrc%.jsonc?$") or name == "oxfmt.config.ts"
    end,
    prettier = function(name)
        return name:match("^%.prettierrc") or name:match("^prettier%.config%.")
    end,
    eslint = function(name)
        return name:match("^%.eslintrc") or name:match("^eslint%.config%.")
    end,
    oxlint = function(name)
        return name:match("^%.oxlintrc") or name:match("^oxlint%.config%.")
    end,
}

---@return integer? depth of nearest root containing marker (higher = closer)
local function marker_depth(bufnr, marker)
    local root = vim.fs.root(bufnr, marker)
    return root and #vim.split(root, "/", { plain = true }) or nil
end

local function available(name, bufnr)
    return require("conform").get_formatter_info(name, bufnr).available
end

---@param bufnr integer
---@return string[]
local function web_formatters(bufnr)
    local d = {}
    for tool, marker in pairs(web_markers) do
        d[tool] = marker_depth(bufnr, marker)
    end

    local best, best_d
    for _, tool in ipairs({ "biome", "oxfmt", "prettier" }) do
        if d[tool] and (not best_d or d[tool] > best_d) then
            best, best_d = tool, d[tool]
        end
    end

    if best == "biome" then
        return { "biome-check" } -- format + safe lint fixes + organize imports
    end

    local list
    if best == "prettier" then
        list = { available("prettierd", bufnr) and "prettierd" or "prettier" }
    else
        list = { "oxfmt" }
    end

    if d.eslint and (not d.oxlint or d.eslint >= d.oxlint) then
        if available("eslint_d", bufnr) then
            table.insert(list, 1, "eslint_d") -- lint-fix first, then format
        end
    else
        table.insert(list, "oxlint")
    end
    return list
end

require("conform").setup({
    formatters = {
        schemefmt = {
            command = "schemefmt",
            stdin = true,
        },
    },
    formatters_by_ft = {
        crystal = { "crystal" },

        lua = { "stylua" },

        scheme = { "schemefmt" },

        astro = web_formatters,
        svelte = web_formatters,
        javascript = web_formatters,
        typescript = web_formatters,
        javascriptreact = web_formatters,
        typescriptreact = web_formatters,
    },
    format_on_save = function()
        if vim.g.disable_autoformat then
            return
        end
        return {
            lsp_format = "fallback",
            timeout_ms = 500,
        }
    end,
})

---@param action "enable"|"disable"|"toggle"
local function set_autoformat(action)
    local disabled
    if action == "toggle" then
        disabled = not vim.g.disable_autoformat
    else
        disabled = action == "disable"
    end
    vim.g.disable_autoformat = disabled
    vim.notify("Autoformat " .. (disabled and "disabled" or "enabled"), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("Autoformat", function(args)
    local action = args.args ~= "" and args.args or "toggle"
    if not vim.tbl_contains({ "enable", "disable", "toggle" }, action) then
        return vim.notify("Usage: :Autoformat [enable|disable|toggle]", vim.log.levels.WARN)
    end
    set_autoformat(action)
end, {
    desc = "Toggle autoformat-on-save",
    nargs = "?",
    complete = function()
        return { "enable", "disable", "toggle" }
    end,
})

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { desc = "Format buffer or range", range = true })

vim.keymap.set("n", "<leader>uf", function()
    set_autoformat("toggle")
end, { desc = "Toggle Autoformat" })
