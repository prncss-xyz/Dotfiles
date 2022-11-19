local M = {}

function M.config()
  require('legendary').setup {
    include_builtin = false,
    which_key = {
      auto_register = false,
    },
  }
end

return M
