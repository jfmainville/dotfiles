return {
	"olimorris/codecompanion.nvim",
	opts = {},
	keys = {
		{
			"<leader>cc",
			function()
				require("codecompanion").prompt("commit")
			end,
			mode = "n",
			desc = "CodeCompanion: Generate Commit Message",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			display = {
				diff = {
					enabled = true,
					close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
					layout = "vertical", -- vertical|horizontal split for default provider
					opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
					provider = "mini_diff", -- default|mini_diff
				},
			},
			prompt_library = {
				["Generate a Commit Message"] = {
					strategy = "inline",
					description = "Generate a commit message",
					opts = {
						index = 9,
						is_default = true,
						is_slash_cmd = true,
						short_name = "commit",
						auto_submit = true,
						placement = "before",
					},
					prompts = {
						{
							role = "user",
							contains_code = true,
							content = function()
								return [[You are an expert at following the Conventional Commit specification                       based on the following diff:
]] .. vim.fn.system("git diff --cached") .. [[

Generate a commit message for me. Follow the below structure:

   (fix | refactor | feat | chore | docs) {Summary}

Return the code only and no markdown codeblocks.
                    ]]
							end,
						},
					},
				},
			},
		})
	end,
}
