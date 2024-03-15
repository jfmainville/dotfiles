require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { "prettier" },
		bash = { "shellcheck" },
		terraform = { "terraform_fmt" },
		tf = { "terraform_fmt" },
		["terraform-vars"] = { "terraform_fmt" },
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
