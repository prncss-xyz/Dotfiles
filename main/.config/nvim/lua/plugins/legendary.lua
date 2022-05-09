local M = {}

function M.config()
  require('legendary').setup {
    include_builtin = false,
    auto_register_which_key = false,
  }

  require('legendary').bind_keymap {
    'q',
    ':messages<cr>',
    description = 'caca',
    mode = 'n',
    opts = {},
  }
end

return M
