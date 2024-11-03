return {
	"petertriho/nvim-scrollbar",
	dependencies = { "lewis6991/gitsigns.nvim" },
	config = function()
		require("scrollbar").setup({
			handlers = {
				cursor = true,
				diagnostic = true,
				gitsigns = true, -- Requires gitsigns
				handle = true,
				search = false, -- Requires hlslens
				ale = false, -- Requires ALE
			},
		})
	end,
}
