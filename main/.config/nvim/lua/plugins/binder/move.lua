local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local util = require 'plugins.binder.util'
  local np = util.np
  local lazy_req = util.lazy_req

  local d = require('plugins.binder.parameters').d
  return keys {
    a = b {
      lazy_req('telescope.builtin', 'current_buffer_fuzzy_find', {}),
    },
    b = b { '%', modes = 'nxo' },
    c = keys {
      prev = b { util.asterisk_gz },
      next = b { util.asterisk_z },
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
      prev = function()
        require('illuminate').next_reference { wrap = true, reverse = true }
      end,
      next = function()
        require('illuminate').next_reference { wrap = true }
      end,
    },
    s = b { require('bindutils').telescope_symbols_md_lsp },
    t = keys {
      prev = b { '<Plug>(ultest-prev-fail)' },
      next = b { '<Plug>(ultest-next-fail)' },
    },
    u = np {
      prev = function()
        require('neoscroll').scroll(-0.9, true, 250)
      end,
      next = function()
        require('neoscroll').scroll(0.9, true, 250)
      end,
    },
    v = keys {
      prev = b { '`<', modes = 'nxo' },
      next = b { '`>', modes = 'nxo' },
    },
    [';'] = np {
      prev = 'g,',
      next = 'g;',
      desc = 'change',
    },
    [d.up] = b { 'gk' },
    [d.down] = b { 'gj' },
    -- TODO: deel with accents
    [d.search] = keys {
      prev = b {
        function()
          require('flies.objects.search').search('?', true, false)
        end,
      },
      next = b {
        function()
          require('flies.objects.search').search('/', true, true)
        end,
      },
      desc = 'search'
    },
  }
end

return M
