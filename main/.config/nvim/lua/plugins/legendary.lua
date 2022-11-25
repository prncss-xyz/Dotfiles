local M = {}

function M.config()
  require('legendary').setup {
    include_builtin = false,
  }
end

return M
