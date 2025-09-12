local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.launch_menu = {
    {
        label = 'PoserShell',
        args = { 'powershell.exe', '-NoLogo' },
    },
    {
        label = 'WSL-default',
        args = { 'wsl', '--cd ~' },
    },
    {
        label = "Cmd",
        args = { 'cmd.exe' }
    }
}

config.default_prog = { 'powershell.exe', '-NoLogo' }

-------------------- color (scheme)--------------------
-- config.color_scheme = 'tokyonight_moon'
-- config.color_scheme = 'Aci (Gogh)'
-- config.color_scheme = 'Afterglow'
-- config.color_scheme = 'Afterglow (Gogh)'
-- config.color_scheme = 'Ayu Mirage'
-- config.color_scheme = 'Ayu Mirage (Gogh)'
config.color_scheme = 'Sonokai (Gogh)'
-- config.color_scheme = 'OneHalfDark'
-- config.color_scheme = 'Everforest Dark Hard (Gogh)'
-- config.color_scheme = 'Everforest Dark Medium (Gogh)'
-- config.color_scheme = 'Everforest Dark Soft (Gogh)'

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
    left = 0,
    right = 5,
    top = 0,
    bottom = 0,
}
config.initial_cols = 140
config.initial_rows = 30
config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
}

config.use_fancy_tab_bar = true
config.tab_max_width = 10
config.enable_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

-------------------- font --------------------
-- config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font = wezterm.font_with_fallback({
    -- "JetBrainsMono Nerd Font", -- main font
    "Maple Mono NF CN",
    -- "FiraCode Nerd Font Mono",
    "Segoe UI Emoji",   -- Windows Emoji fallback
    "Noto Color Emoji", -- Linux Emoji fallback
})
config.font_size = 14


-------------------- Keymap --------------------
local act = wezterm.action
config.leader = { key = 'a', mods = 'ALT', timeout_milliseconds = 1000 }
config.keys = {
    { key = 'q',          mods = 'LEADER',     action = act.QuitApplication },

    { key = 'h',          mods = 'LEADER',     action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'v',          mods = 'LEADER',     action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'q',          mods = 'ALT',        action = act.CloseCurrentPane { confirm = false } },

    { key = 'LeftArrow',  mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow',  mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Down' },

    -- CTRL + T create default Tab
    { key = 't',          mods = 'CTRL',       action = act.SpawnTab 'DefaultDomain' },
    -- CTRL + W close current Tab
    { key = 'w',          mods = 'CTRL',       action = act.CloseCurrentTab { confirm = false } },

    -- CTRL + SHIFT + 1 Create WSL Tab
    {
        key = '!',
        mods = 'CTRL|SHIFT',
        action = act.SpawnCommandInNewTab {
            domain = 'DefaultDomain',
            args = { 'wsl', '--cd ~' },
        }
    },
    {
        key = '#',
        mods = 'CTRL|SHIFT',
        action = act.SpawnCommandInNewTab {
            args = { 'cmd' },
        }
    },
    {
        key = '@',
        mods = 'CTRL|SHIFT',
        action = act.SpawnCommandInNewTab {
            domain = 'DefaultDomain',
            args = { 'powershell', '-NoLogo' },
        }
    }
}

for i = 1, 8 do
    -- CTRL + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'CTRL',
        action = act.ActivateTab(i - 1),
    })
end

-------------------- Mouse Action --------------------
config.mouse_bindings = {
    -- copy the selection
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        action = act.CompleteSelection 'ClipboardAndPrimarySelection',
    },

    -- Open HyperLink
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.OpenLinkAtMouseCursor,
    },
}

-------------------- Window Centering --------------------
wezterm.on("gui-startup", function(cmd)
    local screen = wezterm.gui.screens().active
    local width, height = screen.width * 0.5, screen.height * 0.5
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {
        position = {
            x = (screen.width - width) / 2,
            y = (screen.height - height) / 2,
            origin = { Named = screen.name }
        }
    })
    window:gui_window():set_inner_size(width, height)
end)

-- -------------------- Background --------------------
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10
-- config.background = {
--   {
--     source = {
--       File = 'image/path/here',
--     },
--   }
-- }

return config
