local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local cmd = require('binder.helpers').cmd
  return keys {
    redup = keys {
      prev = b {
        function()
          require('fold-cycle').close()
        end,
        desc = 'open current fold',
      },
      next = b {
        function()
          require('fold-cycle').open()
        end,
        desc = 'open current fold',
      },
    },
    f = keys {
      next = b {
        desc = 'toggle recursively',
        function()
          require('fold-cycle').toggle_all()
        end,
      },
    },
    a = keys {
      prev = b { 'zM', desc = 'close all folds' },
      next = b { 'zR', desc = 'open all folds' },
    },
    l = keys {
      prev = b {
        desc = 'trail backtrack',
        cmd 'TrailBlazerTrackBack',
      },
      next = b {
        desc = 'trail new mark',
        cmd 'TrailBlazerNewTrailMark',
      },
    },
    x = keys {
      next = b {
        desc = 'trail clear',
        cmd 'TrailBlazerDeleteAllTrailMarks',
      },
    },
    z = b {
      desc = 'add spell',
      'zg',
    },
  }
end

return M
