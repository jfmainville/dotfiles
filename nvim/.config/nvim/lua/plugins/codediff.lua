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
			"<leader>db",
			function()
				local ref = vim.fn.systemlist("git symbolic-ref --short refs/remotes/origin/HEAD")[1]
				if vim.v.shell_error ~= 0 or not ref or ref == "" then
					for _, candidate in ipairs({ "origin/main", "origin/master" }) do
						vim.fn.system("git rev-parse --verify --quiet " .. candidate)
						if vim.v.shell_error == 0 then
							ref = candidate
							break
						end
					end
				end
				if not ref or ref == "" then
					vim.notify("Unable to determine the default branch", vim.log.levels.ERROR)
					return
				end
				vim.cmd("CodeDiff " .. ref .. "...HEAD")
			end,
			desc = "Open the diffview of the current branch against the default branch",
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
			position = "bottom",
			view_mode = "tree",
			auto_open_on_cursor = true,
			line_stats = {
				enabled = true,
			},
		},
		keymaps = {
			view = {
				focus_explorer = "<leader>o",
				next_hunk = "h",
				prev_hunk = "H",
				next_file = "f",
				prev_file = "F",
			},
		},
	},
}
