return {
	"stevearc/conform.nvim",
	lazy = false,
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
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_fallback = true,
			},
			cwd = require("conform.util").root_file({ ".editorconfig", "package.json" }),
			-- When cwd is not found, don't run the formatter (default false)
			require_cwd = true,
		})
	end,
}
