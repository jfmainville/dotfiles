return {
	"emrearmagan/atlas.nvim",
	-- dir = "~/projects/atlas.nvim", -- For development only
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"MeanderingProgrammer/render-markdown.nvim",
		"esmuellert/codediff.nvim",
	},
	keys = {
		{
			mode = "n",
			"<leader>op",
			"<cmd>AtlasPulls<cr>",
			desc = "Open the list of PRs",
		},
	},
	opts = {
		pulls = {
			providers = {
				github = {
					views = {
						{
							name = "Me",
							key = "1",
							layout = "plain",
							search = "author:@me assignee:@me sort:updated-desc",
						},
						{
							name = "Team",
							key = "2",
							layout = "plain",
							search = "assignee:@me assignee:mbonin_gswc assignee:fbgirard_gswc assignee:pbtrudel_gswc assignee:pojasmin_gswc org:sherweb-operations org:sherweb-development sort:updated-desc",
						},
					},
				},
			},
		},
		issues = {
			providers = {
				github = {},
			},
		},
	},
}
