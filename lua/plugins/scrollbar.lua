return {
	"petertriho/nvim-scrollbar",
	dependencies = { "lewis6991/gitsigns.nvim" },
	config = function()
		require("scrollbar").setup({
			handle = {
				text = " ",
				blend = 0, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
				color = nil,
				color_nr = nil, -- cterm
				highlight = "CursorColumn",
				hide_if_all_visible = true, -- Hides handle if all lines are visible
			},
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
