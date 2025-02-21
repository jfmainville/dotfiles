return {
	"zbirenbaum/copilot.lua",
	lazy = false,
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = false,
			},
			filetypes = {
				yaml = true,
				markdown = true,
			},
		})
	end,
}
