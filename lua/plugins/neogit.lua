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
		{
			mode = "n",
			"<leader>gp",
			function()
				vim.cmd("!git push")
			end,
			desc = "Execute the git push command through vim-fugitive",
		},
		{
			mode = "n",
			"<leader>gP",
			function()
				vim.cmd("!git pull --rebase --autostash")
			end,
			desc = "Execute the git push command through vim-fugitive",
		},
	},
	config = function()
		require("neogit").setup({
			disable_signs = false,
			signs = {
				-- { CLOSED, OPENED }
				hunk = { "", "" },
				item = { ">", "v" },
				section = { ">", "v" },
			},

			disable_hint = false,
			integrations = {
				telescope = true,
				diffview = true,
			},
			-- Need to pass this for autorefreshing the buffers after an update
			vim.api.nvim_create_autocmd(
				{ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
				{ pattern = "*", command = "silent! checktime" }
			),
		})
	end,
}
