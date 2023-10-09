local M = {}

M.path = '.config/kitty/theme.conf'
M.contents = [[
    background = #{{background}}
    foreground = #{{foreground}}
    selection_background = #{{selection_background}}
    selection_foreground = #{{selection_foreground}}
    cursor = #{{cursor}}
    {{#term}}
    color{{index}} #{{value}}
    {{/term}}
  ]]

return M
