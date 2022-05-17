local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local lazy_req = require('plugins.binder.util').lazy_req
  return keys {
    a = b {
      lazy_req('telescope.builtin', 'current_buffer_fuzzy_find', {}),
    },
    b = b { '%', modes = 'nxo' },
    c = keys {
      prev = b { require('bindutils').asterisk_gz },
      next = b { require('bindutils').asterisk_z },
    },
    d = keys {
      prev = b {
        vim.diagnostic.goto_prev,
        desc = 'go previous diagnostic',
      },
      next = b {
        vim.diagnostic.goto_next,
        desc = 'go next diagnostic',
      },
    },
    g = b { '``', desc = 'before last jump' },
    l = b { '`' }, -- jump
    m = keys {
      prev = b { '`[', 'start of last mod', modes = 'nxo' },
      next = b { '`]', 'begin of last mod', modes = 'nxo' },
    },
    o = b { '`.', desc = 'last change' },
    r = keys {
      previous = b { require('bindutils').previous_reference },
      next = b { require('bindutils').next_reference },
    },
    s = b { require('bindutils').telescope_symbols_md_lsp },
    t = keys {
      prev = b { '<Plug>(ultest-prev-fail)' },
      next = b { '<Plug>(ultest-next-fail)' },
    },
    u = keys {
      prev = b { require('bindutils').scroll_up },
      next = b { require('bindutils').scroll_down },
    },
    v = keys {
      prev = b { '`<', modes = 'nxo' },
      next = b { '`>', modes = 'nxo' },
    },
  }
end

return M
