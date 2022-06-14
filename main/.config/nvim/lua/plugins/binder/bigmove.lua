local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local util = require 'plugins.binder.util'
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
    a = b { desc = 'edit alt', require('plugins.binder.actions').edit_alt },
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
    -- FIXME:
    e = b {
      desc = 'node modules',
      lazy_req('telescope', 'extensions.my.node_modules'),
    },
    f = keys {
      next = b {
        desc = 'file (recursive)',
        function()
          require('telescope.builtin').find_files {
            cwd = vim.fn.expand('%:p:h', nil, nil),
          }
        end,
      },
      prev = b {
        desc = 'file (current)',
        function()
          require('telescope.builtin').find_files {
            cwd = vim.fn.expand('%:p:h', nil, nil),
            find_command = { 'fd', '--type', 'f', '-d', '1' },
          }
        end,
      },
    },
    g = b { desc = 'buffers', lazy_req('telescope.builtin', 'buffers') },
    h = b {
      desc = 'recent buffer',
      lazy_req('buffstory', 'select'),
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
    n = b {
      desc = 'project files',
      require('plugins.binder.actions').project_files,
    },
    m = b {
      desc = 'plugins',
      lazy_req('telescope', 'extensions.my.installed_plugins'),
    },
    o = b {
      desc = 'oldfiles',
      lazy_req('telescope.builtin', 'oldfiles', { only_cwd = true }),
    },
    p = b {
      desc = 'edit playground file',
      require('plugins.binder.actions').edit_playground_file,
    },
    r = keys {
      prev = b {
        desc = 'trouble references',
        ':Trouble lsp_references<cr>',
      },
      next = b {
        desc = 'telescope references',
        function()
          require('telescope.builtin').lsp_references {}
        end,
      },
    },
    t = np {
      desc = 'quickfix',
      prev = lazy_req(
        'trouble',
        'previous',
        { skip_groups = true, jump = true }
      ),
      next = lazy_req('trouble', 'next', { skip_groups = true, jump = true }),
    },
    w = b {
      desc = 'todo',
      lazy_req('telescope', 'extensions.todo-comments.todo'),
    },
    ['é'] = keys {
      prev = b {
        desc = 'live grep local',
        function()
          require('telescope.builtin').live_grep {
            search_dirs = { vim.fn.expand('%:h', nil, nil) },
          }
        end,
      },
      next = b {
        desc = 'live grep',
        lazy_req('telescope.builtin', 'live_grep'),
      },
    },
  }
end

return M
