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
			"<leader>gL",
			"<cmd>Git log --graph --abbrev-commit --decorate --format=format:'%h - %ai (%ar) - %an - %s' --all<CR>",
			desc = "Open the Git log of all branches in a new split",
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
				local branch_name = vim.fn.input("Source Branch Name: ")
				if branch_name == "" then
					return
				end
				local success_branch_name = vim.cmd("Git log --oneline --format=format:'- %s' " .. branch_name .. "..")
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
			"<leader>gh",
			function()
				vim.cmd("Gitsigns stage_hunk")
				vim.cmd("Gitsigns preview_hunk_inline")

				vim.defer_fn(function()
					local commit_message = vim.fn.input("Commit Message: ")
					if commit_message == "" then
						return
					end
					local success_commit_message = vim.cmd('Git commit -m "' .. commit_message .. '"')
					if not success_commit_message then
						return
					end
				end, 100)
			end,
			"",
			desc = "Quick commit the current hunk using vim-fugitive",
		},
		{
			mode = "n",
			"<leader>ga",
			function()
				vim.cmd("Git add %")

				vim.defer_fn(function()
					local commit_message = vim.fn.input("Commit Message: ")
					if commit_message == "" then
						return
					end
					local success_commit_message = vim.cmd('Git commit -m "' .. commit_message .. '"')
					if not success_commit_message then
						return
					end
				end, 100)
			end,
			desc = "Quick commit all the hunks in the current file using vim-fugitive",
		},
		{
			mode = "n",
			"<leader>gb",
			function()
				local checkout_branch = vim.fn.input("Source Branch Name: ")
				if checkout_branch == "" then
					return
				end
				local success_checkout_branch = vim.cmd("Git checkout " .. checkout_branch)
				if not success_checkout_branch then
					return
				end
				vim.cmd("Git pull --rebase --autostash")

				local new_branch = vim.fn.input("New Branch Name: ")
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
		-- Auto-generate a one-line commit message using the GitHub Copilot API
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "gitcommit",
			callback = function(ev)
				local buf = ev.buf

				-- Only trigger for new commits (first line must be empty)
				local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
				if first_line ~= "" then
					return
				end

				-- Get the staged diff; abort if nothing is staged
				local diff = vim.fn.system("git diff --cached")
				if vim.v.shell_error ~= 0 or vim.trim(diff) == "" then
					return
				end

				-- Truncate diff to avoid exceeding token limits
				if #diff > 8000 then
					diff = diff:sub(1, 8000) .. "\n... (truncated)"
				end

				local function generate(github_token)
					local base_url = (github_token.endpoints and github_token.endpoints.api)
						or "https://api.githubcopilot.com"
					local curl = require("plenary.curl")

					curl.post(base_url .. "/chat/completions", {
						headers = {
							["Authorization"] = "Bearer " .. github_token.token,
							["Content-Type"] = "application/json",
							["User-Agent"] = "GitHubCopilotChat/0.26.7",
							["Copilot-Integration-Id"] = "vscode-chat",
						},
						body = vim.json.encode({
							model = "gpt-4o",
							messages = {
								{
									role = "system",
									content = "You generate concise git commit messages following the Conventional Commits specification. Respond with a single-line commit message only. Add a scope as necessary. No explanations, no markdown, no quotes.",
								},
								{
									role = "user",
									content = "Generate a conventional commit message for the following staged changes:\n\n"
										.. diff,
								},
							},
							max_tokens = 100,
							temperature = 0.2,
							stream = false,
						}),
						callback = vim.schedule_wrap(function(response)
							if not vim.api.nvim_buf_is_valid(buf) then
								return
							end

							if response.status ~= 200 then
								vim.notify(
									"avante: failed to generate commit message (HTTP "
										.. tostring(response.status)
										.. ")",
									vim.log.levels.WARN
								)
								return
							end

							local ok, body = pcall(vim.json.decode, response.body)
							if not ok or not body.choices or not body.choices[1] then
								return
							end

							local message = vim.trim(body.choices[1].message.content or "")
							-- Strip surrounding quotes when the model wraps the message in them
							message = message:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")

							if message ~= "" then
								-- Insert only when the user has not started typing yet
								local current = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
								if current == "" then
									vim.api.nvim_buf_set_lines(buf, 0, 1, false, { message })
									local win = vim.fn.bufwinid(buf)
									if win ~= -1 then
										vim.api.nvim_win_set_cursor(win, { 1, #message })
									end
								end
							end
						end),
					})
				end

				-- Load avante's copilot provider and ensure it is initialised
				local ok, copilot = pcall(require, "avante.providers.copilot")
				if not ok then
					vim.notify("avante.nvim: copilot provider not available", vim.log.levels.WARN)
					return
				end

				if not copilot._is_setup then
					copilot.setup()
				end

				-- If the token is ready, generate immediately; otherwise retry once after a
				-- short delay to allow the async token refresh triggered by setup() to complete
				if copilot.state and copilot.state.github_token then
					generate(copilot.state.github_token)
				else
					vim.defer_fn(function()
						if copilot.state and copilot.state.github_token then
							generate(copilot.state.github_token)
						else
							vim.notify(
								"avante: copilot token not available, commit message not generated",
								vim.log.levels.WARN
							)
						end
					end, 1500)
				end
			end,
			desc = "Auto-generate commit messages using the GitHub Copilot API",
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
	end,
}
