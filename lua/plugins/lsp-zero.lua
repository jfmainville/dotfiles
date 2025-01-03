return {
	"VonHeikemen/lsp-zero.nvim",
	version = "v4.x",
	dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
	config = function()
		local lsp_zero = require("lsp-zero")

		ENSURE_INSTALLED = {
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
		}

		lsp_zero.on_attach(function(client, bufnr)
			local opts = { buffer = bufnr, remap = false }

			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, opts)
			vim.keymap.set("n", "<leader>ws", function()
				vim.lsp.buf.workspace_symbol()
			end, opts)
			vim.keymap.set("n", "<leader>vd", function()
				vim.diagnostic.open_float()
			end, opts)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.goto_next()
			end, opts)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.goto_prev()
			end, opts)
			vim.keymap.set("n", "<leader>ca", function()
				vim.lsp.buf.code_action()
			end, opts)
			vim.keymap.set("n", "<leader>rr", function()
				vim.lsp.buf.references()
			end, opts)
			vim.keymap.set("n", "<leader>rn", function()
				vim.lsp.buf.rename()
			end, opts)
			vim.keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, opts)
		end)

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

			remove_item(ENSURE_INSTALLED, "lua_ls")
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

			add_item(ENSURE_INSTALLED, "powershell_es")
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
			ensure_installed = ENSURE_INSTALLED,
			handlers = {
				lsp_zero.default_setup,
				lua_ls = function()
					local lua_opts = lsp_zero.nvim_lua_ls()
					require("lspconfig").lua_ls.setup(lua_opts)
				end,
			},
		})

		-- Enable the autocompletion for the cssls language server
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		require("lspconfig").cssls.setup({
			capabilities = capabilities,
		})

		-- Add customizations for the YAML language server
		require("lspconfig").yamlls.setup({
			settings = {
				yaml = {
					format = {
						enable = true,
					},
					schemas = {
						["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.1-standalone-strict/all.json"] = "*/kubernetes/*.yaml",
						["http://json.schemastore.org/kustomization"] = "kustomization.yaml",
					},
					schemastore = {
						enable = true,
					},
				},
			},
		})

		-- Add customizations for the Ansible language server
		require("lspconfig").ansiblels.setup({
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
	end,
}
