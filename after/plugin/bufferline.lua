local bufferline = require("bufferline")

require("bufferline").setup({
	options = {
		mode = "buffers",
		style_preset = bufferline.style_preset.default,
		themable = true,
		numbers = "ordinal",
		color_icons = true,
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "left",
				separator = true,
			},
		},
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_tab_indicator = true,
		separator_style = "line",
		diagnostics = "nvim_lsp",
	},
	highlights = {
		fill = {
			bg = "#0f0125",
		},
	},
})
