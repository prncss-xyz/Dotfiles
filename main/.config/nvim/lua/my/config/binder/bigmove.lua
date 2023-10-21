local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local util = require 'my.config.binder.utils'
  local lazy_req = util.lazy_req
  return keys {
    e = b { desc = 'buf 1', 'req', 'buffstory', 'open', 1 },
    r = b { desc = 'buf 2', 'req', 'buffstory', 'open', 2 },
    t = b { desc = 'buf 3', 'req', 'buffstory', 'open', 3 },
    y = b { desc = 'buf 4', 'req', 'buffstory', 'open', 4 },
    k = b { desc = 'terminal zk', 'req', 'my.utils.terminal', 'terminal', 'zk' },
    l = b { desc = 'terminal zl', 'req', 'my.utils.terminal', 'terminal', 'zl' },
    -- update "main/.config/nvim/lua/plugins/neo-tree.lua"
    u = b { desc = 'harpoon file 1', 'req', 'harpoon.ui', 'nav_file', 1 },
    i = b { desc = 'harpoon file 2', 'req', 'harpoon.ui', 'nav_file', 2 },
    o = b { desc = 'harpoon file 3', 'req', 'harpoon.ui', 'nav_file', 3 },
    p = b { desc = 'harpoon file 4', 'req', 'harpoon.ui', 'nav_file', 4 },
    a = b {
      desc = 'test file',
      'req',
      'my.utils.relative_files',
      'alternative',
      'test',
    },
    b = keys {
      desc = 'bookmark',
      a = keys {
        desc = '0',
        prev = b { 'req', 'marks', 'prev_bookmark0' },
        next = b { 'req', 'marks', 'next_bookmark0' },
      },
      s = keys {
        desc = '1',
        prev = b { 'req', 'marks', 'prev_bookmark1' },
        next = b { 'req', 'marks', 'next_bookmark1' },
      },
      d = keys {
        desc = '2',
        prev = b { 'req', 'marks', 'prev_bookmark2' },
        next = b { 'req', 'marks', 'next_bookmark2' },
      },
      f = keys {
        desc = '3',
        prev = b { 'req', 'marks', 'prev_bookmark3' },
        next = b { 'req', 'marks', 'next_bookmark3' },
      },
    },
    c = b { desc = 'snippets', 'req', 'my.utils.snippets', 'edit' },
    d = keys {
      desc = 'unimpaired directory',
      prev = b { '<Plug>(unimpaired-directory-previous)' },
      next = b { '<Plug>(unimpaired-directory-next)' },
    },
    redup = keys {
      desc = 'quickfix/trouble/tree',
      redup = b {
        desc = 'raise',
        'req',
        'my.utils.ui_toggle',
        'raise',
      },
      b = b {
        desc = 'buffers',
        'req',
        'my.utils.ui_toggle',
        'activate',
        'neo_tree',
        'Neotree buffers',
      },
      d = b {
        desc = 'diagnostics',
        'req',
        'my.utils.ui_toggle',
        'activate',
        'trouble',
        'Trouble workspace_diagnostics',
      },
      f = b {
        desc = 'neo-tree',
        'req',
        'my.utils.ui_toggle',
        'activate',
        'neo_tree',
        'Neotree',
      },
      h = b {
        desc = 'neo-tree git',
        'req',
        'my.utils.ui_toggle',
        'activate',
        'neo_tree',
        'Neotree git_status',
      },
      n = b {
        desc = 'zk',
        'req',
        'my.utils.ui_toggle',
        'activate',
        'neo_tree',
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
        'req',
        'my.utils.ui_toggle',
        'activate',
        'trouble',
        'Trouble lsp_references',
      },
      w = b {
        desc = 'todo',
        'req',
        'my.utils.ui_toggle',
        'activate',
        'trouble',
        'TodoTrouble',
      },
      x = b {
        desc = 'ui close',
        'req',
        'my.utils.ui_toggle',
        'close',
      },
    },
    g = b { desc = 'last buffer', 'req', 'buffstory', 'last' },
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
