return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	config = function()
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files()
		end, {})
		vim.keymap.set("n", "<leader>gf", function()
			builtin.live_grep()
		end, {})
		vim.keymap.set("n", "<leader>fb", function()
			builtin.buffers()
		end, {})
		vim.keymap.set("n", "<leader>fe", function()
			builtin.find_files({ search_dirs = { "~/.config/nvim", "~/projects" } })
		end, {})
		vim.keymap.set("n", "<leader>ge", function()
			builtin.live_grep({ search_dirs = { "~/.config/nvim", "~/projects" } })
		end, {})
		vim.keymap.set("n", "<leader>fd", function()
			require("telescope").extensions.aerial.aerial()
		end, {})
		vim.keymap.set("n", "<leader>fs", function()
			builtin.current_buffer_fuzzy_find()
		end, {})
		vim.keymap.set("n", "<leader>fo", function()
			builtin.oldfiles({ only_cwd = true })
		end, {})
		vim.keymap.set("n", "<leader>fg", function()
			builtin.git_status()
		end, {})

		require("telescope").setup({
			defaults = {
				layout_strategy = "vertical",
				sorting_strategy = "ascending",
				layout_config = {
					height = vim.o.lines,
					width = vim.o.columns,
					prompt_position = "top",
					preview_height = 0.6,
				},
				-- Remove the ripgrep indentation
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--no-ignore-vcs",
					"--column",
					"--smart-case",
					"--trim",
					"--glob=!**/.git/*",
					"--glob=!**/.idea/*",
					"--glob=!**/.vscode/*",
					"--glob=!**/dist/*",
					"--glob=!**/yarn.lock",
					"--glob=!**/package-lock.json",
					"--glob=!**/node_modules/*",
					"--glob=!**/.venv/*",
					"--glob=!**/__init__.py",
					"--glob=!**/.next/*",
					"--glob=!**/.terraform**",
					"--glob=!**/__snapshots__/*",
					"--glob=!**/pgsql/*",
					"--glob=!**/.DStore/*",
				},
			},
			pickers = {
				live_grep = {
					prompt_prefix = "> ",
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
				find_files = {
					prompt_prefix = "🔍 ",
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--no-ignore-vcs",
						"--glob=!**/.git/*",
						"--glob=!**/.idea/*",
						"--glob=!**/.vscode/*",
						"--glob=!**/dist/*",
						"--glob=!**/yarn.lock",
						"--glob=!**/package-lock.json",
						"--glob=!**/node_modules/*",
						"--glob=!**/.venv/*",
						"--glob=!**/__init__.py",
						"--glob=!**/.next/*",
						"--glob=!**/.terraform**",
						"--glob=!**/__snapshots__/*",
						"--glob=!**/pgsql/*",
						"--glob=!**/.DStore/*",
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		})
		require("telescope").load_extension("fzf")
	end,
}
