return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			mode = "n",
			"<leader>o",
			"<cmd>Oil<CR>",
			desc = "Open the Oil file viewer in a separate buffer",
		},
	},
	config = function()
		require("oil").setup({
			-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
			-- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
			default_file_explorer = true,
			-- Id is automatically added at the beginning, and name at the end
			-- See :help oil-columns
			columns = {
				"icon",
				-- "permissions",
				-- "size",
				-- "mtime",
			},
			keymaps = {
				["g?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["<C-s>"] = { "actions.select", opts = { vertical = true } },
				["<C-h>"] = { "actions.select", opts = { horizontal = true } },
				["<C-t>"] = { "actions.select", opts = { tab = true } },
				["<C-p>"] = { "actions.preview", opts = { vertical = true, split = "botright" } },
				["<C-c>"] = { "actions.close", mode = "n" },
				["<C-l>"] = "actions.refresh",
				["-"] = { "actions.parent", mode = "n" },
				["_"] = { "actions.open_cwd", mode = "n" },
				["`"] = { "actions.cd", mode = "n" },
				["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
				["gs"] = { "actions.change_sort", mode = "n" },
				["gx"] = "actions.open_external",
				["g."] = { "actions.toggle_hidden", mode = "n" },
				["g\\"] = { "actions.toggle_trash", mode = "n" },
			},
			-- Automatically open the preview window when entering a file
			-- vim.api.nvim_create_autocmd("User", {
			-- 	pattern = "OilEnter",
			-- 	callback = vim.schedule_wrap(function(args)
			-- 		local oil = require("oil")
			-- 		if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
			-- 			oil.open_preview({ vertical = true, split = "botright" })
			-- 		end
			-- 	end),
			-- }),
		})
	end,
}
