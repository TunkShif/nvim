local list = require("utils.list")

-- general settings
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.number = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.hidden = true
vim.o.wrap = false
vim.o.mouse = "a"
vim.o.encoding = "utf-8"
vim.o.wildmenu = true
vim.o.smartcase = true
vim.o.relativenumber = true
vim.o.foldenable = false

-- vim.cmd [[autocmd InsertEnter * :set norelativenumber]]
-- vim.cmd [[autocmd InsertLeave * :set relativenumber]]

-- switch off relative number in insert mode
local BLACKLISTED_FILETYPES = { "neo-tree", "neo-tree-popup" }

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		local filetype = vim.bo.filetype
		if list.contains(BLACKLISTED_FILETYPES, filetype) then
			return
		end
		vim.o.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		local filetype = vim.bo.filetype
		if list.contains(BLACKLISTED_FILETYPES, filetype) then
			return
		end
		vim.o.relativenumber = true
	end,
})
