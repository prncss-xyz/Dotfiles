local M = {}

function M.config()
  require('legendary').setup {
    include_builtin = false,
    auto_register_which_key = false,
  }
end

return M
