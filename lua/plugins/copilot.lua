return {
	"zbirenbaum/copilot.lua",
	lazy = false,
	config = function()
		require("copilot").setup({
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = false,
			},
		})
	end,
}
