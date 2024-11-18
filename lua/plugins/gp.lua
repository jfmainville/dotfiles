return {
	"robitx/gp.nvim",
	lazy = false,
	keys = {
		{
			mode = "n",
			"<leader>cn",
			"<cmd>GpChatNew popup<CR>",
			desc = "Open a new chat window",
		},
		{
			mode = "n",
			"<leader>ci",
			"<cmd>GpImplement<CR>",
			desc = "Write code based on a comment",
		},
		{
			mode = "v",
			"<leader>cr",
			function()
				vim.fn.feedkeys(":'<,'>GpRewrite ")
			end,
			desc = "Rewrite the currently selected text based on a prompt",
		},
		{
			mode = "v",
			"<leader>cp",
			":'<,'>GpChatPaste popup<CR>",
			desc = "Paste the currently selected code in a new chat window",
		},
		{
			mode = "n",
			"<leader>cf",
			"<cmd>GpChatFinder<CR>",
			desc = "Open the chat finder window",
		},
		{
			mode = "v",
			"<leader>ce",
			":'<,'>GpExplain popup<CR>",
			desc = "Explain the currently selected text",
		},
	},
	config = function()
		require("gp").setup({
			default_command_agent = "ChatGPT4o-mini",
			default_chat_agent = "ChatGPT4o-mini",
			agents = {
				{
					name = "ChatGPT3-5",
					chat = true,
					command = false,
					-- string with model name or table with model name and parameters
					model = { model = "gpt-3.5-turbo", temperature = 1.1, top_p = 1 },
					-- system prompt (use this to specify the persona/role of the AI)
					system_prompt = require("gp.defaults").chat_system_prompt,
				},
				{
					name = "ChatGPT4o-mini",
					chat = true,
					command = false,
					-- string with model name or table with model name and parameters
					model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
					-- system prompt (use this to specify the persona/role of the AI)
					system_prompt = require("gp.defaults").chat_system_prompt,
				},
			},
			chat_free_cursor = false,
			chat_confirm_delete = false,
			chat_finder_pattern = "topic ",
			toggle_target = "split",
			chat_shortcut_respond = { modes = { "n" }, shortcut = "<CR>" },
			chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
			chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
			chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },
			hooks = {
				-- Use GpExplain to explain the currently selected code
				Explain = function(gp, params)
					local template = "I have the following code from {{filename}}:\n\n"
						.. "```{{filetype}}\n{{selection}}\n```\n\n"
						.. "Please respond by explaining the code above."
					local agent = gp.get_chat_agent()
					gp.Prompt(params, gp.Target.popup, agent, template)
				end,
			},
		})
	end,
}
