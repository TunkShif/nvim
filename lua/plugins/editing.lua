return {
	{
		"ggandor/leap.nvim",
		event = "InsertEnter",
		config = function()
			require("leap").add_default_mappings()
		end,
	},
}
