local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local lazy_req = require('plugins.binder.util').lazy_req

  return keys {
    v = modes {
      n = keys {
        prev = b { 'P' },
        next = b { 'p' },
      },
      ox = keys {
        prev = b {
          function()
            local rs = '"' .. vim.v.register
            require('bindutils').keys('"_d' .. rs .. 'P')
          end,
        },
        next = b {
          function()
            local rs = '"' .. vim.v.register
            require('bindutils').keys('"_d' .. rs .. 'P')
          end,
        },
      },
    },
  }
end

return M
