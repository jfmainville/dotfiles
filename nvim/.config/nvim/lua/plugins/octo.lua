return {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	cmd = "Octo",
	opts = {
		picker = "telescope",
		enable_builtin = true,
	},
	config = function(_, opts)
		require("octo").setup(opts)

		-- Close the Octo window/buffer without quitting nvim
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "octo",
			callback = function(args)
				vim.keymap.set("n", "<leader>oc", "<CMD>bd<CR>", {
					buffer = args.buf,
					desc = "Close Octo window",
					silent = true,
				})
			end,
		})
	end,
	keys = {
		{
			"<leader>oi",
			"<CMD>Octo issue list<CR>",
			desc = "List GitHub Issues",
		},
		{
			"<leader>op",
			"<CMD>Octo pr list<CR>",
			desc = "List GitHub PullRequests",
		},
		{
			"<leader>od",
			"<CMD>Octo discussion list<CR>",
			desc = "List GitHub Discussions",
		},
		{
			"<leader>on",
			"<CMD>Octo notification list<CR>",
			desc = "List GitHub Notifications",
		},
		{
			"<leader>os",
			function()
				require("octo.utils").create_base_search_command({ include_current_repo = true })
			end,
			desc = "Search GitHub",
		},
	},
}
