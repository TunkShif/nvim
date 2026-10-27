-- Go template comment: stripped from the rendered manifest. Always use it, even
-- on lines tree-sitter sees as injected yaml: a `#` comment does not stop
-- `{{ include ... }}` and other actions from rendering.
vim.bo.commentstring = "{{/* %s */}}"
vim.b.minicomment_config = {
    options = {
        custom_commentstring = function()
            return vim.bo.commentstring
        end,
    },
}
