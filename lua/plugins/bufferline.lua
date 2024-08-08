return {
	"akinsho/bufferline.nvim",
	version = "*",
  event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			mode = "n",
			"<leader>bc",
			"<CMD>BufferLinePickClose<CR>",
			desc = "Close the desired buffer",
		},
		{ mode = "n", "<leader>ba", "<cmd>%bd|e#|bd#<CR>", desc = "Close all the opened buffers" },
		{ mode = "n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Cycle to the next buffer" },
		{ mode = "n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Cycle to the previous buffer" },
		{
			mode = "n",
			"<leader>1",
			"<CMD>BufferLineGoToBuffer1<CR>",
			desc = "Navigate to the buffer with the index 1",
		},
		{
			mode = "n",
			"<leader>2",
			"<CMD>BufferLineGoToBuffer2<CR>",
			desc = "Navigate to the buffer with the index 2",
		},
		{
			mode = "n",
			"<leader>3",
			"<CMD>BufferLineGoToBuffer3<CR>",
			desc = "Navigate to the buffer with the index 3",
		},
		{
			mode = "n",
			"<leader>4",
			"<CMD>BufferLineGoToBuffer4<CR>",
			desc = "Navigate to the buffer with the index 4",
		},
		{
			mode = "n",
			"<leader>5",
			"<CMD>BufferLineGoToBuffer5<CR>",
			desc = "Navigate to the buffer with the index 5",
		},
		{
			mode = "n",
			"<leader>6",
			"<CMD>BufferLineGoToBuffer6<CR>",
			desc = "Navigate to the buffer with the index 6",
		},
		{
			mode = "n",
			"<leader>7",
			"<CMD>BufferLineGoToBuffer7<CR>",
			desc = "Navigate to the buffer with the index 7",
		},
		{
			mode = "n",
			"<leader>8",
			"<CMD>BufferLineGoToBuffer8<CR>",
			desc = "Navigate to the buffer with the index 8",
		},
		{
			mode = "n",
			"<leader>9",
			"<CMD>BufferLineGoToBuffer9<CR>",
			desc = "Navigate to the buffer with the index 9",
		},
	},
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
