local M = {}

function M.extend()
  local d = require('my.config.binder.parameters').d
  local util = require 'my.config.binder.utils'
  local alt = util.alt
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local lazy_req = require('my.config.binder.utils').lazy_req
  return keys {
    a = b { desc = 'append', 'a' },
    b = b { desc = 'move extremity', lazy_req('flies2.operations.move', 'exec') },
    C = b { '<nop>', modes = 'nx' },
    -- c = b { '"_c', modes = 'nx' },
    c = modes {
      n = b {
        function()
          require('flies2.operations.act').exec(
            { around = 'never' },
            nil,
            '"_c'
          )
        end,
      },
      x = b { '"_c' },
    },
    -- cc = b { '"_cc', modes = 'n' },
    cc = b { '<nop>', modes = 'n' },
    D = b { '<nop>', modes = 'nx' },
    d = modes {
      n = b {
        function()
          require('flies2.operations.act').exec({
            domain = 'outer',
            around = 'always',
          }, nil, '"_d', false)
        end,
      },
      -- n = b { '"_d<plug>(flies-select)' },
      x = b { '"_d' },
    },
    dd = b { '<nop>', modes = 'n' },
    e = modes {
      n = b { 'w' },
      xo = b { 'e' },
    },
    f = modes {
      n = b { lazy_req('flies2.operations.move', 'exec') },
      o = b { lazy_req('flies2.operations.move', 'exec') },
      x = b { lazy_req('flies2.operations.move', 'exec') },
    },
    i = b { 'i' },
    n = b { lazy_req('flies2.operations.move_again', 'next') },
    -- O = b { '<nop>', modes = 'nx' },
    -- o = b { '<nop>', modes = 'nx' },
    p = b {
      lazy_req('flies2.operations.move_again', 'prev'),
    },
    rr = b { '"+', modes = 'nx' },
    r = b { '"', modes = 'nx' },
    s = modes {
      nx = b { require('my.config.binder.actions').hop12 },
      o = b {
        function()
          require('hop').hint_char2 {
            char2_fallback_key = '<cr>',
          }
        end,
      },
    },
    ou = b { 'U' },
    t = b { lazy_req('flies2.actions', 'append_insert') },
    u = b { 'u' },
    V = b { '<c-v>', modes = 'nxo' },
    v = modes {
      x = b { 'V' },
      n = b {
        function()
          require('flies2.operations.select').exec()
        end,
      },
    },
    w = b { 'b', 'previous word ', modes = 'nxo' },
    x = modes {
      n = b {
        function()
          require('flies2.operations.act').exec({
            around = 'always',
          }, nil, 'd')
        end,
      },
      x = b { 'd' },
    },
    xx = b { 'dd' },
    yy = b { 'yy', modes = 'n' },
    y = modes {
      n = b {
        function()
          require('flies2.operations.act').exec({ around = 'always' }, nil, 'y')
        end,
      },
      x = b { 'y' },
    },
    ['<space>'] = modes {
      desc = 'legendary find',
      n = b {
        function()
          require('legendary').find {
            filters = require('legendary.filters').mode 'n',
          }
        end,
      },
      x = b {
        function()
          require('legendary').find {
            filters = require('legendary.filters').mode 'x',
          }
        end,
      },
    },
    [d.right] = b { 'l', 'right', modes = 'nxo' },
    [d.left] = b { 'h', 'left', modes = 'nxo' },
    [d.up] = b { 'k', 'up', modes = 'nxo' },
    [d.down] = b { 'j', 'down', modes = 'nxo' },
    [d.search] = b {
      function()
        require('flies2.flies.search').search(true)
      end,
      modes = 'nxo',
    },
    ['<c-q>'] = b { 'quitall!', desc = 'quit', cmd = true },
    ['<c-v>'] = b { '"+P', modes = 'nv' },
    -- also: require("luasnip.extras.select_choice")
    -- ['<m-a>'] = b { desc = 'buf 1', lazy_req('buffstory', 'open', 1) },
    -- ['<m-s>'] = b { desc = 'buf 2', lazy_req('buffstory', 'open', 2) },
    -- ['<m-d>'] = b { desc = 'buf 3', lazy_req('buffstory', 'open', 3) },
    -- ['<m-f>'] = b { desc = 'buf 4', lazy_req('buffstory', 'open', 4) },
    ['<m-p>'] = b { desc = 'window back', 'wincmd p', cmd = true },
    ['<m-r>'] = b { desc = 'last window', '<c-w><c-p>' },
    ['<m-t>'] = b {
      desc = 'last buffer',
      function()
        require('buffstory').last()
      end,
    },
    ['<m-q>'] = b { desc = 'close window', 'q', cmd = true },
    ['<m-w>'] = b {
      desc = 'close buffer',
      lazy_req('bufdelete', 'bufdelete', 0, true),
    },
    ['<m-u>'] = b {
      desc = 'pick special window',
      function()
        require('my.utils.windows').cycle_focus_within_buftype(false)
      end,
    },
    ['<m-i>'] = b {
      desc = 'pick plain window',
      function()
        require('my.utils.windows').cycle_focus_within_buftype(true)
      end,
    },
    ['<m-o>'] = b {
      desc = 'pick window',
      require('my.utils.windows').focus_any,
    },
    [alt(d.left)] = b {
      desc = 'window right',
      lazy_req('my.utils.wrap_win', 'left'),
    },
    [alt(d.down)] = b {
      lazy_req('my.utils.wrap_win', 'down'),
      desc = 'window down',
    },
    [alt(d.up)] = b { lazy_req('my.utils.wrap_win', 'up'), desc = 'up' },
    [alt(d.right)] = b {
      desc = 'window right',
      lazy_req('my.utils.wrap_win', 'right'),
    },
  }
end

return M
