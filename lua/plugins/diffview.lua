return {
	"sindrets/diffview.nvim",
	lazy = false,
	keys = {
		{
			mode = "n",
			"<leader>df",
			"<cmd>DiffviewFileHistory %<CR>",
			desc = "Open the diffview for the current file",
		},
		{
			mode = "n",
			"<leader>dc",
			"<cmd>DiffviewClose<CR>",
			desc = "Close the diffview tab",
		},
	},
}
