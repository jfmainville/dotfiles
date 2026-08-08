return {
	"emrearmagan/atlas.nvim",
	dir = "~/projects/atlas.nvim", -- For development only
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"MeanderingProgrammer/render-markdown.nvim",
		"esmuellert/codediff.nvim",
	},
	opts = {
		pulls = {
			providers = {
				github = {}, -- See configuration below
			},
		},
		issues = {
			providers = {
				github = {}, -- See configuration below
			},
		},
	},
}
