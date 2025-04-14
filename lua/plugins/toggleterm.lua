return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<C-a>]],
			shade_terminals = false,
			persist_mode = true,
			start_in_insert = true,
			direction = "horizontal",
			autochdir = true,
			auto_scroll = true,
			hide_numbers = false,

			-- Keymaps
			vim.keymap.set("n", "<leader>ta", function()
				vim.cmd("silent! ToggleTermToggleAll")
			end),
			vim.keymap.set("n", "<leader>tn", function()
				vim.cmd("silent! TermNew")
			end),
		})

		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "jj", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd k<CR>]], opts) -- Need to pass the k command for the keymap binding to work properly
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
		end

		-- if you only want these mappings for toggle term use term://*toggleterm#* instead
		vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

		-- Fix the yanking multiple lines issue in terminal mode where newlines would be automatically added
		vim.api.nvim_create_autocmd("TextYankPost", {
			pattern = "*",
			callback = function()
				if vim.bo.buftype == "terminal" then
					local yanked_text = vim.fn.getreg('"')
					local cleaned_text = string.gsub(yanked_text, "\n", "")
					vim.fn.setreg("*", cleaned_text)
				end
			end,
		})
	end,
}
