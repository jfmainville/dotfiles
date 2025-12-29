return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		lazy = false,
		keys = {
			{
				mode = "n",
				"<leader>tm",
				"<cmd>RenderMarkdown toggle<CR>",
				desc = "Toggle the Markview markdown preview mode",
			},
		},
		ft = { "markdown", "codecompanion" },
		opts = {},
	},
}
