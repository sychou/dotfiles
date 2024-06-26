local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():set_position(0, 547)
end)

config = {
  font = wezterm.font("FiraCode Nerd Font Mono"),
  font_size = 13.0,
  color_scheme = "nord",
  initial_cols = 182,
  initial_rows = 40,
  window_background_opacity = 0.95,
  hide_tab_bar_if_only_one_tab = true
}

return config
