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
		{
			mode = "n",
			"<leader>oc",
			"<cmd>AtlasCreatePR<cr>",
			desc = "Create a new PR",
		},
	},
	opts = {
		pulls = {
			default_merge_method = "squash",
			default_delete_branch = true,
			providers = {
				github = {
					views = {
						{
							name = "Me",
							key = "1",
							layout = "compact",
							search = "author:@me assignee:@me sort:updated-desc",
						},
						{
							name = "Team",
							key = "2",
							layout = "compact",
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
		keymaps = {
			ui = {
				submit = "<leader><leader>",
			},
			pulls = {
				review = {
					explorer = {
						next_file = { "f", "<Tab>" },
						previous_file = { "F", "<S-Tab>" },
						next_unreviewed_file = "un",
						previous_unreviewed_file = "up",
					},
					diff = {
						next_hunk = "h",
						previous_hunk = "H",
						next_comment = "gcn",
						previous_comment = "gcp",
					},
				},
			},
		},
	},
}
