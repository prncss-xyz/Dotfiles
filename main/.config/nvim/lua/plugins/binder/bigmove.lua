local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.utils'
  local np = util.np
  local lazy_req = util.lazy_req
  require('key-menu').set('n', 'zb')
  require('key-menu').set('n', 'zp')
  return keys {
    redup = keys {
      redup = b {
        desc = 'harpoon ui',
        lazy_req('harpoon.ui', 'toggle_quick_menu'),
      },
      y = b { desc = 'harpoon add', lazy_req('harpoon.mark', 'add_file') },
      j = b { desc = 'harpoon file 1', lazy_req('harpoon.ui', 'nav_file', 1) },
      k = b { desc = 'harpoon file 2', lazy_req('harpoon.ui', 'nav_file', 2) },
      l = b { desc = 'harpoon file 3', lazy_req('harpoon.ui', 'nav_file', 3) },
      [';'] = b {
        desc = 'harpoon file 4',
        lazy_req('harpoon.ui', 'nav_file', 4),
      },
      [' '] = b {
        desc = 'harpoon command menu',
        lazy_req('harpoon.cmd-ui', 'toggle_quick_menu'),
      },
    },
    -- a = b { desc = 'test file', require('utils.buffers').edit_alt },
    a = b {
      desc = 'test file',
      function()
        require('utils.relative_files').alternative 'test'
      end,
    },
    b = keys {
      desc = 'bookmark',
      a = keys {
        desc = '0',
        prev = b { lazy_req('marks', 'prev_bookmark0') },
        next = b { lazy_req('marks', 'next_bookmark0') },
      },
      s = keys {
        desc = '1',
        prev = b { lazy_req('marks', 'prev_bookmark1') },
        next = b { lazy_req('marks', 'next_bookmark1') },
      },
      d = keys {
        desc = '2',
        prev = b { lazy_req('marks', 'prev_bookmark2') },
        next = b { lazy_req('marks', 'next_bookmark2') },
      },
      f = keys {
        desc = '3',
        prev = b { lazy_req('marks', 'prev_bookmark3') },
        next = b { lazy_req('marks', 'next_bookmark3') },
      },
    },
    d = keys {
      desc = 'unimpaired directory',
      prev = b { '<Plug>(unimpaired-directory-previous)' },
      next = b { '<Plug>(unimpaired-directory-next)' },
    },
    i = keys {
      prev = b { desc = 'declaration', vim.lsp.buf.declaration },
      next = b {
        desc = 'implementations',
        lazy_req('telescope.builtin', 'lsp_implementations'),
      },
    },
    j = b {
      desc = 'type definition',
      lazy_req('telescope.builtin', 'lsp_type_definitions'),
    },
    l = b {
      desc = 'edit playground file',
      require('utils.buffers').edit_playground_file,
    },
    t = np {
      desc = 'trouble',
      prev = lazy_req(
        'trouble',
        'previous',
        { skip_groups = true, jump = true }
      ),
      next = lazy_req('trouble', 'next', { skip_groups = true, jump = true }),
    },
    u = b {
      desc = 'snapshot file',
      function()
        require('utils.relative_files').alternative 'snapshot'
      end,
    },
    v = b {
      desc = 'css file',
      function()
        require('utils.relative_files').alternative 'css'
      end,
    },
    ['.'] = b {
      desc = 'config file',
      function()
        require('utils.relative_files').projection 'config'
      end,
    },
  }
end

return M
