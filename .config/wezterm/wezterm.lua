local wezterm = require 'wezterm';

-- https://wezfurlong.org/wezterm/config/lua/general.html

return {
  -- font = wezterm.font("FiraCode Nerd Font"),
  -- Primary font sets cell metrics + normal glyphs; the herdr-radar icon font
  -- supplies the agent vendor logos (U+E1A0-E1B3, U+E1C0-E1C5).
  font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font Mono",
    "Herdr Agent Icons Max",
  }),
  underline_position = -3,
  underline_thickness = 2,
  font_size = 16,
  colors = {
    cursor_bg = "#FFF",
    cursor_fg = "#000",
    cursor_border = "#FFF",
  },
  adjust_window_size_when_changing_font_size = false,

  enable_tab_bar = false,

  window_decorations = "RESIZE",
}
