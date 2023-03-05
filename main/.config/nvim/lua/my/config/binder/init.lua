local M = {}

function M.config()
  local binder = require 'binder'
  binder.setup {
    dual_key = require('binder.utils').prepend 'p',
    bind_keymap = require('binder.utils').keymap_legendary,
    prefix = 'my.config.binder.',
  }
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'my.config.binder.utils'
  local repeatable = util.repeatable
  local lazy = util.lazy
  local lazy_req = util.lazy_req

  for char in ("#$%&'*_,-0?@]^_`DEFHIMNPpQVx~+?f"):gmatch '.' do
    vim.keymap.set('n', 'g' .. char, '<nop>', {})
  end
  for _, char in ipairs {
    '<c-]>',
    '<c-a>',
    '<c-g>',
    '<c-h>',
    '<cr>',
    '<down>',
    '<end>',
    '<home>',
    '<leftmouse>',
    '<middlemouse>',
    '<rightmouse>',
    '<tab>',
    '<up>',
    '?h?',
    'g??',
  } do
    vim.keymap.set('n', 'g' .. char, '<nop>', {})
  end
  vim.keymap.set('n', 'o', '<nop>', {})
  vim.keymap.set('x', 'o', '<nop>', {})

  binder.bind(keys {
    register = 'basic',
    g = keys {
      desc = 'go',
      register = 'move',
      next = b { '<nop>' },
    },
    h = keys {
      desc = 'edit',
      register = 'edit',
      next = b { '<nop>' },
    },
    m = keys {
      register = 'mark',
      next = b { '<nop>' },
    },
    o = keys {
      register = 'extra',
      next = b { '<nop>' },
    },
    z = keys {
      register = 'bigmove',
      next = b { '<nop>' },
    },
  })
  require('my.config.binder.commands').setup()
  require('my.config.binder.lang').setup()
  binder.extend_with 'basic'
  binder.extend_with 'edit'
  binder.extend_with 'move'
  binder.extend_with 'bigmove'
  binder.extend_with 'extra'
  binder.extend_with 'mark'
  require('my.config.binder.textobjects').setup()

  require('key-menu').set('n', 'g')
  require('key-menu').set('n', 'h')
  require('key-menu').set('n', 'm')
  require('key-menu').set('n', 'o')
  require('key-menu').set('n', 'z')
end

return M
