---@type vim.lsp.Config
return {
    cmd = { "clear-ls", "lsp", "--log-file", "/tmp/clear-ls-nvim/clear-ls.log", "--log-level", "debug" },
    filetypes = { "crystal" },
    root_markers = { "shard.yml", ".git" },
}
