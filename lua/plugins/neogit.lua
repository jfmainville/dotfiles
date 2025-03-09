return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
	},
	keys = {
		{
			mode = "n",
			"<leader>gg",
			"<cmd>Neogit<CR>",
			desc = "Open the Neogit interface",
		},
		{
			mode = "n",
			"<leader>gh",
			function()
				vim.cmd("Gitsigns stage_hunk")
				vim.cmd("Gitsigns preview_hunk_inline")
				vim.fn.feedkeys(':!git commit -m "')
			end,
			"",
			desc = "Quick commit the current hunk using vim-fugitive",
		},
		{
			mode = "n",
			"<leader>ga",
			function()
				vim.cmd("!git add %")
				vim.fn.feedkeys(':!git commit -m "')
			end,
			desc = "Quick commit all the hunks in the current file using vim-fugitive",
		},
		{
			mode = "n",
			"<leader>ga",
			function()
				vim.cmd("!git add %")
				vim.fn.feedkeys(':!git commit -m "')
			end,
			desc = "Quick commit all the hunks in the current file using vim-fugitive",
		},
	},
	config = function()
		require("neogit").setup({
			disable_signs = true,
			disable_builtin_notifications = false,
			disable_hint = false,
			graph_style = "unicode",
			integrations = {
				diffview = true,
			},
		})
	end,
}
