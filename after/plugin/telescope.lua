local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>gf", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fe", function()
	builtin.find_files({ search_dirs = { "~/.config/nvim", "~/software", "~/Projects" } })
end, {})
vim.keymap.set("n", "<leader>ge", function()
	builtin.live_grep({ search_dirs = { "~/.config/nvim", "~/software", "~/Projects" } })
end, {})
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
			file_ignore_patterns = { ".idea", "node_modules", ".git/", ".venv" },
			additional_args = function(_)
				return { "--hidden" }
			end,
		},
		find_files = {
			hidden = true,
			file_ignore_patterns = { ".idea", "node_modules", ".git/", ".venv" },
		},
	},
})
