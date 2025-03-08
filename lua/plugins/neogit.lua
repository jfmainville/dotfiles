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
	},
	config = function()
		require("neogit").setup({
			disable_signs = false,
			disable_builtin_notifications = false,
			disable_hint = false,
		})
	end,
}
