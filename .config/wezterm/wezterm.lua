local wezterm = require 'wezterm';

-- https://wezfurlong.org/wezterm/config/lua/general.html

return {
  -- font = wezterm.font("FiraCode Nerd Font"),
  font = wezterm.font("JetBrainsMono Nerd Font Mono"),
  font_size = 16,
  colors = {
    cursor_bg = "#FFF",
    cursor_fg = "#000",
    cursor_border = "#FFF",
  },
  adjust_window_size_when_changing_font_size = false,

  enable_tab_bar = false,

}
