local function default_branch_ref()
	local ref = vim.fn.systemlist("git symbolic-ref --short refs/remotes/origin/HEAD")[1]
	if vim.v.shell_error ~= 0 or not ref or ref == "" then
		for _, candidate in ipairs({ "origin/main", "origin/master" }) do
			vim.fn.system("git rev-parse --verify --quiet " .. candidate)
			if vim.v.shell_error == 0 then
				return candidate
			end
		end
		vim.notify("Unable to determine the default branch", vim.log.levels.ERROR)
		return nil
	end
	return ref
end

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
				local ref = default_branch_ref()
				if ref then
					vim.cmd("CodeDiff " .. ref .. "...HEAD")
				end
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
			"<leader>dh",
			function()
				local ref = default_branch_ref()
				if ref then
					vim.cmd("CodeDiff history " .. ref .. "..HEAD")
				end
			end,
			desc = "Open the commit log with diffs of the current branch against the default branch",
		},
	},
	opts = {
		diff = {
			layout = "inline",
		},
		history = {
			position = "bottom",
			date_format = "%Y-%m-%d %H:%M",
		},
		explorer = {
			position = "bottom",
			view_mode = "tree",
			focus_on_select = true,
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
