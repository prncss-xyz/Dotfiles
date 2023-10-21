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

  local function portal_builtin(name, opts)
    return keys {
      desc = name,
      prev = b {
        function()
          require('portal.builtin')[name].tunnel_forward(opts)
        end,
      },
      next = b {
        function()
          require('portal.builtin')[name].tunnel_backward(opts)
        end,
      },
    }
  end

  return keys {
    redup = keys {
      a = b {
        desc = 'current buffer fuzzy find',
        'req',
        'telescope.builtin',
        'current_buffer_fuzzy_find',
        { bufnr = 0 },
      },
      j = b {
        desc = 'jumplist',
        'req',
        'telescope.builtin',
        'jumplist',
      },
      l = b {
        desc = 'trail marks',
        'req',
        'telescope.builtin',
        'marks',
      },
      r = b {
        desc = 'register',
        'req',
        'telescope.builtin',
        'registers',
      },
      s = b {
        desc = 'aerial symbols',
        function()
          if
            vim.tbl_contains({
              -- OrgMode
              -- AsciiDoc
              -- Beancount
              'help',
              'norg',
              'rst',
              'latex',
              'tex',
              'markdown',
              'vimwiki',
              'pandoc',
              'markdown.pandoc',
              'markdown.gtm',
            }, vim.bo.filetype)
          then
            require('telescope').extensions.heading.heading()
          else
            require('telescope').extensions.aerial.aerial()
          end
        end,
      },
      w = portal_builtin 'jumplist',
      [';'] = portal_builtin 'changelist',
    },
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
    d = np_ {
      desc = 'diagnostic',
      prev = {
        'vim',
        'diagnostic.goto_prev',
      },
      next = {
        'vim',
        'diagnostic.goto_next',
      },
    },
    e = keys {
      desc = 'peek',
      redup = b {
        desc = 'focus',
        '<c-w>w',
      },
      h = b {
        desc = 'git',
        'req',
        'gitsigns',
        'blame_line',
        { full = true },
      },
      k = b { desc = 'hover', 'vim', 'lsp.buf.hover' },
      l = b { '<Plug>(Marks-preview)' },
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
    f = keys {
      desc = 'loclist/trouble',
      d = b {
        desc = 'diagnostics',
        'req',
        'my.utils.ui_toggle',
        'activate',
        'trouble',
        'Trouble document_diagnostics',
      },
      s = b {
        desc = 'aerial symbols',
        'req',
        'my.utils.ui_toggle',
        'activate',
        'aerial',
      },
      h = b {
        desc = 'hunks',
        'req',
        'my.utils.ui_toggle',
        'activate',
        'trouble',
        'Gitsigns setqflist',
      },
    },
    h = np {
      desc = 'hunk',
      prev = function()
        require('gitsigns').prev_hunk()
      end,
      next = function()
        require('gitsigns').next_hunk()
      end,
    },
    --[[ l = b { '`', desc = 'mark <char>' }, ]]
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
    ['<cr>'] = b { 'G', desc = 'line' },
  }
end

return M
