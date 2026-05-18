return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main", -- This branch is frozen and will be removed eventually, need to upgrade soon
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
			"sql",
			"vim",
			"vimdoc",
			"query",
			"gitcommit",
		})
	end,
}
