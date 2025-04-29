return {
	"williamboman/mason.nvim",
	dependencies = { "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim" },
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		local lsp_servers = {
			ts_ls = {},
			eslint = {},
			cssls = {
				capabilities = capabilities,
			},
			cssmodules_ls = {},
			tailwindcss = {},
			emmet_language_server = {},
			ansiblels = {
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
			},
			dockerls = {},
			yamlls = {
				settings = {
					yaml = {
						format = {
							enable = true,
						},
						schemas = {
							["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.1-standalone-strict/all.json"] = "*/kubernetes/*.yaml",
							["http://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
							["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
								"*/pipelines/*.yml",
								"*/.pipelines/*.yml",
								"*/pipelines/*.yaml",
								"*/.pipelines/*.yaml",
							},
						},
						schemastore = {
							enable = true,
						},
					},
				},
			},
			pyright = {},
			bashls = {},
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
			jsonls = {},
			prismals = {},
			intelephense = {},
			rust_analyzer = {},
			terraformls = {},
			tflint = {},
			typos_lsp = {},
			marksman = {},
		}

		-- Need to customized the installed LSPs based on the operating system and architecture used
		local function is_debian_arm64()
			local f = io.popen("dpkg --print-architecture")
			local arch = f:read("*a")
			f:close()

			return arch:match("arm64") ~= nil
		end

		local function is_wsl()
			local wsl_env = os.getenv("WSLENV")
			return wsl_env ~= nil
		end

		if is_debian_arm64() then
			-- Create a function to remove an item from a table using a string
			local function remove_item(tbl, item)
				for i, v in pairs(tbl) do
					if v == item then
						return table.remove(tbl, i)
					end
				end
			end

			remove_item(lsp_servers, "lua_ls")
		end

		if is_wsl() then
			-- Create a function to remove an item from a table using a string
			local function add_item(tbl, item)
				for i, v in pairs(tbl) do
					if v == item then
						return table.insert(tbl, i)
					end
				end
			end

			add_item(lsp_servers, "powershell_es")
			require("lspconfig").powershell_es.setup({
				filetypes = { "ps1", "psm1", "psd1" },
				bundle_path = "C:/Users/jfmainville/Documents/Tools/PowerShellEditorServices",
				shell = "powershell.exe",
				settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
				init_options = {
					enableProfileLoading = false,
				},
			})
		end

		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = lsp_servers,
			handlers = {
				function(server_name)
					local server = lsp_servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
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
				vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			end,
		})
	end,
}
