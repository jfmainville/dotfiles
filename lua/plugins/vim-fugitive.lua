return {
	"tpope/vim-fugitive",
	lazy = false,
	keys = {
		{
			mode = "n",
			"<leader>gg",
			"<cmd>tab Git<CR>",
			desc = "Open the vim-fugitive git interface",
		},
		{
			mode = "n",
			"<leader>gl",
			"<cmd>vertical Git log -p -- %<CR>",
			desc = "Open the vim-fugitive git log interface for the current file in the buffer",
		},
		{
			mode = "n",
			"<leader>gL",
			"<cmd>tab Git log --graph<CR>",
			desc = "Open the vim-fugitive git log interface for the current file in the buffer",
		},
		{
			mode = "n",
			"<leader>gp",
			"<cmd>Git push<CR>",
			desc = "Execute the git push command through vim-fugitive",
		},
		{
			mode = "n",
			"<leader>gP",
			"<cmd>Git pull --rebase --autostash<CR>",
			desc = "Execute the git push command through vim-fugitive",
		},
		{
			mode = "n",
			"<leader>gh",
			function()
				vim.cmd("Gitsigns stage_hunk")
				vim.fn.feedkeys(':Git commit -m "')
			end,
			"",
			desc = "Quick commit the current hunk using vim-fugitive",
		},
		{
			mode = "n",
			"<leader>ga",
			function()
				vim.cmd("Git add %")
				vim.fn.feedkeys(':Git commit -m "')
			end,
			desc = "Quick commit all the hunks in the current file using vim-fugitive",
		},
	},
}
