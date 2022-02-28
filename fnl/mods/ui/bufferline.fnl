(module mods.ui.bufferline)

(let [bufferline (require :bufferline)]
  (bufferline.setup
    {:options {:offsets [{:filetype "NvimTree"
                           :text " File Explorer"
                           :highlight "Directory"
                           :text_align :left}]
               :show_close_icon false}})
  (vim.cmd
    "autocmd FileType alpha set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2"))
