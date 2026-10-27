-- Crystal indent, ported from vim-crystal (see lua/crystal/indent.lua).
if vim.b.did_indent then
    return
end
vim.b.did_indent = true

vim.bo.smartindent = false
vim.bo.indentexpr = "v:lua.require'crystal.indent'.get()"
vim.bo.indentkeys = "0{,0},0),0],!^F,o,O,e,.,=end,=else,=elsif,=when,=in,=ensure,=rescue"

vim.b.undo_indent = "setlocal smartindent< indentexpr< indentkeys<"
