local wezterm = require('wezterm')
local act = wezterm.action
local mux = wezterm.mux

-- Functions to help determine the OS
local function is_macos()
    return wezterm.target_triple == "x86_64-apple-darwin" or
        wezterm.target_triple == "aarch64-apple-darwin"
end
local function is_linux()
    return wezterm.target_triple == "x86_64-unknown-linux-gnu"
end
local function is_winos()
    return wezterm.target_triple == "x86_64-pc-windows-msvc"
end

-- Function to center the window
local function center_window(window)
    local window_dims = window:get_dimensions()
    local window_width = window_dims.pixel_width
    local window_height = window_dims.pixel_height
    local screen = wezterm.gui.screens().active
    local max_width = screen.width
    local max_height = screen.height
    local x = (max_width - window_width) / 2
    -- local y = 0
    local y = (max_height - window_height) / 2
    window:set_position(x, y)
end

-- Event handler for window creation
wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window {}
    
    -- Linux using wayland doesn't allow for repositioning
    if not is_linux() then
        wezterm.sleep_ms(50)
        center_window(window:gui_window())
    end
end)

-- Catppuccin color palette (mocha flavor)
local catppuccin = {
    rosewater = "#f5e0dc",
    flamingo = "#f2cdcd",
    pink = "#f5c2e7",
    mauve = "#cba6f7",
    red = "#f38ba8",
    maroon = "#eba0ac",
    peach = "#fab387",
    yellow = "#f9e2af",
    green = "#a6e3a1",
    teal = "#94e2d5",
    sky = "#89dceb",
    sapphire = "#74c7ec",
    blue = "#89b4fa",
    lavender = "#b4befe",
    text = "#cdd6f4",
    subtext1 = "#bac2de",
    subtext0 = "#a6adc8",
    overlay2 = "#9399b2",
    overlay1 = "#7f849c",
    overlay0 = "#6c7086",
    surface2 = "#585b70",
    surface1 = "#45475a",
    surface0 = "#313244",
    base = "#1e1e2e",
    mantle = "#181825",
    crust = "#11111b",
}

-- Base configuration
local config = {
    -- font = wezterm.font("JetBrainsMono Nerd Font"),
    font = wezterm.font("FiraCode Nerd Font Mono"),
    font_size = 13.0,
    color_scheme = "Catppuccin Mocha", -- Mocha, Macchiato, Frappe, Latte
    initial_cols = 120,
    initial_rows = 45,
    window_background_opacity = 0.95,
    window_padding = {
        left = '1cell',
        right = '1cell',
        top = '0.5cell',
        bottom = '0.5cell',
    },
    window_decorations = "TITLE|RESIZE",

    -- Tab bar configuration
    use_fancy_tab_bar = false,
    tab_bar_at_bottom = false,
    hide_tab_bar_if_only_one_tab = true,
    tab_max_width = 25,
    colors = {
        tab_bar = {
            background = catppuccin.crust,
            active_tab = {
                bg_color = catppuccin.base,
                fg_color = catppuccin.text,
            },
            inactive_tab = {
                bg_color = catppuccin.mantle,
                fg_color = catppuccin.subtext0,
            },
            inactive_tab_hover = {
                bg_color = catppuccin.surface0,
                fg_color = catppuccin.text,
            },
            new_tab = {
                bg_color = catppuccin.surface0,
                fg_color = catppuccin.text,
            },
            new_tab_hover = {
                bg_color = catppuccin.surface1,
                fg_color = catppuccin.text,
            },
        },
    },

}

-- Set modifier keys based on OS
local mods = is_macos() and "SHIFT|CMD" or "SHIFT|CTRL"

-- Key bindings
local keys = {
    -- General
    { key = "T", mods = "CTRL",       action = act.SpawnTab("DefaultDomain") },
    { key = "~", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
    { key = "P", mods = mods,         action = wezterm.action.ActivateCommandPalette },
    -- Pane splitting
    { key = "-", mods = mods,         action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "|", mods = mods,         action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Pane navigation
    { key = "h", mods = mods,         action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = mods,         action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = mods,         action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = mods,         action = act.ActivatePaneDirection("Down") },
}

-- OS-specific configurations
if is_macos() then
    wezterm.log_info("Applying macOS configuration")
    config.font_size = 13.0
elseif is_linux() then
    wezterm.log_info("Applying Linux configuration")
    config.font_size = 12.0
    config.enable_wayland = true
elseif is_winos() then
    wezterm.log_info("Applying Windows configuration")
else
    wezterm.log_warning("Unknown OS, using default configuration")
end

-- Apply the keys to the config
config.keys = keys

return config
