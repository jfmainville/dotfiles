local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Launch the WSL:Ubuntu command line tool if on Windows
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_domain = "WSL:Ubuntu"
	config.font_size = 12.0
elseif wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
	config.default_domain = "local"
	config.font_size = 14.0
	-- Need to add this line to send composed key when left alt is pressed
	config.send_composed_key_when_left_alt_is_pressed = true
	-- Need to add this line to send composed key when right alt is pressed
	config.send_composed_key_when_right_alt_is_pressed = true
end

-- Customizations
config.default_cwd = wezterm.home_dir
config.font = wezterm.font("JetBrains Mono")
config.color_scheme = "tokyonight_storm"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 64
config.enable_scroll_bar = false

-- Keymaps
local act = wezterm.action
config.keys = {
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "'", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = ".", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },
	{ key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "h", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "l", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
	{ key = "1", mods = "CTRL", action = act.ActivateTab(0) },
	{ key = "2", mods = "CTRL", action = act.ActivateTab(1) },
	{ key = "3", mods = "CTRL", action = act.ActivateTab(2) },
	{ key = "4", mods = "CTRL", action = act.ActivateTab(3) },
	{ key = "5", mods = "CTRL", action = act.ActivateTab(4) },
	{ key = "6", mods = "CTRL", action = act.ActivateTab(5) },
	{ key = "7", mods = "CTRL", action = act.ActivateTab(6) },
	{ key = "8", mods = "CTRL", action = act.ActivateTab(7) },
	{
		key = "X",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
}

return config
