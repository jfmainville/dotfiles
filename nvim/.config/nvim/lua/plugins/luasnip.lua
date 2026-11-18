return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	-- Optional: enables regex transformations in snippets (needs make)
	build = "make install_jsregexp",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local luasnip = require("luasnip")
		luasnip.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
		})
		luasnip.filetype_extend("typescript", { "javascript" })
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
