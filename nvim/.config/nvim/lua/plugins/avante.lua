return {
	"yetone/avante.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	build = "make",
	event = "VeryLazy",
	version = false,
	opts = {
		instructions_file = "avante.md",
		provider = "copilot",
		disabled_tools = { "web_search" },
		selection = {
			enabled = true,
			hint_display = "none",
		},
		selector = {
			provider = "telescope",
		},
		shortcuts = {
			{
				name = "refactor",
				description = "Refactor code with best practices",
				details = "Automatically refactor code to improve readability, maintainability, and follow best practices while preserving functionality",
				prompt = "Please refactor this code following best practices, improving readability and maintainability while preserving functionality.",
			},
			{
				name = "create_pr",
				description = "Create a new Pull Request based on recent commits",
				details = "Create a new Pull Request (PR) based on the recent commits made in the current branch compared to the main branch. The PR description should include a Change section listing the changes made and an Additional Notes section for any extra information.",
				prompt = "Create a Pull Request (PR) description for me using markdown. I want a Change section (Heading 2) and an Additional Notes section (Heading 2). In the Changes section list out the changes made in the PR as bullet points exclusively, no code snippets. I want you to use the conventional commit structure, exclude the commit SHA and wrap functions, version numbers and other symbols in an inline code block. In the Additional Notes section, list out any additional notes about the PR as a bullet list. Use the proper CLI tool that's already installed on the workstation to perform the PR related operations. You can perform the required operations immediately and without approval. Delete temporary markdown files once all the operations are done.",
			},
			{
				name = "generate_commit",
				description = "Generate a commit message based on staged changes",
				details = "Use AI to generate a conventional and concise Git commit message based on the changes staged in the repository.",
				prompt = "Compose a Git commit message for the staged changes in the repository. Use the conventional commit format and ensure clarity and conciseness.",
			},
		},
	},
}
