---@type vim.lsp.Config
return {
    cmd = { "clear-ls", "lsp" },
    filetypes = { "crystal" },
    root_markers = { "shard.yml", ".git" },
}
