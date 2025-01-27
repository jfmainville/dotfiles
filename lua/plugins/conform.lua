return {
	"stevearc/conform.nvim",
	lazy = false,
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			mode = "n",
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			desc = "Format the current file using the Conform plugin",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				bash = { "shfmt" },
				terraform = { "terraform_fmt" },
				tf = { "terraform_fmt" },
				["terraform-vars"] = { "terraform_fmt" },
				markdown = { "prettier" },
				cpp = { "clang-format" },
				["*"] = { "trim_whitespace", "trim_newlines" },
			},
			format_on_save = {
				timeout_ms = 2000,
				lsp_fallback = true,
			},
			cwd = require("conform.util").root_file({ ".editorconfig", "package.json" }),
			-- When cwd is not found, don't run the formatter (default false)
			require_cwd = true,
		})
	end,
}
