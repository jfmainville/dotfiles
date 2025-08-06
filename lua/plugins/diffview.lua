return {
	"sindrets/diffview.nvim",
	lazy = false,
	keys = {
		{
			mode = "n",
			"<leader>ds",
			"<cmd>DiffviewOpen<CR>",
			desc = "Open the merge tool for the current files",
		},
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
			desc = "Open the diffview for the current visual lines",
		},
		{
			mode = "v",
			"<leader>dl",
			"<Cmd>.DiffviewFileHistory --follow<CR>",
			desc = "Open the diffview for the current line",
		},
		{
			mode = "n",
			"<leader>db",
			function()
				local source_branch = vim.fn.input("Source Branch: ")
				if source_branch == "" then
					return
				end
				vim.cmd("DiffviewOpen " .. source_branch .. "..")
			end,
			desc = "Open the diffview for the repository",
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
