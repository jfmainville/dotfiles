return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {},
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
		{
			mode = { "c" },
			"<c-s>",
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
}
