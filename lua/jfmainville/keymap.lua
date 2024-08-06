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
-- Greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Return to normal mode
vim.keymap.set("i", "jj", "<Esc>")
-- Replace current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Add the execute permission to the current file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- Source the current file
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)
-- Open ChatGPT window
vim.keymap.set("n", "<leader>cg", "<cmd>ChatGPT<CR>")
-- Format the file using the Conform plugin
vim.keymap.set("", "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end)
-- Interact with vim-fugitive
vim.keymap.set("n", "<leader>gg", "<cmd>tab Git<CR>")
vim.keymap.set("n", "<leader>gl", "<cmd>vertical Git log -p -- %<CR>")
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiff<CR>")
vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>")
vim.keymap.set("n", "<leader>gh", ':Git commit -m "')
vim.keymap.set("n", "<leader>ga", ':Git commit -am "')
-- Start the DAP debugger
vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>")
-- Add a breakpoint DAP debugger
vim.keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>")
-- Prevent unselect during indent operations
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Keymaps to open vertical and horizontal splits
vim.keymap.set("n", "<leader>ss", "<C-w>v")
vim.keymap.set("n", "<leader>sh", "<C-w>s")
-- Interact between bufferline tabs
vim.keymap.set("n", "<leader>bc", "<CMD>BufferLinePickClose<CR>")
vim.keymap.set("n", "<leader>ba", "<CMD>%bd|e#|bd#<CR>")
vim.keymap.set("n", "<S-l>", "<CMD>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-h>", "<CMD>BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<leader>1", "<CMD>BufferLineGoToBuffer1<CR>")
vim.keymap.set("n", "<leader>2", "<CMD>BufferLineGoToBuffer2<CR>")
vim.keymap.set("n", "<leader>3", "<CMD>BufferLineGoToBuffer3<CR>")
vim.keymap.set("n", "<leader>4", "<CMD>BufferLineGoToBuffer4<CR>")
vim.keymap.set("n", "<leader>5", "<CMD>BufferLineGoToBuffer5<CR>")
vim.keymap.set("n", "<leader>6", "<CMD>BufferLineGoToBuffer6<CR>")
vim.keymap.set("n", "<leader>7", "<CMD>BufferLineGoToBuffer7<CR>")
vim.keymap.set("n", "<leader>8", "<CMD>BufferLineGoToBuffer8<CR>")
vim.keymap.set("n", "<leader>9", "<CMD>BufferLineGoToBuffer9<CR>")
