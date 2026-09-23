local filetypes = { "lisp", "scheme", "clojure", "fennel", "janet", "racket" }

vim.g["conjure#client#scheme#stdio#command"] = "gsi"
vim.g["conjure#client#scheme#stdio#prompt_pattern"] = "> "
vim.g["conjure#client#scheme#stdio#value_prefix_pattern"] = false

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
