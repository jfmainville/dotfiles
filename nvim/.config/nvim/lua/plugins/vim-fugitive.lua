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
			"<leader>gn",
			"<cmd>GBrowse<CR>",
			desc = "Open the current repository in the browser",
		},
		{
			mode = "n",
			"<leader>gc",
			function()
				local branch_name = vim.fn.input("Branch: ")
				if branch_name == "" then
					return
				end
				local success_branch_name = vim.cmd("Git checkout " .. branch_name)
				vim.cmd("Git pull --rebase --autostash")
				if not success_branch_name then
					return
				end
			end,
			desc = "Checkout a specific branch through vim-fugitive",
		},
		{
			mode = "n",
			"<leader>gl",
			function()
				local branch_name = vim.fn.input("Source Branch: ")
				if branch_name == "" then
					return
				end
				local success_branch_name = vim.cmd("Git log --oneline " .. branch_name .. "..")
				if not success_branch_name then
					return
				end
			end,
			desc = "Show the list of commits on a specific branch through vim-fugitive",
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
			"<leader>gu",
			"<cmd>Git reset HEAD~<CR>",
			desc = "Undo the latest commit through vim-fugitive",
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
		-- Trigger CodeCompanion prompt when opening Fugitive commit buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "gitcommit",
			callback = function()
				require("codecompanion").prompt("generate_commit_message")
			end,
			desc = "Trigger CodeCompanion commit prompt when opening Fugitive commit buffer",
		})
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
		vim.api.nvim_create_autocmd("User", {
			pattern = "GitCommitPost",
			callback = function(args)
				for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
					-- Only reload if the file has changed outside nvim
					if vim.fn.getbufvar(buf.bufnr, "&mod") == 0 and vim.fn.getftime(buf.name) > 0 then
						-- This opens the file in the buffer again, updating its contents
						vim.api.nvim_buf_call(buf.bufnr, function()
							vim.cmd("checktime")
						end)
					end
				end
			end,
			desc = "Refresh Gitsigns after a commit",
		})
	end,
}
