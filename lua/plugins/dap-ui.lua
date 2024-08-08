return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	keys = {
		{
			mode = "n",
			"<leader>dc",
			"<cmd>lua require'dap'.continue()<CR>",
			desc = "Start the DAP debugger",
		},
		{
			mode = "n",
			"<leader>db",
			"<cmd>lua require'dap'.toggle_breakpoint()<CR>",
			desc = "Add a debug breakpoint",
		},
	},
	config = function()
		require("dapui").setup()

		local dap, dapui = require("dap"), require("dapui")
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
