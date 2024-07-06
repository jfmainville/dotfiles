local lsp_zero = require("lsp-zero")

ENSURE_INSTALLED = {
	"tsserver",
  "cssls",
  "tailwindcss",
	"ansiblels",
	"dockerls",
	"yamlls",
	"pyright",
	"bashls",
	"lua_ls",
  "jsonls",
	"prismals",
	"intelephense",
	"rust_analyzer",
	"terraformls",
	"tflint",
	"typos_lsp",
	"marksman",
}

-- Need to customized the installed LSPs based on the operating system and architecture used
local function is_debian_arm64()
	local f = io.popen("dpkg --print-architecture")
	local arch = f:read("*a")
	f:close()

	return arch:match("arm64") ~= nil
end
if is_debian_arm64() then
	-- Create a function to remove an item from a table using a string
	local function remove_item(tbl, item)
		for i, v in pairs(tbl) do
			if v == item then
				return table.remove(tbl, i)
			end
		end
	end

	remove_item(ENSURE_INSTALLED, "lua_ls")
end

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = ENSURE_INSTALLED,
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
	},
})
