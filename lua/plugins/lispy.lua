local filetypes = { "lisp", "scheme", "clojure", "fennel", "janet", "racket" }

require("plugins.guile")

vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/Olical/conjure" })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(args)
        -- Override mini.pairs' global mappings with normal buffer-local input.
        -- vim.keymap.set("i", "(", "(", { buffer = args.buf })
        vim.keymap.set("i", ")", ")", { buffer = args.buf })
    end,
})
