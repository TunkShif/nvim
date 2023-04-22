return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local opts = require("utils.lsp").make_opts({
        cmd = { "jdtls" },
        root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
      })

      require("jdtls").start_or_attach(opts)
    end,
  },
}
