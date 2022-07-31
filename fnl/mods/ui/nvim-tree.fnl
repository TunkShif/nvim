(module :mods.ui.nvim-tree)

(let [nvim-tree (require :nvim-tree)]
  (nvim-tree.setup
    {:update_cwd false})
  (set vim.g.nvim_tree_respect_buf_cwd 1)
  (set vim.g.nvim_tree_indent_markers 1)
  (set vim.g.nvim_tree_highlight_opened_files 1)
  (set vim.g.nvim_tree_icons
       {:default ""
        :symlink ""
        :git {:unstaged  ""
              :staged    ""
              :unmerged  ""
              :renamed   ""
              :untracked ""
              :deleted   ""
              :ignored   ""}
        :folder {:arrow_open   ""
                 :arrow_closed ""
                 :default      ""
                 :open         ""
                 :empty        ""
                 :empty_open   ""
                 :symlink      ""
                 :symlink_open ""}
        :lsp {:hint    ""
              :info    ""
              :warning ""
              :error   ""}}))
