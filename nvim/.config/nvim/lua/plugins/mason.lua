return {
	"williamboman/mason.nvim",
	dependencies = { "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim" },
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		-- Detect Ansible files by their directory names so ansiblels attaches to them
		local ansible_dir_names = {
			playbooks = true,
			roles = true,
			tasks = true,
			handlers = true,
			group_vars = true,
			host_vars = true,
			inventory = true,
			inventories = true,
			molecule = true,
			collections = true,
		}
		local function ansible_filetype(path)
			local lower = path:lower()
			if lower:match("[^/]*playbook[^/]*%.ya?ml$") or lower:match("/site%.ya?ml$") then
				return "yaml.ansible"
			end
			-- Check the directory names only, so the file name itself never counts
			for dir in vim.fs.dirname(lower):gmatch("[^/]+") do
				if
					ansible_dir_names[dir]
					or dir:find("ansible", 1, true)
					or dir:match("_roles$")
					or dir:match("_playbooks$")
				then
					return "yaml.ansible"
				end
			end
		end
		vim.filetype.add({
			pattern = {
				[".*%.ya?ml"] = ansible_filetype,
			},
		})

		vim.lsp.config("cssls", {
			capabilities = capabilities,
		})
		vim.lsp.enable("cssls")
		vim.lsp.enable("stylelint_lsp")
		vim.lsp.config("ansiblels", {
			root_markers = {
				"ansible.cfg",
				".ansible-lint",
				"roles",
				"playbooks",
				"group_vars",
				"host_vars",
				"inventory",
				"molecule",
				".git",
			},
			settings = {
				ansible = {
					ansible = {
						path = "ansible",
					},
					executionEnvironment = {
						enabled = false,
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
		vim.lsp.config("ruff", {
			init_options = {
				settings = {
					-- Use the project's ruff config when it has one, these settings otherwise
					configurationPreference = "filesystemFirst",
					lineLength = 88,
					lint = {
						select = { "E", "F", "W", "I", "B", "UP", "SIM" },
					},
				},
			},
		})
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		vim.lsp.enable("ts_ls")
		vim.lsp.enable("eslint")
		vim.lsp.enable("cssmodules_ls")
		vim.lsp.enable("tailwindcss")
		vim.lsp.enable("emmet_language_server")
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("yamlls")
		vim.lsp.enable("ansiblels")
		vim.lsp.enable("dockerls")
		vim.lsp.enable("pyright")
		vim.lsp.enable("ruff")
		vim.lsp.enable("bashls")
		vim.lsp.enable("jsonls")
		vim.lsp.enable("prismals")
		vim.lsp.enable("intelephense")
		vim.lsp.enable("rust_analyzer")
		vim.lsp.enable("terraformls")
		vim.lsp.enable("tflint")
		vim.lsp.config("typos_lsp", {
			init_options = {
				config = vim.fn.expand("~/.config/nvim/typos.toml"),
			},
		})
		vim.lsp.enable("typos_lsp")
		vim.lsp.enable("marksman")

		require("mason").setup({})

		-- Install the formatters used by conform and the tools mason-lspconfig can't resolve on its own
		local registry = require("mason-registry")
		registry.refresh(function()
			for _, name in ipairs({
				"stylua",
				"black",
				"prettier",
				"shfmt",
				"clang-format",
				"shellcheck",
				"ansible-lint",
				"stylelint-language-server",
			}) do
				local package = registry.get_package(name)
				if not package:is_installed() then
					package:install()
				end
			end
		end)
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
				"ruff",
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

		-- Fix for pyright to prevent the constant notifications
		vim.lsp.handlers["$/progress"] = function() end

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
