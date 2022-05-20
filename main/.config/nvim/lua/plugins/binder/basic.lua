local M = {}

function M.extend()
  local d = require('plugins.binder.parameters').d
  local util = require 'plugins.binder.util'
  local alt = util.alt
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local lazy_req = require('plugins.binder.util').lazy_req
  return keys {
    a = b { 'a' },
    b = b { desc = 'matchparen', '%', modes = 'nxo' },
    C = b { '<nop>', modes = 'nx' },
    -- c = b { '"_c', modes = 'nx' },
    c = modes {
      n = b { lazy_req('flies.actions', 'op', '"_c', 'inner', true) },
      x = b { '"_c' },
    },
    -- cc = b { '"_cc', modes = 'n' },
    cc = b { '<nop>', modes = 'n' },
    D = b { '<nop>', modes = 'nx' },
    d = modes {
      n = b { lazy_req('flies.actions', 'op', '"_d', 'outer', true) },
      x = b { '"_d' },
    },
    dd = b { '<nop>', modes = 'n' },
    e = modes {
      n = b { 'w' },
      xo = b { 'e' },
    },
    f = modes {
      n = b { lazy_req('flies.actions', 'meta_move', 'n') },
      o = b { lazy_req('flies.actions', 'meta_move', 'o') },
      x = b { lazy_req('flies.actions', 'meta_move', 'x') },
    },
    i = b { 'i' },
    n = b { lazy_req('flies.move_again', 'next') },
    O = b { '<nop>', modes = 'nx' },
    o = b { '<nop>', modes = 'nx' },
    p = b {
      lazy_req('flies.move_again', 'previous'),
    },
    rr = b { '"+', modes = 'nx' },
    r = b { '"', modes = 'nx' },
    s = modes {
      nx = b {
        function()
          require('bindutils').hop12()
        end,
      },
      o = b {
        function()
          require('hop').hint_char2 {
            char2_fallback_key = '<cr>',
          }
        end,
      },
    },
    ou = b { 'U' },
    t = b { lazy_req('flies.actions', 'move_current', 'inner') },
    -- t = b { lazy_req('flies.actions', 'append_insert') },
    u = b { 'u' },
    V = b { '<c-v>', modes = 'nxo' },
    v = modes {
      x = b { 'V' },
      n = b { 'v' },
    },
    w = b { 'b', 'previous word ', modes = 'nxo' },
    x = b { 'd', modes = 'nx' },
    xx = b { 'dd' },
    yy = b { 'yy', modes = 'n' },
    -- y = {
    --   function()
    --     require('bindutils').static_yank 'y'
    --   end,
    --   modes = 'nx',
    -- },
    y = b { 'y', modes = 'nx' },
    -- ['<space>'] = { ':', modes = 'nx' },
    ['<space>'] = b {
      desc = 'legendary find',
      lazy_req('legendary', 'find'),
    },
    [d.right] = b { 'l', 'right', modes = 'nxo' },
    [d.left] = b { 'h', 'left', modes = 'nxo' },
    [d.up] = b { 'k', 'up', modes = 'nxo' },
    [d.down] = b { 'j', 'down', modes = 'nxo' },
    [d.search] = b { '/', modes = 'nxo' },
    ['<c-f>'] = b {
      function()
        require('luasnip.extras.otf').on_the_fly 'f'
      end,
      modes = 'vi',
    },
    ['<c-g>'] = b {
      lazy_req('telescope', 'extensions.luasnip.luasnip', {}),
      modes = 'ni',
    },
    ['<c-n>'] = b { lazy_req('bufjump', 'forward') },
    ['<c-o>'] = b { '<c-o>' },
    ['<c-i>'] = b { '<c-i>' },
    ['<c-r>'] = b { '<c-r>' },
    ['<c-s>'] = modes {
      n = b {
        function()
          require('bindutils').lsp_format()
        end,
      },
      i = b {
        function()
          vim.cmd 'stopinsert'
          require('bindutils').lsp_format()
        end,
      },
      desc = 'format',
    },
    ['<c-p>'] = b { lazy_req('bufjump', 'backward') },
    ['<c-q>'] = b { 'qall!', cmd = true, desc = 'quit' },
    ['<c-v>'] = b { 'P', modes = 'nv' },
    -- also: require("luasnip.extras.select_choice")
    [d.prev_search] = modes {
      i = b { lazy_req('luasnip', 'change_choice', -1) },
    },
    [d.next_search] = modes {
      i = b { lazy_req('luasnip', 'change_choice', 1) },
    },
    ['<a-a>'] = b { 'e#', 'previous buffer' },
    ['<a-b>'] = b { desc = 'window back', 'wincmd p', cmd = true },
    ['<a-w>'] = b { 'q', desc = 'close window', cmd = true },
    [alt(d.left)] = b {
      lazy_req('modules.wrap_win', 'left'),
      desc = 'window left',
    },
    [alt(d.down)] = b {
      lazy_req('modules.wrap_win', 'down'),
      desc = 'window down',
    },
    [alt(d.up)] = b { lazy_req('modules.wrap_win', 'up'), desc = 'up' },
    [alt(d.right)] = b {
      lazy_req('modules.wrap_win', 'right'),
      desc = 'window right',
    },
  }
end

return M
