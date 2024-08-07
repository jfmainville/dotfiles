return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			mode = "buffers",
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
	},
}
