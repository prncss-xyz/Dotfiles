local M = {}

function M.config()
  require('dressing').setup {
    input = {
      prefer_width = 70,
    },
  }
end

return M
