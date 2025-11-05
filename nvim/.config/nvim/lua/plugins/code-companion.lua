return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	version = "v17.29.0", // Temporarily lock the version until the @insert_edit_into_file tool issue is fixed
	lazy = false,
	keys = {
		{
			"<leader>cn",
			function()
				require("codecompanion").chat()
			end,
			mode = "n",
			desc = "CodeCompanion: New Chat Window",
		},
		{
			"<leader>ct",
			"<cmd>CodeCompanionChat Toggle<CR>",
			mode = "n",
			desc = "CodeCompanion: Toggle Latest Chat Window",
		},
		{
			"<leader>ci",
			"<cmd>CodeCompanion<CR>",
			mode = { "n", "v" },
			desc = "CodeCompanion: Inline Code Companion",
		},
	},
	config = function()
		-- Disable the user approval prompts
		vim.g.codecompanion_yolo_mode = true

		require("codecompanion").setup({
			adapters = {
				http = {
					openai = function()
						return require("codecompanion.adapters").extend("openai", {
							schema = {
								model = {
									default = "gpt-4.1",
								},
							},
						})
					end,
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									default = "gpt-5",
								},
							},
						})
					end,
					opts = {
						show_defaults = false,
						show_model_choices = true,
					},
				},
			},
			display = {
				diff = {
					enabled = false,
					close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
					layout = "vertical", -- vertical|horizontal split for default provider
					opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
					provider = "mini_diff", -- default|mini_diff
				},
				chat = {
					start_in_insert_mode = false,
				},
			},
			strategies = {
				chat = {
					adapter = "openai",
					tools = {
						["cmd_runner"] = {
							opts = {
								requires_approval = false,
							},
						},
						opts = {
							auto_submit_errors = true,
							auto_submit_success = true,
							default_tools = {
								"full_stack_dev",
								"files",
							},
						},
					},
				},
				inline = {
					adapter = "openai",
					keymaps = {
						accept_change = {
							modes = { n = "ga", v = "ga" },
							description = "Accept the suggested change",
						},
						reject_change = {
							modes = { n = "gr", v = "gr" },
							description = "Reject the suggested change",
						},
					},
				},
				cmd = {
					adapter = "openai",
				},
			},
			prompt_library = {
				["Generate a Commit Message"] = {
					strategy = "inline",
					description = "Generate a commit message",
					opts = {
						index = 9,
						is_default = true,
						is_slash_cmd = false,
						short_name = "commit",
						auto_submit = true,
						placement = "before",
					},
					prompts = {
						{
							role = "user",
							contains_code = true,
							content = function()
								return [[You are an expert at following the Conventional Commit specification based on the following diff:]]
									.. vim.fn.system("git diff --cached")
									.. [[ Generate a commit message for me on a single line. Follow the standard conventional commit structure: (fix | refactor | feat | chore | docs)({scope}): {summary of the changes} Return the code only and no markdown codeblocks.
                    ]]
							end,
						},
					},
				},
				{
					strategy = "chat",
					description = "Create or update a Pull Request (PR)",
					opts = {
						index = 10,
						is_default = true,
						is_slash_cmd = true,
						short_name = "pr",
						auto_submit = true,
						placement = "chat",
					},
					prompts = {
						{
							role = "user",
							contains_code = true,
							content = function()
								return [[You are an expert at creating Pull Requests based on the following diff:]]
									.. vim.fn.system(
										"git log origin/$(git remote show origin | awk '/HEAD branch/ {print $NF}')..HEAD --oneline"
									)
									.. [[ Create or update a Pull Request (PR) description for me using markdown. I want a Change section (Heading 2) and an Additional Notes section (Heading 2). In the Changes section list out the changes made in the PR as bullet points exclusively, no code snippets. I want you to use the conventional commit structure, exclude the commit SHA and wrap functions, version numbers and other symbols in an inline code block. In the Additional Notes section, list out any additional notes about the PR as a bullet list. If there's a PR already created for this branch, update the Changes section bullet list with the new changes. Use the proper CLI tool that's already installed on the workstation to perform the PR related operations. You can perform the required operations immediately and without approval. Delete temporary markdown files once all the operations are done. ]]
							end,
						},
					},
				},
			},
		})
	end,
}
