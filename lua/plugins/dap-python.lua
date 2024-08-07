return {
	"mfussenegger/nvim-dap-python",
	dependencies = { "mfussenegger/nvim-dap" },
	config = function()
		require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
		require("dap-python").test_runner = "pytest"
	end,
}
