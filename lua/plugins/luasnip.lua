return {
	"L3MON4D3/LuaSnip",
	config = function()
		require("luasnip").filetype_extend("typescript", { "javascript" })
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
