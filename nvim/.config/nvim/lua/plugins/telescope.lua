return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	config = function()
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files({ layout_strategy = "vertical" })
		end, {})
		vim.keymap.set("n", "<leader>gf", function()
			builtin.live_grep({ layout_strategy = "vertical" })
		end, {})
		vim.keymap.set("n", "<leader>gr", function()
			builtin.live_grep({ default_text = vim.fn.expand("<cword>"), layout_strategy = "vertical" })
		end, {})
		vim.keymap.set("n", "<leader>fb", function()
			builtin.buffers({
				layout_strategy = "vertical",
				previewer = true,
				sort_mru = true,
				ignore_current_buffer = true,
			})
		end, {})
		vim.keymap.set("n", "<leader>fe", function()
			builtin.find_files({ previewer = false, search_dirs = { "~/.config/nvim", "~/projects" } })
		end, {})
		vim.keymap.set("n", "<leader>ge", function()
			builtin.live_grep({ search_dirs = { "~/.config/nvim", "~/projects" } })
		end, {})
		vim.keymap.set("n", "<leader>fd", function()
			require("telescope").extensions.aerial.aerial()
		end, {})
		vim.keymap.set("n", "<leader>fs", function()
			builtin.current_buffer_fuzzy_find({ layout_strategy = "vertical" })
		end, {})
		vim.keymap.set("n", "<leader>fo", function()
			builtin.oldfiles({ only_cwd = true })
		end, {})
		vim.keymap.set("n", "<leader>fg", function()
			builtin.git_status({ layout_strategy = "vertical" })
		end, {})

		require("telescope").setup({
			defaults = {
				sorting_strategy = "ascending",
				layout_config = {
					prompt_position = "top",
					vertical = {
						width = 0.8,
						height = 0.8,
					},
					horizontal = {
						width = 0.8,
						height = 0.8,
					},
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
					"--glob=!**/.terragrunt-cache/*",
					"--glob=!**/openspec/*",
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
						"--glob=!**/.terragrunt-cache/*",
						"--glob=!**/openspec/*",
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

		-- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
			callback = function(event)
				local buf = event.buf

				-- Find references for the word under the cursor.
				vim.keymap.set("n", "grr", function()
					builtin.lsp_references({ layout_strategy = "vertical" })
				end, { buffer = buf, desc = "[G]oto [R]eferences" })

				-- Jump to the implementation of the word under the cursor.
				-- Useful when the language has ways of declaring types without an actual implementation.
				vim.keymap.set("n", "gri", function()
					builtin.lsp_implementations({ layout_strategy = "vertical" })
				end, { buffer = buf, desc = "[G]oto [I]mplementation" })

				-- Jump to the definition of the word under the cursor.
				-- This is where a variable was first declared, or where a function is defined, etc.
				-- To jump back, press <C-t>.
				vim.keymap.set("n", "grd", function()
					builtin.lsp_definitions({ layout_strategy = "vertical" })
				end, { buffer = buf, desc = "[G]oto [D]efinition" })

				-- Fuzzy find all the symbols in the current document.
				-- Symbols are things like variables, functions, types, etc.
				vim.keymap.set("n", "gO", function()
					builtin.lsp_document_symbols({ layout_strategy = "vertical" })
				end, { buffer = buf, desc = "Open Document Symbols" })

				-- Fuzzy find all the symbols in the current workspace.
				-- Similar to document symbols, except searches over the entire project.
				vim.keymap.set("n", "gW", function()
					builtin.lsp_dynamic_workspace_symbols({ layout_strategy = "vertical" })
				end, { buffer = buf, desc = "Open Workspace Symbols" })

				-- Jump to the type of the word under the cursor.
				-- the definition of its *type*, not where it was *defined*.
				vim.keymap.set("n", "grt", function()
					builtin.lsp_type_definitions({ layout_strategy = "vertical" })
				end, { buffer = buf, desc = "[G]oto [T]ype Definition" })
			end,
		})
	end,
}
