return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "moon",
			transparent = true, -- Enable transparent background
			terminal_colors = true, -- Enable terminal colors
			styles = {
				sidebars = "transparent", -- Transparent sidebars
				floats = "transparent", -- Transparent floating windows
			},
		})
		vim.cmd("colorscheme tokyonight-moon")
	end,
}
