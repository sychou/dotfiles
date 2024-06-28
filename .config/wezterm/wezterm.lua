local wezterm = require('wezterm')
local act = wezterm.action
local mux = wezterm.mux

-- Detect the current operating system
local function is_mac()
  return wezterm.target_triple == "x86_64-apple-darwin" or
         wezterm.target_triple == "aarch64-apple-darwin"
end

local function is_linux()
  return wezterm.target_triple == "x86_64-unknown-linux-gnu"
end

local function is_windows()
  return wezterm.target_triple == "x86_64-pc-windows-msvc"
end

-- Function to center the window (unchanged)
local function center_window(window, max_width, max_height)
  local window_dims = window:get_dimensions()
  local window_width = window_dims.pixel_width
  local window_height = window_dims.pixel_height
  local x = (max_width - window_width) / 2
  local y = (max_height - window_height) / 2
  window:set_position(x, y)
end

-- Event handler for window creation (unchanged)
wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  local screen = wezterm.gui.screens()[1]
  local max_width = screen.width
  local max_height = screen.height
  window:gui_window():maximize()
  wezterm.sleep_ms(10)
  center_window(window:gui_window(), max_width, max_height)
end)

-- Base configuration
local config = {
  font = wezterm.font("FiraCode Nerd Font Mono"),
  font_size = 13.0,
  color_scheme = "nord",
  initial_cols = 120,
  initial_rows = 60,
  window_background_opacity = 0.95,
  hide_tab_bar_if_only_one_tab = true,
}

-- Set modifier keys based on OS
local mods = is_mac() and "SHIFT|CMD" or "SHIFT|CTRL"

-- Key bindings
local keys = {
  -- Global keys
  { key = "T", mods = "CTRL", action = act.SpawnTab("DefaultDomain") },
  { key = "P", mods = mods, action = wezterm.action.ActivateCommandPalette },
  -- Pane splitting
  { key = "-", mods = mods, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "|", mods = mods, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  -- Pane navigation
  { key = "h", mods = mods, action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = mods, action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = mods, action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = mods, action = act.ActivatePaneDirection("Down") },
}


-- OS-specific configurations
if is_mac() then
  wezterm.log_info("Applying macOS configuration")
  config.font_size = 13.0
  -- Placeholder for more macOS-specific configs
  -- config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"
  -- config.macos_window_background_blur = 20
elseif is_linux() then
  wezterm.log_info("Applying Linux configuration")
  -- config.enable_wayland = true
  -- config.enable_csi_u_key_encoding = true
  -- config.term = "xterm-256color"
elseif is_windows() then
  wezterm.log_info("Applying Windows configuration")
  -- config.default_prog = { "pwsh.exe", "-NoLogo" }
  -- config.win32_system_backdrop = "Acrylic"
  -- config.win32_acrylic_opacity = 0.8
else
  wezterm.log_warning("Unknown OS, using default configuration")
end

-- Apply the keys to the config
config.keys = keys

return config
