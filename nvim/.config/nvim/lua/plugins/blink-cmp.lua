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
			default = { "copilot" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
				avante_commands = {
					name = "avante_commands",
					module = "blink.compat.source",
					score_offset = 90, -- show at a higher priority than lsp
					opts = {},
				},
				avante_files = {
					name = "avante_files",
					module = "blink.compat.source",
					score_offset = 100, -- show at a higher priority than lsp
					opts = {},
				},
				avante_mentions = {
					name = "avante_mentions",
					module = "blink.compat.source",
					score_offset = 1000, -- show at a higher priority than lsp
					opts = {},
				},
				avante_shortcuts = {
					name = "avante_shortcuts",
					module = "blink.compat.source",
					score_offset = 1000, -- show at a higher priority than lsp
					opts = {},
				},
			},
		},
		{
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"avante_commands",
				"avante_mentions",
				"avante_shortcuts",
				"avante_files",
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
