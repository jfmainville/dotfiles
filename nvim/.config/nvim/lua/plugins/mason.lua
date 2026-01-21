return {
	"williamboman/mason.nvim",
	dependencies = { "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim" },
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		vim.lsp.enable("ts_ls")
		vim.lsp.enable("eslint")
		vim.lsp.config("cssls", {
			capabilities = capabilities,
		})
		vim.lsp.enable("cssls")
		vim.lsp.enable("cssmodules_ls")
		vim.lsp.enable("tailwindcss")
		vim.lsp.enable("emmet_language_server")
		vim.lsp.config("ansiblels", {
			settings = {
				ansible = {
					ansible = {
						path = "ansible",
					},
					executionEnvironment = {
						enabled = false,
					},
					python = {
						interpreterPath = "python",
					},
					validation = {
						enabled = true,
						lint = {
							enabled = true,
							path = "ansible-lint",
						},
					},
				},
			},
		})
		vim.lsp.enable("ansiblels")
		vim.lsp.enable("dockerls")
		vim.lsp.config("yamlls", {
			settings = {
				yaml = {
					format = {
						enable = true,
					},
					schemas = {
						["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.1-standalone-strict/all.json"] = "*/kubernetes/*.yaml",
						["http://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
						["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
							"*/pipeline/*.yml",
							"*/.pipeline/*.yml",
							"*/pipeline/*.yaml",
							"*/.pipeline/*.yaml",
							"*/.build/*.yml",
							"*/.build/*.yaml",
						},
					},
					schemastore = {
						enable = true,
					},
				},
			},
		})
		vim.lsp.enable("yamlls")
		vim.lsp.enable("pyright")
		vim.lsp.enable("bashls")
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("jsonls")
		vim.lsp.enable("prismals")
		vim.lsp.enable("intelephense")
		vim.lsp.enable("rust_analyzer")
		vim.lsp.enable("terraformls")
		vim.lsp.enable("tflint")
		vim.lsp.enable("typos_lsp")
		vim.lsp.enable("marksman")

		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = {
				"ts_ls",
				"eslint",
				"cssls",
				"cssmodules_ls",
				"tailwindcss",
				"emmet_language_server",
				"ansiblels",
				"dockerls",
				"yamlls",
				"pyright",
				"bashls",
				"lua_ls",
				"jsonls",
				"prismals",
				"intelephense",
				"rust_analyzer",
				"terraformls",
				"tflint",
				"typos_lsp",
				"marksman",
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf }

				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
				vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
				vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
				vim.keymap.set("n", "<leader>vd", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
				vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
				vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
				vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			end,
		})
	end,
}
