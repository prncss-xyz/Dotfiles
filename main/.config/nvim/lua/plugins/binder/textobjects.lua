local M = {}

function M.setup()
  local d = require('plugins.binder.parameters').d
  local util = require 'plugins.binder.util'
  local alt = util.alt
  local cmd = util.cmd
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  binder.bind(modes {
    ox = keys {
      hu = b {
        desc = 'ts hint',
        'lua require("tsht").nodes()',
        cmd = true,
      },
      au = b {
        desc = 'ts unit outer',
        'lua require("treesitter-unit").select(true)',
        cmd = true,
      },
      iu = b {
        desc = 'ts unit inner',
        'lua require("treesitter-unit").select(false)',
        cmd = true,
      },
    },
  })
end

return M
