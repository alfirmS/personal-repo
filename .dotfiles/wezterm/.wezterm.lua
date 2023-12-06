local config = {}
local wezterm = require 'wezterm'

local dimmer = { brightness = 0.2 }

config.enable_scroll_bar = true
config.min_scroll_bar_height = '2cell'


-- Config Leader Button
config.leader = {
  key = 'b',
  mods = 'CTRL'
}

-- Default user used
config.default_prog = { "wsl", "-d", "Archlinux", "-u", "devops", "--cd", "~" }

-- Default wezterm open terminal
config.default_domain = 'WSL:Archlinux'

-- Color and Appearance Configuration
config.color_scheme = 'Catppuccin Mocha'
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
  left = 6,
  right = 6,
  top = 6,
  bottom = 6,
}

config.colors = {
  ansi = {
    '#8e94a8',
    '#ffb3bb',
    '#d6e0c4',
    '#f7ebc7',
    '#aad2f2',
    '#eccdf2',
    '#b5e4ee',
    '#ccd2d9',
  },
  brights = {
    '#545862',
    '#e06c75',
    '#98c379',
    '#e5c07b',
    '#61afef',
    '#c678dd',
    '#56b6c2',
    '#c8ccd4',
  },
  split = '#6272a4',

  scrollbar_thumb = 'white',
}
config.background = {

  -- This is the deepest/back-most layer. It will be rendered first
  {
    source = {
      File = 'C:/Users/sholeh.firmansyah/Pictures/Backgrounds/spaceship_bg_3@2x.png',
    },
    -- The texture tiles vertically but not horizontally.
    -- When we repeat it, mirror it so that it appears "more seamless".
    -- An alternative to this is to set `width = "100%"` and have
    -- it stretch across the display
    repeat_x = 'Mirror',
    hsb = dimmer,
    -- When the viewport scrolls, move this layer 10% of the number of
    -- pixels moved by the main viewport. This makes it appear to be
    -- further behind the text.
    attachment = { Parallax = 0.1 },
  },
  -- Subsequent layers are rendered over the top of each other
  {
    source = {
      File = 'C:/Users/sholeh.firmansyah/Pictures/Overlays/overlay_1_spines.png',
      -- File = 'C:/Users/sholeh.firmansyah/Pictures/luffy.png',
    },
    width = '100%',
    repeat_x = 'NoRepeat',

    -- position the spins starting at the bottom, and repeating every
    -- two screens.
    vertical_align = 'Bottom',
    repeat_y_size = '200%',
    hsb = dimmer,

    -- The parallax factor is higher than the background layer, so this
    -- one will appear to be closer when we scroll
    attachment = { Parallax = 0.2 },
  },
  {
    source = {
      File = 'C:/Users/sholeh.firmansyah/Pictures/Overlays/overlay_2_alienball.png',
    },
    width = '100%',
    repeat_x = 'NoRepeat',

    -- start at 10% of the screen and repeat every 2 screens
    vertical_offset = '10%',
    repeat_y_size = '200%',
    hsb = dimmer,
    attachment = { Parallax = 0.3 },
  },
  {
    source = {
      File = 'C:/Users/sholeh.firmansyah/Pictures/Overlays/overlay_3_lobster.png',
    },
    width = '100%',
    repeat_x = 'NoRepeat',

    vertical_offset = '30%',
    repeat_y_size = '200%',
    hsb = dimmer,
    attachment = { Parallax = 0.4 },
  },
  {
    source = {
      -- File = 'C:/Users/sholeh.firmansyah/Pictures/Overlays/overlay_4_spiderlegs.png',
      File = 'C:/Users/sholeh.firmansyah/Pictures/daco.png',
    },
    width = '100%',
    repeat_x = 'NoRepeat',

    vertical_offset = '20%',
    repeat_y_size = '150%',
    hsb = {
      hue = 0,
      saturation = 0.5,
      brightness = 0.09,
    },
    attachment = { Parallax = 0.5 },
  },
}

config.window_frame = {
  inactive_titlebar_bg = '#353535',
  active_titlebar_bg = '#1A132F',
  inactive_titlebar_fg = '#cccccc',
  active_titlebar_fg = '#ffffff',
  inactive_titlebar_border_bottom = '#1A132F',
  active_titlebar_border_bottom = '#1A132F',
  button_fg = '#cccccc',
  button_bg = '#1A132F',
  button_hover_fg = '#ffffff',
  button_hover_bg = '#1A132F',
  border_left_width = '0.5cell',
  border_right_width = '0.5cell',
  border_bottom_height = '0.25cell',
  border_top_height = '0.25cell',
  border_left_color = 'black',
  border_right_color = 'black',
  border_bottom_color = 'black',
  border_top_color = 'black',
}

-- config.window_background_image = 'C:/Users/sholeh.firmansyah/Pictures/one_piece2.jpeg'
-- config.window_background_image_hsb = {
--   -- Darken the background image by reducing it to 1/3rd
--   brightness = 0.1,
--
--   -- You can adjust the hue by scaling its value.
--   -- a multiplier of 1.0 leaves the value unchanged.
--   hue = 1.0,
--
--   -- You can adjust the saturation also.
--   saturation = 1.0,
-- }

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.3,
}

-- Key Binding Configuration
config.keys = {
  {
    key = 'n',
    mods = 'SHIFT|LEADER',
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action.SpawnWindow,
  },
  {
    key = "a",
    mods = "LEADER|CTRL",
    action = wezterm.action.SendString "\x01"
  },
  {
    key = "v",
    mods = "LEADER",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
  },
  {
    key = "\\",
    mods = "LEADER",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
  },
  {
    key = "z",
    mods = "LEADER",
    action = wezterm.action.TogglePaneZoomState
  },
  {
    key = "u",
    mods = "LEADER",
    action = wezterm.action.SpawnTab "CurrentPaneDomain"
  },
  {
    key = "j",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection "Left"
  },
  {
    key = "k",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection "Down"
  },
  {
    key = "i",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection "Up"
  },
  {
    key = "l",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection "Right"
  },
  {
    key = "H",
    mods = "LEADER|SHIFT",
    action = wezterm.action.AdjustPaneSize { "Left", 5 }
  },
  {
    key = "e",
    mods = "LEADER|SHIFT",
    action = wezterm.action.CloseCurrentTab { confirm = true }
  },
  {
    key = "1",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(0)
  },
  {
    key = "2",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(1)
  },
  {
    key = "3",
    mods = "LEADER",
    action = wezterm.action.ActivateTab(2)
  },
}

config.display_pixel_geometry = "BGR"

config.font_size = 9.0
config.line_height = 1.0
config.cell_width = 1.0

config.window_decorations = "RESIZE"

config.audible_bell = "Disabled"

return config
