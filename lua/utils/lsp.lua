local M = {}

function M.make_opts(opts)
  local options = opts or {}
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
  }

  local on_attach = function(client, bufnr)
    -- disable semantic highlight provided by lsp server
    -- cuz it doesn't work well with tree-sitter
    client.server_capabilities.semanticTokensProvider = nil

    if options.on_attach ~= nil then
      options.on_attach(client, bufnr)
    end
  end

  options.on_attach = nil

  return vim.tbl_deep_extend("force", {
    handlers = vim.deepcopy(handlers),
    capabilities = vim.deepcopy(capabilities),
    on_attach = on_attach,
  }, options)
end

return M
