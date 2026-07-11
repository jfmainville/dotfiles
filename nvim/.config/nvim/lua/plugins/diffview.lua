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
				local current_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
				local merge_base = vim.fn.system("git merge-base main " .. current_branch):gsub("\n", "")
				if merge_base == "" then
									vim.ui.input({ prompt = "Enter source branch: " }, function(input)
										if not input or input == "" then
											vim.notify("No source branch provided", vim.log.levels.ERROR)
											return
										end
										merge_base = vim.fn.system("git merge-base " .. input .. " " .. current_branch):gsub("\n", "")
										if merge_base == "" then
											vim.notify("Could not find merge base with branch: " .. input, vim.log.levels.ERROR)
											return
										end
										vim.cmd("DiffviewOpen " .. merge_base .. "..HEAD")
									end)
									return
				end
				vim.cmd("DiffviewOpen " .. merge_base .. "..HEAD")
			end,
			desc = "Open the diffview for the current branch",
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
