-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.color_scheme = "Catppuccin Mocha"
config.colors = {
	foreground = "#fff",
	background = "#1C1C1C",

	-- foreground = "#ecdef4",
	-- background = "#010c18",

	cursor_bg = "#38ff9d",
	cursor_border = "#38ff9d",
	cursor_fg = "#000000",
	selection_bg = "#38ff9c",
	selection_fg = "#000000",
	ansi = { "#0b3b61", "#ff3a3a", "#52ffd0", "#fff383", "#1376f9", "#c792ea", "#ff5ed4", "#16fda2" },
	brights = { "#63686d", "#ff54b0", "#74ffd8", "#fcf5ae", "#388eff", "#ae81ff", "#ff6ad7", "#60fbbf" },
}

config.font = wezterm.font("Iosevka Nerd Font", { italic = false })
config.hide_tab_bar_if_only_one_tab = true

config.enable_scroll_bar = false
config.window_padding = {
	top = "20",
	left = "0",
	right = "0",
	bottom = "0",
}
config.default_cursor_style = "BlinkingBar"
config.font_size = 20
config.window_decorations = "RESIZE"

-- transparant and blur background
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.font = wezterm.font("Iosevka Nerd Font", { weight = "Regular", style = "Normal" })

return config
