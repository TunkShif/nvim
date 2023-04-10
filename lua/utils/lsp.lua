local M = {}

function M.make_opts(opts)
  local options = opts or {}
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single", max_width = 80 }),
    ["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      { border = "single", max_width = 80 }
    ),
  }

  local on_attach = options.on_attach

  options.on_attach = function(client, bufnr)
    -- disable semantic highlight provided by lsp server
    -- cuz it doesn't work well with tree-sitter
    client.server_capabilities.semanticTokensProvider = nil

    if on_attach ~= nil then
      on_attach(client, bufnr)
    end
  end

  return vim.tbl_deep_extend("force", {
    handlers = vim.deepcopy(handlers),
    capabilities = vim.deepcopy(capabilities),
  }, options)
end

return M
