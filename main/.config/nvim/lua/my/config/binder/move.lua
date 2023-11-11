local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local utils = require 'my.config.binder.utils'
  local cmd = require('binder.helpers').cmd
  local np = utils.np
  local np_ = utils.np_
  local lazy_req = utils.lazy_req

  local d = require('my.config.binder.parameters').d

  return keys {
    redup = keys {},
    b = modes {
      nx = np {
        desc = 'aerial symbol',
        prev = function()
          vim.cmd 'AerialPrev'
        end,
        next = function()
          vim.cmd 'AerialNext'
        end,
      },
    },
    c = modes {
      desc = 'asterisk',
      n = b {
        function()
          require('flies.flies.search').set_search(true)
          vim.cmd 'normal! *N'
        end,
      },
      x = b {
        function()
          require('flies.flies.search').set_search(true)
          vim.cmd 'normal! *'
        end,
      },
    },
    e = keys {
      desc = 'peek',
      h = b {
        desc = 'git',
        'req',
        'gitsigns',
        'blame_line',
        { full = true },
      },
      k = b { desc = 'hover', 'vim', 'lsp.buf.hover' },
      r = b {
        desc = 'reference',
        'req',
        'goto-preview',
        'goto_preview_references',
      },
      s = b {
        desc = 'definition',
        'req',
        'goto-preview',
        'goto_preview_definition',
      },
      t = b { 'UltestOutput', cmd = true },
      x = b { desc = 'signature help', 'vim', 'lsp.buf.signature_help' },
    },
    k = np {
      desc = 'trail move geo',
      prev = function()
        vim.cmd 'TrailBlazerMoveToNearest 0 fpath_up'
      end,
      next = function()
        vim.cmd 'TrailBlazerMoveToNearest 0 fpath_down'
      end,
    },
    l = np {
      desc = 'trail move chrono',
      prev = function()
        vim.cmd 'TrailBlazerPeekMovePreviousUp'
      end,
      next = function()
        vim.cmd 'TrailBlazerPeekMoveNextDown'
      end,
    },
    s = b {
      desc = 'definition',
      lazy_req('telescope.builtin', 'lsp_definitions'),
    },
    r = np {
      desc = 'reference',
      prev = function()
        require('illuminate').goto_prev_reference(true)
      end,
      next = function()
        require('illuminate').goto_next_reference(true)
      end,
    },
    t = np {
      desc = 'trouble',
      prev = lazy_req(
        'trouble',
        'previous',
        { skip_groups = true, jump = true }
      ),
      next = lazy_req('trouble', 'next', { skip_groups = true, jump = true }),
    },
    u = keys {
      desc = 'page',
      prev = b { '<c-u>' },
      next = b { '<c-d>' },
    },
    --[[
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
      x = np {
        desc = 'page',
        prev = function()
          require('neoscroll').scroll(-0.9, true, 250)
        end,
        next = function()
          require('neoscroll').scroll(0.9, true, 250)
        end,
      },
    },
    --]]
    v = keys {
      prev = b { '`<', modes = 'nxo', desc = 'selection start' },
      next = b { '`>', modes = 'nxo', desc = 'selection end' },
    },
    w = b { desc = 'last jump', '``' },
    [';'] = np {
      prev = 'g,',
      next = 'g;',
      desc = 'change',
    },
    --[[ [d.up] = b { 'gk', desc = 'prev visual line' }, ]]
    --[[ [d.down] = b { 'gj', desc = 'next visual line' }, ]]
    [d.search] = keys {
      desc = 'search',
      prev = b {
        function()
          require('flies.flies.search').search(false)
        end,
      },
      next = b {
        function()
          require('flies.flies.search').search(true)
        end,
      },
    },
  }
end

return M
