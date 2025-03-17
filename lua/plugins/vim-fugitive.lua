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

				local commit_message = vim.fn.input("Commit Message: ")
				if commit_message == "" then
					return
				end
				local success_commit_message = vim.cmd('Git commit -m "' .. commit_message .. '"')
				if not success_commit_message then
					return
				end
			end,
			"",
			desc = "Quick commit the current hunk using vim-fugitive",
		},
		{
			mode = "n",
			"<leader>ga",
			function()
				vim.cmd("Git add %")
				local commit_message = vim.fn.input("Commit Message: ")
				if commit_message == "" then
					return
				end
				local success_commit_message = vim.cmd('Git commit -m "' .. commit_message .. '"')
				if not success_commit_message then
					return
				end
			end,
			desc = "Quick commit all the hunks in the current file using vim-fugitive",
		},
		{
			mode = "n",
			"<leader>gb",
			function()
				local checkout_branch = vim.fn.input("Source Branch: ")
				if checkout_branch == "" then
					return
				end
				local success_checkout_branch = vim.cmd("Git checkout " .. checkout_branch)
				if not success_checkout_branch then
					return
				end
				vim.cmd("Git pull --rebase --autostash")

				local new_branch = vim.fn.input("New Branch: ")
				if new_branch == "" then
					return
				end
				local success_new_branch = vim.cmd("Git switch -c " .. new_branch)
				if not success_new_branch then
					return
				end
			end,
			desc = "Checkout a new branch, pull updates, and switch to a new branch",
		},
	},
	config = function()
		-- Customize the vim-fugitive keymaps
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "fugitiveblame", "fugitive" },
			callback = function()
				vim.api.nvim_buf_set_keymap(0, "n", "<Tab>", "=", { silent = true })
				vim.api.nvim_buf_set_keymap(0, "n", "c<space>", "", {
					noremap = true,
					silent = true,
					callback = function()
						local commit_message = vim.fn.input("Commit Message: ")
						if commit_message == "" then
							return
						end
						vim.cmd('Git commit -m "' .. commit_message .. '"')
					end,
				})
			end,
		})
	end,
}
