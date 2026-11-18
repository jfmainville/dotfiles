-- Format files with conform and report LSP errors, warnings, and info, exiting 1 when any are found
-- Usage: nvim --headless -c "luafile ~/.agents/scripts/nvim-check.lua" <files>
local timeout_ms = tonumber(vim.env.NVIM_CHECK_TIMEOUT) or 60000

local bufs = vim.tbl_filter(function(buf)
	return vim.bo[buf].buflisted and vim.api.nvim_buf_get_name(buf) ~= ""
end, vim.api.nvim_list_bufs())

-- Wait until get() returns the same value for quiet_ms
local function wait_stable(get, quiet_ms)
	local last, last_change = nil, vim.uv.now()
	vim.wait(timeout_ms, function()
		local value = get()
		if value ~= last then
			last, last_change = value, vim.uv.now()
		end
		return vim.uv.now() - last_change >= quiet_ms
	end, 200)
end

-- Visit each file so its filetype is detected, then wait for all its language servers to attach
for _, buf in ipairs(bufs) do
	vim.cmd.buffer(buf)
end
wait_stable(function()
	local count = 0
	for _, buf in ipairs(bufs) do
		count = count + #vim.lsp.get_clients({ bufnr = buf })
	end
	return count
end, 2000)

local ok_conform, conform = pcall(require, "conform")
for _, buf in ipairs(bufs) do
	if ok_conform then
		local ok, err = pcall(conform.format, { bufnr = buf, timeout_ms = 10000, lsp_format = "fallback" })
		if not ok then
			io.write(string.format("%s: format failed: %s\n", vim.api.nvim_buf_get_name(buf), err))
		end
	end
	if vim.bo[buf].modified then
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("silent noautocmd write")
		end)
	end
end

wait_stable(function()
	return #vim.diagnostic.get()
end, 3000)

local severities = { "error", "warning", "info" }
local found = 0
for _, buf in ipairs(bufs) do
	local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
	local diagnostics = vim.diagnostic.get(buf, { severity = { min = vim.diagnostic.severity.INFO } })
	table.sort(diagnostics, function(a, b)
		return a.lnum < b.lnum
	end)
	for _, d in ipairs(diagnostics) do
		found = found + 1
		io.write(
			string.format(
				"%s:%d:%d: %s [%s%s] %s\n",
				name,
				d.lnum + 1,
				d.col + 1,
				severities[d.severity],
				d.source or "lsp",
				d.code and (" " .. d.code) or "",
				d.message:gsub("\n", " ")
			)
		)
	end
end

io.write(string.format("nvim-check: %d file(s), %d issue(s)\n", #bufs, found))
vim.cmd(found > 0 and "cquit 1" or "qall!")
