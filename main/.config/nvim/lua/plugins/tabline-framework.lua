local M = {}

function M.config()
  local render = function(f)
    f.add { ' ', fg = '#bb0000' }
    f.add ' '
  end

  require('tabline_framework').setup { render = render }
end

return M
