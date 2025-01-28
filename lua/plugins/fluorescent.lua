return {
	{
		"jfmainville/fluorescent.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local fm = require("fluorescent")
			fm.setup({
				glow = false,
				theme = "fluorescent",
				transparent = false,
			})

			vim.cmd.colorscheme("fluorescent")
		end,
	},
}
