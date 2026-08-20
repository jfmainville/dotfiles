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
			"<cmd>Atlas pulls<cr>",
			desc = "Open the list of PRs",
		},
		{
			mode = "n",
			"<leader>oc",
			"<cmd>Atlas create pr<cr>",
			desc = "Create a new PR",
		},
	},
	opts = {
		pulls = {
			default_merge_method = "squash",
			default_delete_branch = true,
			diff = {
				show_review_panel = true,
				explorer = {
					show_commits = true,
					initial_focus = "diff",
				},
			},
			repo_config = {
				paths = {
					["jfmainville/*"] = "~/projects/*",
					["nuagir/*"] = "~/projects/*",
					["sherweb-development/*"] = "~/projects/*",
					["sherweb-operations/*"] = "~/projects/*",
				},
			},
			providers = {
				github = {
					views = {
						{
							name = "Me",
							key = "1",
							layout = "compact",
							search = "author:@me sort:updated-desc",
						},
						{
							name = "Team",
							key = "2",
							layout = "compact",
							search = "assignee:mbonin_gswc assignee:fbgirard_gswc assignee:pbtrudel_gswc assignee:pojasmin_gswc assignee:dfournier_gswc org:sherweb-operations org:sherweb-development sort:updated-desc",
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
				submit = "<C-s>",
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
