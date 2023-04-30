return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      servers = require("plugins.lsp.servers"),
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local servers = opts.servers

      for server, server_opts in pairs(servers) do
        lspconfig[server].setup(require("utils.lsp").make_opts(server_opts))
      end

      vim.diagnostic.config({ float = { border = "single" } })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(event)
          local wk = require("which-key")
          local buffer = event.buf

          wk.register({
            gD = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto declaration" },
            gd = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition" },
            gi = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto implementation" },
            gr = { "<cmd>lua vim.lsp.buf.references()<cr>", "Goto references" },
            gl = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Show diagnostics" },
            K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover documentation" },
            ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous diagnostics" },
            ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next diagnostics" },
          }, {
            buffer = buffer,
          })

          wk.register({
            c = {
              name = "code",
              r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol" },
              a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code action" },
              f = { "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "Format document" },
              k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" },
              d = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Diagnostics" },
              D = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type definition" },
            },
          }, {
            prefix = "<leader>",
            buffer = buffer,
          })

          -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          -- vim.keymap.set('n', '<space>wl', function()
          --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          -- end, opts)
        end,
      })
    end,
  },
  { import = "plugins.lsp.server.null_ls" },
  { import = "plugins.lsp.lang.typescript" },
  { import = "plugins.lsp.lang.rust" },
}
