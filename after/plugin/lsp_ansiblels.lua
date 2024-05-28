local lspconfig = require("lspconfig")
lspconfig["ansiblels"].setup({
	filetypes = { "yaml", "yml", "ansible" },
	root_dir = lspconfig.util.root_pattern("roles", "playbooks"),
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
