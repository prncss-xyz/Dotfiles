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
      desc = 'current buffer fuzzy find',
      lazy_req('telescope.builtin', 'current_buffer_fuzzy_find', {}),
    },
    b = b { '%', modes = 'nxo', desc = 'matching char' },
    c = keys {
      prev = b { util.asterisk_gz, desc = 'current word start' },
      next = b { util.asterisk_z, desc = 'current word' },
    },
    d = np {
      desc = 'diagnostic',
      prev = vim.diagnostic.goto_prev,
      next = vim.diagnostic.goto_next,
    },
    g = b { '``', desc = 'before last jump' },
    l = b { '`', desc = 'mark <char>' },
    m = keys {
      prev = b { '`[', desc = 'start of last mod', modes = 'nxo' },
      next = b { '`]', desc = 'begin of last mod', modes = 'nxo' },
    },
    o = b { '`.', desc = 'last change' },
    r = np {
      desc = 'reference',
      prev = function()
        require('illuminate').next_reference { wrap = true, reverse = true }
      end,
      next = function()
        require('illuminate').next_reference { wrap = true }
      end,
    },
    s = b { require('bindutils').telescope_symbols_md_lsp, desc = 'lsp symbol' },
    t = np {
      desc = 'failed test',
      prev = b { '<Plug>(ultest-prev-fail)' },
      next = b { '<Plug>(ultest-next-fail)' },
    },
    u = np {
      desc = 'page',
      prev = function()
        require('neoscroll').scroll(-0.9, true, 250)
      end,
      next = function()
        require('neoscroll').scroll(0.9, true, 250)
      end,
    },
    v = keys {
      prev = b { '`<', modes = 'nxo', desc = 'selection start' },
      next = b { '`>', modes = 'nxo', desc = 'selection end' },
    },
    [';'] = np {
      prev = 'g,',
      next = 'g;',
      desc = 'change',
    },
    [d.up] = b { 'gk', desc = 'prev visual line' },
    [d.down] = b { 'gj', desc = 'next visual line' },
    [d.search] = keys {
      desc = 'search',
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
    },
  }
end

return M
