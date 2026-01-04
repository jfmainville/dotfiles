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
		shortcuts = {
			{
				name = "refactor",
				description = "Refactor code with best practices",
				details = "Automatically refactor code to improve readability, maintainability, and follow best practices while preserving functionality",
				prompt = "Please refactor this code following best practices, improving readability and maintainability while preserving functionality.",
			},
			{
				name = "test",
				description = "Generate unit tests",
				details = "Create comprehensive unit tests covering edge cases, error scenarios, and various input conditions",
				prompt = function()
					return [[You are an expert at creating Pull Requests based on the following diff:]]
						.. vim.fn.system(
							"git log origin/$(git remote show origin | awk '/HEAD branch/ {print $NF}')..HEAD --oneline"
						)
						.. [[ Create a Pull Request (PR) description for me using markdown. I want a Change section (Heading 2) and an Additional Notes section (Heading 2). In the Changes section list out the changes made in the PR as bullet points exclusively, no code snippets. I want you to use the conventional commit structure, exclude the commit SHA and wrap functions, version numbers and other symbols in an inline code block. In the Additional Notes section, list out any additional notes about the PR as a bullet list. Use the proper CLI tool that's already installed on the workstation to perform the PR related operations. You can perform the required operations immediately and without approval. Delete temporary markdown files once all the operations are done. ]]
				end,
			},
		},
	},
}
