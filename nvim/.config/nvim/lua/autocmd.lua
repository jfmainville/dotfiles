-- Fix for the GBrowse issue that can't open links
vim.api.nvim_create_user_command("Browse", function(opts)
	local url = opts.fargs[1]
	local opener
	if vim.fn.has("mac") == 1 then
		opener = "open"
	elseif vim.fn.has("unix") == 1 then
		opener = "xdg-open"
	end
	if opener then
		vim.fn.system({ opener, url })
	end
end, { nargs = 1 })

-- Center first search result
vim.api.nvim_create_autocmd("CmdlineEnter", {
	pattern = "/",
	callback = function()
		vim.cmd("cnoremap <CR> <CR>zz")
	end,
})
