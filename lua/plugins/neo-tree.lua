return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
	},
	lazy = false, -- neo-tree will lazily load itself
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		event_handlers = {
			{
				-- Automatically close the Neotree window when a file is opened
				event = "file_open_requested",
				handler = function()
					require("neo-tree.command").execute({ action = "close" })
				end,
			},
			{
				-- Automatically enable the preview mode when the Neotree window is opened
				event = "after_render",
				handler = function()
					local state = require("neo-tree.sources.manager").get_state("filesystem")
					if not require("neo-tree.sources.common.preview").is_active() then
						state.config = { use_float = false }
						state.commands.toggle_preview(state)
					end
				end,
			},
		},
		filesystem = {
			follow_current_file = {
				enabled = true,
			},
			hijack_netrw_behavior = "open_current",
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = false,
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
				["P"] = {
					"toggle_preview",
					config = {
						use_float = false,
						-- use_image_nvim = true,
						-- title = 'Neo-tree Preview',
					},
				},
			},
		},
	},
}
