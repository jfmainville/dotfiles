return {
	"sindrets/diffview.nvim",
	lazy = false,
	keys = {
		{
			mode = "n",
			"<leader>da",
			"<cmd>DiffviewFileHistory<CR>",
			desc = "Open the diffview for all the files",
		},
		{
			mode = "n",
			"<leader>df",
			"<cmd>DiffviewFileHistory --follow %<CR>",
			desc = "Open the diffview for the current file",
		},
		{
			mode = "n",
			"<leader>dv",
			"<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>",
			desc = "Open the diffview for the current file",
		},
		{
			mode = "v",
			"<leader>dl",
			"<Cmd>.DiffviewFileHistory --follow<CR>",
			desc = "Open the diffview for the current file",
		},
		{
			mode = "n",
			"<leader>dc",
			"<cmd>DiffviewClose<CR>",
			desc = "Close the diffview tab",
		},
	},
	opts = {
		show_help_hints = false,
	},
}
