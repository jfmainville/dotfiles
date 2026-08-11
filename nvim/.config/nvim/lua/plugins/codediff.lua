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
			mode = "v",
			"<leader>dl",
			"<Esc><Cmd>'<,'>CodeDiff history %<CR>",
			desc = "Open the git history for the currently selected visual lines",
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
			layout = "inline",
		},
		explorer = {
			view_mode = "list",
		},
		keymaps = {
			view = {
				focus_explorer = "<leader>o",
			},
		},
	},
}
