return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	keys = {
		{
			"<leader>e",
			function()
				require("oil").open(nil, { preview = { vertical = true, split = "belowright" } })
			end,
			desc = "Open Oil explorer",
		},
	},
	init = function()
		-- Show the preview window whenever an Oil directory is opened
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilEnter",
			callback = function()
				if not require("oil.util").get_preview_win() then
					require("oil").open_preview({ vertical = true, split = "belowright" })
				end
			end,
		})
	end,
	opts = {
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, _)
				local hidden = { ".git", ".DS_Store" }
				return vim.tbl_contains(hidden, name)
			end,
		},
		skip_confirm_for_simple_edits = true,
	},
}
