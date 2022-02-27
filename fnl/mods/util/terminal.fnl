(module mods.util.terminal)

(let [fterm (require :FTerm)]
  (fterm.setup
    {:border :double
     :dimensions {:height 0.9
                  :width 0.9}})
  (let [map vim.api.nvim_set_keymap]
    (map :t :<Esc> "<C-\\><C-n>" {:noremap true :silent true})
    (map :n :<A-t> "<cmd>lua require('FTerm').toggle()<cr>" {:noremap true :silent true})
    (map :t :<A-t> "<C-\\><C-n><cmd>lua require('FTerm').toggle()<cr>" {:noremap true :silent true})))
