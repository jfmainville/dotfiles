return {
	"zbirenbaum/copilot.lua",
	dependencies = {
		"copilotlsp-nvim/copilot-lsp",
	},
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
			nes = {
				enabled = false,
				auto_trigger = false,
				keymap = {
					accept_and_goto = false,
					accept = false,
					dismiss = false,
				},
			},
			filetypes = {
				yaml = true,
				markdown = true,
				help = true,
				gitcommit = true,
				gitrebase = true,
				hgcommit = true,
			},
		})
	end,
}
