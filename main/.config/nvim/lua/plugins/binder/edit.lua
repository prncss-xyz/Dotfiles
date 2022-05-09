local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local lazy_req = require('plugins.binder.util').lazy_req

  return keys {
    e = b { desc = 'swap', '<Plug>(flies-swap)', modes = 'nx' },
    -- x = keys {
    --   next = b {
    --     desc = 'exchange',
    --     '<Plug>(ExchangeClear)',
    --     modes = 'nx',
    --   },
    --   prev = b {
    --     desc = 'exchange',
    --     '<Plug>(Exchange)',
    --     modes = 'nx',
    --   },
    -- },
    x = b {
      desc = 'swipe',
      '<Plug>(flies-swipe)',
      modes = 'nx',
    },
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

local function caca(asdf)
  print (1)
end

return M
