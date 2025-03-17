return {
	"tpope/vim-fugitive",
	dependencies = {
		"tpope/vim-rhubarb", -- GitHub Git browser
		"cedarbaum/fugitive-azure-devops.vim", -- Azure DevOps Git browser
	},
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
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "fugitiveblame", "fugitive" },
			callback = function()
				vim.api.nvim_buf_set_keymap(0, "n", "<Tab>", "=", { silent = true })
			end,
		})
	end,
}
