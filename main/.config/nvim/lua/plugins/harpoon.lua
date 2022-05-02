local M = {}

function M.config()
  require('harpoon').setup {
    global_settings = {
      save_on_toggle = true,
      enter_on_sendcmd = true,
    },
    projects = {
      ['$DOTFILES'] = {
        term = {
          cmds = {
            'ls',
          },
        },
      },
    },
  }
end

function M.bindings()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local util = require 'plugins.binder.util'
  local lazy_req = util.lazy_req
  return {
    bigmove = keys {
      redup = b { desc = 'ui', lazy_req('harpoon.ui', 'toggle_quick_menu') },
      n = b { desc = 'next', lazy_req('harpoon.ui', 'nav_next') },
      p = b { desc = 'previous', lazy_req('harpoon.ui', 'nav_prev') },
      y = b { desc = 'add', lazy_req('harpoon.mark', 'add_file') },
      a = b { desc = 'file 1', lazy_req('harpoon.ui', 'nav_file', 1) },
      s = b { desc = 'file 2', lazy_req('harpoon.ui', 'nav_file', 2) },
      d = b { desc = 'file 3', lazy_req('harpoon.ui', 'nav_file', 3) },
      f = b { desc = 'file 4', lazy_req('harpoon.ui', 'nav_file', 4) },
      j = b { desc = 'terminal 1', lazy_req('harpoon.term', 'gotoTerminal', 1) },
      k = b { desc = 'terminal 2', lazy_req('harpoon.term', 'gotoTerminal', 2) },
      l = b { desc = 'terminal 3', lazy_req('harpoon.term', 'gotoTerminal', 3) },
      [';'] = b {
        desc = 'terminal 4',
        lazy_req('harpoon.term', 'gotoTerminal', 4),
      },
      [' '] = b {
        desc = 'command menu',
        lazy_req('harpoon.cmd-ui', 'toggle_quick_menu'),
      },
    },
  }
end

return M
