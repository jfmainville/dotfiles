return {
	"jfmainville/fluovibe.nvim",
	-- dir = "~/projects/fluovibe.nvim", # For development only
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("colorscheme fluovibe")
	end,
}
