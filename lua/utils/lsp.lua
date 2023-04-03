local M = {}

function M.make_opts(opts)
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
  }

  return vim.tbl_deep_extend("force", {
    handlers = vim.deepcopy(handlers),
    capabilities = vim.deepcopy(capabilities),
  }, opts or {})
end

return M
