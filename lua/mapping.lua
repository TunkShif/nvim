local wk = require("which-key")

wk.register({
	f = { name = "find" },
	w = {
		name = "window",
		h = { "<C-w>h", "Go to left window" },
		j = { "<C-w>j", "Go to down window" },
		k = { "<C-w>k", "Go to up window" },
		l = { "<C-w>l", "Go to right window" },
		H = { "<C-w>H", "Move window left" },
		J = { "<C-w>J", "Move window down" },
		K = { "<C-w>K", "Move window up" },
		L = { "<C-w>L", "Move window right" },
		s = { "<C-w>s", "Split window horizontally" },
		v = { "<C-w>v", "Split window vertically" },
		x = { "<C-w>x", "Swap current window with next" },
		q = { "<C-w>q", "Quit current window" },
		w = { "<C-w>w", "Switch windows" },
	},
	["<esc>"] = { "<cmd>silent! nohls<cr>", "Clear search highlight" },
}, {
	prefix = "<leader>",
})

wk.register({
	["<localleader>"] = { '"+', "Using system clipboard register" },
}, { prefix = "<localleader>" })

wk.register({
	["<localleader>"] = { '"+', "Using system clipboard register" },
}, {
	prefix = "<localleader>",
	mode = "v",
})
