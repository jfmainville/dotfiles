return {
	"zbirenbaum/copilot.lua",
	lazy = false,
	event = "InsertEnter",
	keys = {
		{
			mode = "n",
			"<leader>tc",
			"<cmd>Copilot suggestion<CR>",
			desc = "Toggle the Copilot suggestions",
		},
	},
	config = function()
		require("copilot").setup({
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = false,
				auto_trigger = true,
				keymap = {
					accept = "<S-Tab>",
					accept_word = false,
					accept_line = false,
					next = "<C-j>",
					prev = "<C-k>",
					dismiss = "<C-e>",
				},
			},
			filetypes = {
				yaml = true,
				markdown = true,
				gitcommit = true,
				gitrebase = true,
				hgcommit = true,
			},
		})
	end,
}
