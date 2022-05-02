local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local lazy_req = require('plugins.binder.util').lazy_req
  return keys {
    redup = b {
      desc = 'project files',
      require('plugins.binder.actions').project_files,
    },
    a = b { desc = 'edit alt', require('plugins.binder.actions').edit_alt },
    b = keys {
      desc = '0',
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
    g = b { desc = 'buffers', lazy_req('telescope.builtin', 'buffers') },
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
    f = keys {
      prev = b {
        desc = 'file (recursive)',
        lazy_req('telescope.builtin', 'file_browser'),
        {
          cwd = vim.fn.expand '%:p:h',
          depth = 10,
        },
      },
      next = b {
        desc = 'file (current)',
        lazy_req('telescope.builtin', 'file_browser'),
        {
          cwd = vim.fn.expand '%:p:h',
        },
      },
    },
    n = keys {
      desc = 'bufsurf',
      prev = b {desc = 'next', 'BufSurfForward', cmd = true},
      next = b {desc = 'previous', 'BufSurfBack', cmd = true},
    },
    o = b {
      desc = 'oldfiles',
      lazy_req('telescope.builtin', 'oldfiles', { only_cwd = true }),
    },
    w = b {
      desc = 'todo',
      lazy_req('telescope', 'extensions.todo-comments.todo'),
    },
    b { desc = 'quickfixlist', lazy_req('telescope.builtin', 'quickfixlist') },
    t = keys {
      desc = 'trouble',
      prev = lazy_req(
        'trouble',
        'previous',
        { skip_groups = true, jump = true }
      ),
      next = lazy_req('trouble', 'next', { skip_groups = true, jump = true }),
    },
    ['é'] = b {
      desc = 'live grep',
      lazy_req('telescope.builtin', 'live_grep'),
    },
  }
end

return M
