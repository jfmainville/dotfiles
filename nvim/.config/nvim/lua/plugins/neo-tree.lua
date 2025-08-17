return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{
			mode = "n",
			"<leader>e",
			"<cmd>Neotree toggle<CR>",
			desc = "Toggle the Neotree interface",
		},
	},
	lazy = false, -- neo-tree will lazily load itself
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		enable_diagnostics = false,
		event_handlers = {
			{
				-- Automatically close the Neotree window when a file is opened
				event = "file_open_requested",
				handler = function()
					require("neo-tree.command").execute({ action = "close" })
				end,
			},
		},
		filesystem = {
			follow_current_file = {
				enabled = true,
			},
			hijack_netrw_behavior = "open_current",
			filtered_items = {
				visible = false,
				hide_dotfiles = true,
				hide_gitignored = true,
				hide_hidden = true,
				always_show = {
					".gitignore",
					".env",
					".env.local",
					".env.development.local",
					".env.production.local",
					"environments",
					".pipelines",
					".build",
					"data",
					"reports",
					".pipeline",
					".github",
					".gitlab-ci.yml",
					".config",
					".wezterm.lua",
				},
			},

			use_libuv_file_watcher = true,
			components = {
				-- Show the Harpoon index in the file explorer
				harpoon_index = function(config, node, _)
					local harpoon_list = require("harpoon"):list()
					local path = node:get_id()
					local harpoon_key = vim.uv.cwd()

					for i, item in ipairs(harpoon_list.items) do
						local value = item.value
						if string.sub(item.value, 1, 1) ~= "/" then
							value = harpoon_key .. "/" .. item.value
						end

						if value == path then
							vim.print(path)
							return {
								text = string.format(" ⥤ %d", i), -- <-- Add your favorite harpoon like arrow here
								highlight = config.highlight or "NeoTreeDirectoryIcon",
							}
						end
					end
					return {}
				end,
			},
			renderers = {
				file = {
					{ "icon" },
					{ "name", use_git_status_colors = true },
					{ "harpoon_index" }, --> This is what actually adds the component in where you want it
					{ "diagnostics" },
					{ "git_status", highlight = "NeoTreeDimText" },
				},
			},
		},
		window = {
			mappings = {
				["<Tab>"] = "open",
				["P"] = {
					"toggle_preview",
					config = {
						use_float = false,
						-- use_image_nvim = true,
						-- title = 'Neo-tree Preview',
					},
				},
				["e"] = function()
					vim.api.nvim_exec("Neotree focus filesystem current", true)
				end,
				["b"] = function()
					vim.api.nvim_exec("Neotree focus buffers current", true)
				end,
				["g"] = function()
					vim.api.nvim_exec("Neotree focus git_status current", true)
				end,
			},
		},
	},
}
