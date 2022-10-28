local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local utils = require 'plugins.binder.utils'
  local actions = require 'plugins.binder.actions'
  local np = utils.np
  local lazy_req = utils.lazy_req

  local d = require('plugins.binder.parameters').d

  return keys {
    redup = b { '``', desc = 'before last jump' },
    a = b {
      desc = 'current buffer fuzzy find',
      lazy_req('telescope.builtin', 'current_buffer_fuzzy_find', {}),
    },
    b = np {
      desc = 'aerial symbol',
      prev = function()
        vim.cmd 'AerialPrev'
      end,
      next = function()
        vim.cmd 'AerialNext'
      end,
    },
    c = keys {
      prev = b { actions.asterisk_gz, desc = 'current word start' },
      next = b { actions.asterisk_z, desc = 'current word' },
    },
    d = np {
      desc = 'diagnostic',
      prev = vim.diagnostic.goto_prev,
      next = vim.diagnostic.goto_next,
    },
    e = b { '<nop>' },
    h = np {
      desc = 'hunk',
      prev = lazy_req('gitsigns', 'prev_hunk'),
      next = lazy_req('gitsigns', 'next_hunk'),
    },
    l = b { '`', desc = 'mark <char>' },
    m = keys {
      desc = 'fold',
      prev = b { '[z', desc = 'start current' },
      next = b { ']z', desc = 'end current' },
    },
    n = keys {
      desc = 'fold',
      prev = b { 'zk', desc = 'start current' },
      next = b { 'zj', desc = 'end current' },
    },
    q = keys {
      prev = b { '`[', desc = 'start of last mod', modes = 'nxo' },
      next = b { '`]', desc = 'begin of last mod', modes = 'nxo' },
    },
    o = b { '`.', desc = 'last change' },
    r = np {
      desc = 'reference',
      prev = function()
        require('illuminate').goto_prev_reference(true)
      end,
      next = function()
        require('illuminate').goto_next_reference(true)
      end,
    },
    s = b {
      desc = 'aerial symbols',
      lazy_req(
        'telescope',
        'extensions.aerial.aerial',
        { show_nesting = true } -- does it change something
      ),
    },
    -- s = b { require('utils').telescope_symbols_md_lsp, desc = 'lsp symbol' },
    u = modes {
      n = np {
        desc = 'page',
        prev = function()
          require('neoscroll').scroll(-0.9, true, 250)
        end,
        next = function()
          require('neoscroll').scroll(0.9, true, 250)
        end,
      },
      x = keys {
        prev = b {
          function()
            require('neoscroll').scroll(-0.9, true, 250)
          end,
        },
        next = b {
          function()
            require('neoscroll').scroll(0.9, true, 250)
          end,
        },
      },
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
    ['<cr>'] = b { 'G', desc = 'line' },
  }
end

return M
