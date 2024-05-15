local lspconfig = require("lspconfig")
lspconfig["ansiblels"].setup({
	filetypes = { "yaml", "yml", "ansible" },
	root_dir = lspconfig.util.root_pattern("roles", "playbooks"),
})
