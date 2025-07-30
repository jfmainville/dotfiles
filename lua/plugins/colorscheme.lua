return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "storm",
			transparent = true, -- Enable transparent background
			terminal_colors = true, -- Enable terminal colors
			styles = {
				sidebars = "transparent", -- Transparent sidebars
				floats = "transparent", -- Transparent floating windows
			},
		})
		vim.cmd("colorscheme tokyonight-storm")
	end,
}
