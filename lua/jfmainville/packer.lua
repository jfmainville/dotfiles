vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- Themes
	use({ "catppuccin/nvim", as = "catppuccin" })

	-- DAP
	use("mfussenegger/nvim-dap")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })
	use({ "mfussenegger/nvim-dap-python", requires = { "mfussenegger/nvim-dap" } })

	-- Plugins
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
		},
	})
	use("kylechui/nvim-surround")
	use("christoomey/vim-tmux-navigator")
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("theprimeagen/harpoon")
	use("lukas-reineke/indent-blankline.nvim")
	use("mbbill/undotree")
	use("lewis6991/gitsigns.nvim")
	use("nvim-tree/nvim-web-devicons")
	use("folke/trouble.nvim")
	use({ "folke/todo-comments.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use("numToStr/Comment.nvim")
	use({
		"ggandor/leap.nvim",
		requires = {
			{ "tpope/vim-repeat" },
		},
	})
	use({
		"kdheepak/lazygit.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
	use({ "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons", opt = true } })
	use("stevearc/oil.nvim")
	use("stevearc/conform.nvim")
	use({
		"jackMort/ChatGPT.nvim",
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim",
			"nvim-telescope/telescope.nvim",
		},
	})
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "onsails/lspkind.nvim" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})
end)
