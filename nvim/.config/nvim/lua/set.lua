-- Map the leader keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Enable highlighting of the current line
vim.opt.cursorline = true

vim.opt.nu = true
vim.opt.relativenumber = true
-- Remove the duplicate mode indicator
vim.opt.showmode = false
vim.opt.list = false

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Hide the tab name by default
vim.opt.showtabline = 0

vim.opt.smartindent = true

vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Set the quick search configurations
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Remove the "Press ENTER" prompt for messages
require("vim._core.ui2").enable({
	msg = {
		targets = "msg",
		msg = { height = 1, timeout = 4000 },
	},
})

-- Copy the buffer clipboard to the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Use OSC 52 to copy through the terminal in remote SSH sessions and herdr
if vim.env.SSH_TTY then
	local function paste()
		return { vim.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
	end

	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = paste,
			["*"] = paste,
		},
	}
end

-- Improve search text highlighting
vim.on_key(function(char)
	if vim.fn.mode() == "n" then
		vim.opt.hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
	end
end, vim.api.nvim_create_namespace("auto_hlsearch"))

-- Add filetype detection for Ansible specific files
vim.filetype.add({
	pattern = {
		[".*/ansible/.*%.yaml"] = "yaml.ansible",
		[".*/ansible/.*%.yml"] = "yaml.ansible",
	},
})

-- Set diagonal lines in place of deleted lines in diff-mode
vim.opt.fillchars:append({ diff = "╱" })
