(module :mods.ui.nvim-tree)

(let [nvim-tree (require :nvim-tree)]
  (nvim-tree.setup
    {:update_cwd true})
  (set vim.g.nvim_tree_respect_buf_cwd 1)
  (set vim.g.nvim_tree_indent_markers 1)
  (set vim.g.nvim_tree_highlight_opened_fiels 1))
