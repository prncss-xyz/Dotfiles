local M = {}

function M.extend()
  local d = require('my.config.binder.parameters').d
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local lazy_req = require('my.config.binder.utils').lazy_req
  return keys {
    a = b { desc = 'append', 'a' },
    b = b {
      desc = 'move extremity',
      'req',
      'flies.actions.move',
      'move',
      'n',
      {
        domain = 'outer',
        external = true,
      },
    },
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
    e = modes {
      n = b { 'w' },
      xo = b { 'e' },
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
    t = modes {
      n = b {
        'req',
        'flies.actions.move',
        'operations',
        'n',
        { axis = 'backward', domain = 'outer' },
      },
      o = b {
        'req',
        'flies.actions.move',
        'move',
        'o',
        { axis = 'backward', domain = 'outer' },
      },
      x = b {
        'req',
        'flies.actions.move',
        'move',
        'x',
        { axis = 'backward', domain = 'outer' },
      },
    },
    u = b { 'u' },
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
    w = b { 'b', 'previous word ', modes = 'nxo' },
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
    [d.up] = b { 'keys', 'k', desc = 'up', modes = 'nxo' },
    [d.down] = b { 'keys', 'j', desc = 'down', modes = 'nxo' },
    -- [d.search] = b {
    --   'req',
    --   'flies.flies.search',
    --   'search',
    --   true,
    --   modes = 'nxo',
    -- },
    -- [d.search] = b {
    --   'req',
    --   'my.utils.fuzzy_slash',
    --   'fz',
    --   -- ':Fz ',
    --   modes = 'nx',
    -- },
    ['<c-p>'] = b { 'keys', '<Plug>(YankyCycleForward)' },
    ['<c-n>'] = b { 'keys', '<Plug>(YankyCycleBackward)' },
    ['<c-q>'] = b { 'cmd', 'quitall!', desc = 'quit', modes = 'nxo' },
    ['<c-v>'] = b { 'keys', '"+P', modes = 'nv' },
    -- also: require("luasnip.extras.select_choice")
    -- ['<m-a>'] = b { desc = 'buf 1', lazy_req('buffstory', 'open', 1) },
    -- ['<m-s>'] = b { desc = 'buf 2', lazy_req('buffstory', 'open', 2) },
    -- ['<m-d>'] = b { desc = 'buf 3', lazy_req('buffstory', 'open', 3) },
    -- ['<m-f>'] = b { desc = 'buf 4', lazy_req('buffstory', 'open', 4) },
    ['<m-t>'] = b {
      desc = 'last buffer',
      'req',
      'buffstory',
      'last',
      modes = 'nxti',
    },
    -- FIXME:
    ['<m-w>'] = b {
      desc = 'close window',
      'req',
      'my.utils.windows',
      'close',
      modes = 'nxti',
    },
    -- ['<m-k>'] = b { desc = 'hover', vim.lsp.buf.hover },
    ['<m-q>'] = b {
      desc = 'close buffer',
      'req',
      'my.utils.buffers',
      'delete',
      modes = 'nxti',
    },

    ['<m-j>'] = b {
      desc = 'focus keyed',
      'req',
      'my.utils.ui_toggle',
      'focus_keyed',
      modes = 'nxti',
    },
    ['<m-k>'] = b {
      desc = 'toggle unkeyed',
      'req',
      'my.utils.ui_toggle',
      'toggle_unkeyed',
      modes = 'nxti',
    },
    ['<m-e>'] = b {
      desc = 'toggle unkeyed',
      'req',
      'my.utils.ui_toggle',
      'keep_unkeyed',
      modes = 'nxti',
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
    [':'] = b{
      desc = "command enter",
      modes = "nx",
      "<cmd>update<cr>:"
    }
  }
end

return M
