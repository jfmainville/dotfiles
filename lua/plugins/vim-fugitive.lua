return {
	"tpope/vim-fugitive",
	lazy = false,
	keys = {
		{
			mode = "n",
			"<leader>gg",
			"<cmd>horizontal Git<CR>",
			desc = "Open the vim-fugitive git interface",
		},
		{
			mode = "n",
			"<leader>gl",
			"<cmd>horizontal Git log -p -- %<CR>",
			desc = "Open the vim-fugitive git log interface for the current file in the buffer",
		},
		{
			mode = "n",
			"<leader>gL",
			"<cmd>horizontal Git log<CR>",
			desc = "Open the vim-fugitive git log interface for all commits",
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
				vim.cmd("Gitsigns preview_hunk_inline")
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
