-- Set the cursor blinking and shape configuration
vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
-- Enable highlighting of the current line
vim.opt.cursorline = true

vim.opt.nu = true
vim.opt.relativenumber = true
-- Remove the duplicate mode indicator
vim.opt.showmode = false
-- Enable the spellcheck functionality
vim.opt.spell = false

-- Set the list configuration to show hidden characters
vim.opt.listchars = "trail:-,nbsp:+,tab:| ,eol:↴"
vim.opt.list = false

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Copy the buffer clipboard to the system clipboard
vim.api.nvim_set_option("clipboard", "unnamed")

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
