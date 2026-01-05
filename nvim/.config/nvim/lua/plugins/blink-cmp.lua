return {
	"saghen/blink.cmp",
	dependencies = { "fang2hou/blink-copilot" },
	version = "1.*",
	opts = {
		keymap = {
			preset = "none",
			["<C-y>"] = { "accept", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			menu = {
				border = "single",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = { border = "single" },
			},
		},
		signature = {
			enabled = true,
			window = { border = "single" },
		},
		sources = {
			default = {
				"copilot",
				"lsp",
				"path",
				"snippets",
				"buffer",
			},
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
