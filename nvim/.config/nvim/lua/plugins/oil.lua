return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	keys = {
		{
			"<leader>e",
			"<cmd>Oil<cr>",
			desc = "Open Oil explorer",
		},
	},
	opts = {
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, _)
				local hidden = { ".git", ".DS_Store" }
				return vim.tbl_contains(hidden, name)
			end,
		},
		skip_confirm_for_simple_edits = false,
	},
}
