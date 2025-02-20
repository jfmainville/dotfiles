return {
	"stevearc/conform.nvim",
	lazy = false,
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>tf",
			function()
				-- If autoformat is currently disabled for this buffer,
				-- then enable it, otherwise disable it
				if vim.b.disable_autoformat then
					vim.cmd("ConformEnable")
					vim.notify("Enabled autoformat for current buffer")
				else
					vim.cmd("ConformDisable!")
					vim.notify("Disabled autoformat for current buffer")
				end
			end,
			desc = "Toggle autoformat for current buffer",
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
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 2000, lsp_format = "fallback" }
			end,
			cwd = require("conform.util").root_file({ ".editorconfig", "package.json" }),
			-- When cwd is not found, don't run the formatter (default false)
			require_cwd = true,

			-- Commands for toggling formmatting
			vim.api.nvim_create_user_command("ConformDisable", function(args)
				if args.bang then
					-- :ConformDisable! disables autoformat for this buffer only
					vim.b.disable_autoformat = true
				else
					-- :ConformDisable disables autoformat globally
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true, -- allows the ! variant
			}),

			vim.api.nvim_create_user_command("ConformEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			}),
		})
	end,
}
