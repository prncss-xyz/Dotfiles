local M = {}

local util = require 'plugins.binder.util'

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local lazy_req = require('plugins.binder.util').lazy_req
  return keys {
    C = b { '<nop>', modes = 'nx' },
    -- c = b { '"_c', modes = 'nx' },
    c = modes {
      n = b { lazy_req('flies.actions', 'op_insert', '"_c', 'inner', true) },
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
    rr = b { '"+', modes = 'nx' },
    r = b { '"', modes = 'nx' },
    ['<c-n>'] = b { lazy_req('bufjump', 'forward') },
    ['<c-o>'] = b { '<c-o>' },
    ['<c-p>'] = b { lazy_req('bufjump', 'backward') },
    ['<c-q>'] = b { '<cmd>qall!<cr>', 'quit' },
    a = b { 'a' },
    b = b { desc = 'matchparen', '%', modes = 'nxo' },
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
    p = b {
      lazy_req('flies.move_again', 'previous'),
    },
    n = b { lazy_req('flies.move_again', 'next') },
    O = b { '<nop>', modes = 'nx' },
    o = b { '<nop>', modes = 'nx' },
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
    t = b { lazy_req('flies.actions', 'move_current', 'inner') },
    -- t = b { lazy_req('flies.actions', 'append_insert') },
    ou = b { 'U' },
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
    ['é'] = b { '/', modes = 'nxo' },
    -- ['<space>'] = { ':', modes = 'nx' },
    ['<space>'] = b {
      desc = 'legendary find',
      lazy_req('legendary', 'find'),
    },
  }
end

return M
