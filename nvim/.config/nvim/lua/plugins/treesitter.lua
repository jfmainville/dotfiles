return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
			install_dir = vim.fn.stdpath("data") .. "/site",
		})
		require("nvim-treesitter").install({
			"hcl",
			"cpp",
			"bash",
			"dockerfile",
			"terraform",
			"javascript",
			"typescript",
			"tsx",
			"cmake",
			"make",
			"markdown",
			"markdown_inline",
			"http",
			"python",
			"html",
			"json",
			"yaml",
			"css",
			"scss",
			"prisma",
			"c",
			"lua",
			"php",
			"regex",
			"sql",
			"vim",
			"vimdoc",
			"query",
			"gitcommit",
			"go",
			"gomod",
			"gosum",
			"gowork",
		})
		-- The main branch doesn't enable highlighting automatically
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
