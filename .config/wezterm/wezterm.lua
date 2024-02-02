-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"
config.colors = {
	foreground = "#fff",
	background = "#1C1C1C",
}

config.font = wezterm.font("Iosevka Nerd Font", { italic = false })
config.hide_tab_bar_if_only_one_tab = true

config.enable_scroll_bar = false
config.window_padding = {
	left = "0",
	right = "0",
	top = "0",
	bottom = "0",
}
config.cell_width = 1.01

return config
