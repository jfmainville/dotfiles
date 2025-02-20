return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<C-a>]],
			shade_terminals = false,
			persist_mode = false,
			start_in_insert = true,
			direction = "horizontal",
			autochdir = true,

			-- Keymaps
			vim.keymap.set("n", "<leader>ta", function()
				vim.cmd("silent! ToggleTermToggleAll")
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
	end,
}
