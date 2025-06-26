local M = {}

function M.extend()
  local d = require('my.config.binder.parameters').d
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local cmd = require('binder.helpers').cmd
  local lazy_req = require('my.config.binder.utils').lazy_req
  return keys {
    a = b { desc = 'append', 'a' },
    b = b { '<nop>', modes = 'nx' },
    C = b { '<nop>', modes = 'nx' },
    -- c = b { '"_c', modes = 'nx' },
    c = modes {
      n = b {
        'req',
        'flies.operations.act',
        'exec',
        { around = 'never' },
        false,
        '"_c',
      },
      x = b { '"_c' },
    },
    D = b { '<nop>', modes = 'nx' },
    d = modes {
      n = b {
        'req',
        'flies.operations.act',
        'exec',
        {
          domain = 'outer',
          around = 'always',
        },
        false,
        '"_d',
      },
      x = b { '"_d' },
    },
    e = b {
      desc = 'move up right inner',
      'req',
      'flies.actions.move',
      'move',
      'n',
      {
        domain = 'outer',
        around = 'never',
        move = 'right',
      },
      modes = 'nx',
    },
    f = modes {
      n = b {
        'req',
        'flies.actions.move',
        'move',
        'n',
        { axis = 'forward', move = 'left', domain = 'outer' },
      },
      o = b {
        'req',
        'flies.actions.move',
        'move',
        'o',
        { axis = 'forward', domain = 'outer' },
      },
      x = b {
        'req',
        'flies.actions.move',
        'move',
        'x',
        { axis = 'forward', domain = 'outer' },
      },
    },
    i = b { 'i' },
    n = modes {
      nx = b { lazy_req('flies.actions.move_again', 'next') },
    },
    O = b { require('my.utils.windows').info },
    -- O = b { '<nop>', modes = 'nx' },
    -- o = b { '<nop>', modes = 'nx' },
    p = modes {
      nx = b {
        lazy_req('flies.actions.move_again', 'prev'),
      },
    },
    rr = b { '"+', modes = 'nx' },
    r = b { '"', modes = 'nx' },
    s = modes {
      n = b {
        'req',
        'flies.actions.move',
        'move',
        'n',
        { axis = 'hint', domain = 'outer' },
      },
      x = b {
        'req',
        'flies.actions.move',
        'move',
        'x',
        { axis = 'hint', domain = 'outer' },
      },
    },
    u = b { cmd 'silent undo' },
    V = b { '<c-v>', modes = 'nxo' },
    v = modes {
      x = b { 'V' },
      n = b {
        'req',
        'flies.actions.select',
        'select',
        {
          domain = 'outer',
          around = 'always',
        },
      },
    },
    w = b {
      desc = 'move up left outer',
      'req',
      'flies.actions.move',
      'move',
      'n',
      {
        domain = 'outer',
        around = 'never',
        move = 'left',
      },
      modes = 'nx',
    },
    yy = b { '<nop>' },
    y = modes {
      n = b {
        function()
          require('flies.operations.act').exec(
            { domain = 'outer', around = 'never' },
            nil,
            'y'
          )
        end,
      },
      x = b { 'y' },
    },
    ['<space>'] = modes {
      desc = 'legendary find',
      n = b {
        'req',
        'legendary',
        'find',
        {
          filters = require('legendary.filters').mode 'n',
        },
      },
      x = b {
        'req',
        'legendary',
        'find',
        {
          filters = require('legendary.filters').mode 'x',
        },
      },
    },
    [d.right] = b { 'keys', 'l', desc = 'right', modes = 'nxo' },
    [d.left] = b { 'keys', 'h', desc = 'left', modes = 'nxo' },
    [d.up] = b { 'keys', 'gk', desc = 'up', modes = 'nxo' },
    [d.down] = b { 'keys', 'gj', desc = 'down', modes = 'nxo' },
    ['<c-r>'] = b { desc = 'redo', cmd 'silent redo' },
    ['<c-p>'] = b { 'keys', '<Plug>(YankyCycleForward)' },
    ['<c-n>'] = b { 'keys', '<Plug>(YankyCycleBackward)' },
    ['<c-q>'] = b { 'cmd', 'quitall!', desc = 'quit', modes = 'nxo' },
    ['<c-v>'] = b { 'keys', '"+P', modes = 'nv' },
    -- also: require("luasnip.extras.select_choice"),
    ['<m-t>'] = b {
      desc = 'last buffer',
      'req',
      'buffstory',
      'buf_toggle',
      modes = 'nxti',
    },
    --[[ ['<m-t>'] = b {
      desc = 'last buffer',
      'req',
      'buffstory',
      'last',
      modes = 'nxti',
    }, ]]
    ['<m-w>'] = b {
      desc = 'close window',
      'req',
      'my.utils.windows',
      'close',
      modes = 'nxti',
    },
    ['<m-q>'] = b {
      desc = 'close buffer',
      'req',
      'my.utils.buffers',
      'delete',
      modes = 'nxti',
    },
    ['<m-p>'] = b {
      esc = 'prev win',
      'req',
      'buffstory',
      'buf_nav',
      false,
      modes = 'nxti',
    },
    ['<m-n>'] = b {
      desc = 'next win',
      'req',
      'buffstory',
      'buf_nav',
      true,
      modes = 'nxti',
    },
    ['<m-j>'] = b {
      desc = 'prev win',
      'req',
      'buffstory',
      'win_nav',
      false,
      modes = 'nxti',
    },
    ['<m-k>'] = b {
      desc = 'next win',
      'req',
      'buffstory',
      'win_nav',
      true,
      modes = 'nxti',
    },
    ['<m-e>'] = b {
      desc = 'keep current window',
      'req',
      'buffstory',
      'keep_win',
      modes = 'nxi',
    },
    ['<m-s>'] = b {
      desc = 'pick window',
      modes = 'nxti',
      'req',
      'my.utils.windows',
      'winpick',
    },
    ['<m-u>'] = b {
      desc = 'toggle floating term',
      modes = 'nxti',
      'req',
      'my.utils.terminal',
      'toggle_float',
    },
    [':'] = b {
      desc = 'command enter',
      modes = 'nx',
      '<cmd>update<cr>:',
    },
  }
end

return M
