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
			":tab Git log --graph<CR>",
			desc = "Open the vim-fugitive git log interface for the current file in the buffer",
		},
		{
			mode = "n",
			"<leader>gp",
			"<cmd>Git push<CR>",
			desc = "Execute the git push command through vim-fugitive",
		},
		{ mode = "n", "<leader>gh", ':Git commit -m "', desc = "Quick commit using vim-fugitive" },
		{ mode = "n", "<leader>ga", ':Git commit -am "', desc = "Quick commit all using vim-fugitive" },
	},
}
