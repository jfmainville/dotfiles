return {
	"echasnovski/mini.files",
	version = false,
	lazy = false,
	keys = {
		{
			mode = "n",
			"<leader>o",
			function()
				require("mini.files").open()
			end,
			desc = "Open the mini.files window",
		},
	},

	config = function()
		require("mini.files").setup({
			mappings = {
				close = "q",
				go_in = "l",
				go_in_plus = "<CR>",
				go_out = "h",
				go_out_plus = "H",
				mark_goto = "'",
				mark_set = "m",
				reset = "<BS>",
				reveal_cwd = "@",
				show_help = "g?",
				synchronize = "=",
				trim_left = "<",
				trim_right = ">",
			},
			windows = {
				-- Whether to show preview of file/directory under cursor
				preview = true,
				-- Width of focused window
				width_focus = 50,
				-- Width of non-focused window
				width_nofocus = 15,
				-- Width of preview window
				width_preview = 75,
			},
		})
	end,
}
