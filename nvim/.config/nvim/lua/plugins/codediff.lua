return {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	keys = {
		{
			mode = "n",
			"<leader>ds",
			"<cmd>CodeDiff<CR>",
			desc = "Open the merge tool for the current files",
		},
		{
			mode = "n",
			"<leader>da",
			"<cmd>CodeDiff history<CR>",
			desc = "Open the diffview for all the files",
		},
		{
			mode = "n",
			"<leader>df",
			"<cmd>CodeDiff history %<CR>",
			desc = "Open the diffview for the current file",
		},
		{
			mode = "n",
			"<leader>dv",
			"<Esc><Cmd>'<,'>CodeDiff history<CR>",
			desc = "Open the diffview for the current visual lines",
		},
		{
			mode = "v",
			"<leader>dl",
			"<Cmd>.CodeDiff history<CR>",
			desc = "Open the diffview for the current line",
		},
		{
			mode = "n",
			"<leader>dc",
			function()
				require("codediff.ui.lifecycle").close()
			end,
			desc = "Close the diffview tab",
		},
	},
	opts = {
		diff = {
			layout = "side-by-side",
		},
		explorer = {
			view_mode = "tree",
		},
	},
}
