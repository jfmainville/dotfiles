-- Define the leader action to be the space bar
vim.g.mapleader = " "
-- Fix the terminal mode characters replacement
vim.keymap.set("t", "<S-Space>", "<Space>")
vim.keymap.set("t", "<S-BS>", "<BS>")
-- Save the current file in the buffer
vim.keymap.set("n", "za", function()
	vim.cmd("silent! w")
end)
-- Save file and return to the project explorer view
vim.keymap.set("n", "zz", function()
	vim.cmd("silent! w")
	vim.cmd("Oil")
end)
-- Move the currently selected line down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- Move the currently selected line up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- Go up multiple lines
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Go down multiple lines
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- Return to normal mode
vim.keymap.set("i", "jj", "<Esc>")
-- Replace current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Source the current configuration
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("source $MYVIMRC | source $HOME/.config/nvim/lua/keymap.lua")
end)
-- Prevent unselect during indent operations
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Keymaps to open vertical and horizontal splits
vim.keymap.set("n", "<leader>ss", "<C-w>v")
vim.keymap.set("n", "<leader>sh", "<C-w>s")
