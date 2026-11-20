return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()
		require("nvim-dap-virtual-text").setup()

		dap.listeners.before.attach.dapui_config = dapui.open
		dap.listeners.before.launch.dapui_config = dapui.open
		dap.listeners.before.event_terminated.dapui_config = dapui.close
		dap.listeners.before.event_exited.dapui_config = dapui.close

		-- Adapters installed by mason.lua
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = { command = "js-debug-adapter", args = { "${port}" } },
		}
		dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]
		dap.adapters.delve = {
			type = "server",
			port = "${port}",
			executable = { command = "dlv", args = { "dap", "-l", "127.0.0.1:${port}" } },
		}
		dap.adapters.python = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter",
		}

		local js_launch = { request = "launch", cwd = "${workspaceFolder}", sourceMaps = true }
		dap.configurations.javascript = {
			vim.tbl_extend("force", js_launch, { type = "pwa-node", name = "Node: launch file", program = "${file}" }),
			vim.tbl_extend("force", js_launch, {
				type = "pwa-chrome",
				name = "Chrome: launch localhost:3000",
				url = "http://localhost:3000",
				webRoot = "${workspaceFolder}",
			}),
		}
		dap.configurations.typescript = dap.configurations.javascript

		dap.configurations.go = {
			{ type = "delve", request = "launch", name = "Go: debug package", program = "${fileDirname}" },
			{
				type = "delve",
				request = "launch",
				mode = "test",
				name = "Go: test package",
				program = "${fileDirname}",
			},
		}

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Python: launch file",
				program = "${file}",
				pythonPath = function()
					return vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python3"
				end,
			},
		}

		dap.adapters.ansibug = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/ansibug-venv/bin/python",
			args = { "-m", "ansibug", "dap" },
		}
		dap.adapters.bashdb = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/bin/bash-debug-adapter",
		}
		local bash_launch = {
			type = "bashdb",
			request = "launch",
			name = "Bash: launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		}
		dap.configurations.sh = { bash_launch }
		dap.configurations.bash = { bash_launch }

		dap.configurations["yaml.ansible"] = {
			{
				type = "ansibug",
				request = "launch",
				name = "Ansible: launch playbook",
				playbook = "${file}",
				cwd = "${workspaceFolder}",
			},
		}

		local keymaps = {
			{ "<leader>bb", dap.toggle_breakpoint, "Toggle breakpoint" },
			{
				"<leader>bB",
				function()
					dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				"Conditional breakpoint",
			},
			{ "<leader>bc", dap.continue, "Start or continue" },
			{ "<leader>bi", dap.step_into, "Step into" },
			{ "<leader>bo", dap.step_over, "Step over" },
			{ "<leader>bO", dap.step_out, "Step out" },
			{ "<leader>bl", dap.run_last, "Run last" },
			{ "<leader>br", dap.repl.toggle, "Toggle REPL" },
			{ "<leader>bt", dap.terminate, "Terminate session" },
			{ "<leader>bu", dapui.toggle, "Toggle UI" },
			{ "<leader>be", dapui.eval, "Evaluate expression" },
		}
		for _, keymap in ipairs(keymaps) do
			vim.keymap.set("n", keymap[1], keymap[2], { desc = "DAP: " .. keymap[3] })
		end
	end,
}
