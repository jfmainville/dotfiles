return {
	"jfmainville/nightfox.nvim",
	branch = "feat/add-flash-module",
	config = function()
		require("nightfox").setup({
			options = {
				transparent = false,
				terminal_colors = true,
				styles = {
					comments = "italic",
					keywords = "bold",
					functions = "bold",
					variables = "italic",
				},
			},
		})

		vim.cmd("colorscheme carbonfox")
	end,
}
