local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})

require("telescope").setup({
	defaults = {
		-- Remove the ripgrep indentation
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--trim", -- add this value
		},
	},
	pickers = {
		live_grep = {
			file_ignore_patterns = { "node_modules", ".git", ".venv" },
			additional_args = function(_)
				return { "--hidden" }
			end,
		},
		find_files = {
			hidden = true,
			file_ignore_patterns = { "node_modules", ".git", ".venv" },
		},
	},
})
