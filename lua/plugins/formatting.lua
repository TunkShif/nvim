require("conform").setup({
    formatters_by_ft = {
        astro = { "prettier" },
        crystal = { "crystal" },
        lua = { "stylua" },
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

vim.api.nvim_create_user_command("Format", function(args)
    local arg = args.args -- string after the command name

    if arg == "enable" then
        vim.g.disable_autoformat = false
        vim.notify("Autoformat enabled", vim.log.levels.INFO)
    elseif arg == "disable" then
        vim.g.disable_autoformat = true
        vim.notify("Autoformat disabled", vim.log.levels.INFO)
    else
        vim.notify("Usage: :Format enable | disable", vim.log.levels.WARN)
    end
end, {
    desc = "Toggle autoformat-on-save",
    bang = false,
    nargs = "?",
    complete = function()
        return { "enable", "disable" }
    end,
})
