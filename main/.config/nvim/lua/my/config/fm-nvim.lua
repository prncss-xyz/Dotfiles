local M = {}

function M.config()
  require 'fm-nvim'.setup {
    ui = {
      default = 'split',
      split = {
        direction = 'leftabove',
        size = require 'my.parameters'.pane_width
      }
    }
  }
end

return M
