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
  return binder.bind(modes, {
    ox = keys {
      [','] = b {
        'lua require("tsht").nodes()',
        cmd = true,
      },
      au = b {
        'lua require("treesitter-unit").select(true)',
        cmd = true,
      },
    },
    o = {
      keys = {
        iu = b {
          'lua require("nvim-treesitter.textobjects.select").select_textobject("@node", "o")',
          cmd = true,
        },
      },
    },
    x = {
      keys = {
        iu = b {
          'lua require("nvim-treesitter.textobjects.select").select_textobject("@node", "x")',
          cmd = true,
        },
      },
    },
  })
end
