return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
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
		vim.g.codecompanion_auto_tool_mode = true

		require("codecompanion").setup({
			adapters = {
				openai = function()
					return require("codecompanion.adapters").extend("openai", {
						schema = {
							model = {
								default = "gpt-5",
							},
						},
					})
				end,
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
			},
		})
	end,
}
