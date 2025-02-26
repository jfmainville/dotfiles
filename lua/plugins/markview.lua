return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	keys = {
		{
			mode = "n",
			"<leader>tm",
			"<cmd>Markview Toggle<CR>",
			desc = "Toggle the Markview markdown preview mode",
		},
	},
	config = function()
		local presets = require("markview.presets")

		require("markview").setup({
			markdown = {
				headings = presets.headings.marker,
			},
		})
	end,
}
