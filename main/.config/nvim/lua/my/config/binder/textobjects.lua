local M = {}

function M.setup()
  local d = require('my.config.binder.parameters').d
  local utils = require 'my.config.binder.utils'
  local alt = utils.alt
  local cmd = utils.cmd
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  require('key-menu').set('x', 'i')
  require('key-menu').set('x', 'o')
  require('key-menu').set('o', 'i')
  require('key-menu').set('o', 'o')
  binder.bind(modes {
    ox = keys {
      hu = b {
        desc = 'ts hint',
        'lua require("tsht").nodes()',
        cmd = true,
      },
      aU = b {
        desc = 'ts unit outer',
        'lua require("treesitter-unit").select(true)',
        cmd = true,
      },
      iU = b {
        desc = 'ts unit inner',
        'lua require("treesitter-unit").select(false)',
        cmd = true,
      },
    },
  })
end

return M
