local M = {}

local function portal_builtin(name, opts)
  local keys = require('binder').keys
  local b = require('binder').b
  return keys {
    desc = name,
    prev = b {
      function()
        require('portal.builtin')[name].tunnel_forward(opts)
      end,
    },
    next = b {
      function()
        require('portal.builtin')[name].tunnel_backward(opts)
      end,
    },
  }
end

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local d = require('my.config.binder.parameters').d
  local util = require 'my.config.binder.utils'
  local lazy_req = util.lazy_req
  return keys {
    redup = keys {
      desc = 'side locations',
      a = b {
        desc = 'select',
        'req',
        'edgy',
        'select',
      },
      b = b {
        desc = 'buffers',
        'vim',
        'cmd',
        'Neotree buffers',
      },
      f = b {
        desc = 'neo-tree',
        'vim',
        'cmd',
        'Neotree',
      },
      g = b {
        desk = 'hunks',
        lazy_req('my.utils.ui_toggle', 'activate', 'trouble', function()
          vim.cmd 'Gitsigns setqflist'
          vim.cmd 'Trouble quickfix'
        end),
      },
      h = b {
        desc = 'neo-tree git',
        'vim',
        'cmd',
        'Neotree git_status',
      },
      n = b {
        desc = 'zk',
        'vim',
        'cmd',
        'Neotree source=neo-tree-zk',
      },
      l = b {
        desk = 'bookmarks',
        lazy_req('my.utils.ui_toggle', 'activate', 'trouble', function()
          require('marks').bookmark_state:all_to_list 'quickfixlist'
          vim.cmd 'Trouble quickfix'
        end),
      },
      r = b {
        desc = 'references',
        'vim',
        'cmd',
        'Trouble lsp_references',
      },
      s = b {
        desc = 'neotree symbols',
        'vim',
        'cmd',
        'Neotree document_symbols',
      },
      w = b {
        desc = 'todo',
        'vim',
        'cmd',
        'Trouble todo',
      },
      x = b {
        desc = 'ui close',
        'req',
        'edgy',
        'close',
      },
      z = b {
        desc = 'diagnostics',
        'vim',
        'cmd',
        'Trouble diagnostics',
      },
      [d.search] = b {
        desc = 'search',
        'vim',
        'cmd',
        'GrugFar',
      },
    },
    a = b {
      desc = 'test file',
      'req',
      'my.utils.relative_files',
      'alternative',
      'test',
    },
    e = portal_builtin 'buffstory',
    c = b { desc = 'snippets', 'req', 'my.utils.snippets', 'edit' },
    d = keys {
      desc = 'unimpaired directory',
      prev = b { '<Plug>(unimpaired-directory-previous)' },
      next = b { '<Plug>(unimpaired-directory-next)' },
    },
    g = b { desc = 'last buffer', 'req', 'buffstory', 'last' },
    k = b { desc = 'terminal zk', 'req', 'my.utils.terminal', 'terminal', 'zk' },
    l = b { desc = 'terminal zl', 'req', 'my.utils.terminal', 'terminal', 'zl' },
    n = b { desc = 'follow filename', 'gf' },
    s = b {
      desc = 'snapshot file',
      'req',
      'my.utils.relative_files',
      'alternative',
      'snapshot',
    },
    v = b {
      desc = 'css file',
      'req',
      'my.utils.relative_files',
      'alternative',
      'css',
    },
    x = b {
      desc = 'edit playground file',
      'req',
      'my.utils.buffers',
      'edit_playground_file',
    },
    ['.'] = b {
      desc = 'config file',
      'my.utils.relative_files',
      'projection',
      'config',
    },
  }
end

return M
