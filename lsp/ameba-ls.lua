---@type vim.lsp.Config
return {
    cmd = { "ameba-ls" },
    filetypes = { "crystal" },
    root_markers = { "shard.yml", ".git" },
}
