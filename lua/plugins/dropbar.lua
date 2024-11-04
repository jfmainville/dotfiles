return {
	"Bekaboo/dropbar.nvim",
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	lazy = false,
	keys = {
		{
			mode = "n",
			"<leader>pf",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Quickly navigate across functions and files",
		},
	},
	opts = {
		icons = {
			ui = {
				menu = {
					separator = " ",
					indicator = "> ", -- Need to change the indicator to prevent display issues
				},
			},
		},
	},
}
