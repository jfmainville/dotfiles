return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	keys = {
		{
			mode = "n",
			"<leader>tm",
			"<cmd>Markview Toggle<CR>",
			desc = "Toggle the Markview markdown preview mode",
		},
	},
	config = function()
		local presets = require("markview.presets")

		require("markview").setup({
			-- Required to fix a racing condition when starting up neovim
			experimental = {
				check_rtp_message = false,
			},
			markdown = {
				headings = presets.headings.marker,
			},
			preview = {
				filetypes = { "markdown", "codecompanion" },
				ignore_buftypes = {},
			},
		})
	end,
}
