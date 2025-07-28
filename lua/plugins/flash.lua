return {
	"folke/flash.nvim",
	event = "VeryLazy",
	keys = {
		{
			mode = { "n", "x", "o" },
			"s",
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			mode = { "n", "x", "o" },
			"S",
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			mode = "o",
			"r",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			mode = { "o", "x" },
			"R",
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
	},
	opts = {
		modes = {
			search = {
				enabled = false,
			},
			char = {
				enabled = true,
				multi_line = false,
			},
		},
	},
}
