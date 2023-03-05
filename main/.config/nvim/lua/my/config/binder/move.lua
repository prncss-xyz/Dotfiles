local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local utils = require 'my.config.binder.utils'
  local actions = require 'my.config.binder.actions'
  local np = utils.np
  local lazy_req = utils.lazy_req

  local d = require('my.config.binder.parameters').d

  return keys {
    redup = keys {
      a = b {
        desc = 'current buffer fuzzy find',
        lazy_req(
          'telescope.builtin',
          'current_buffer_fuzzy_find',
          { bufnr = 0 }
        ),
      },
      j = b {
        desc = 'jumplist',
        lazy_req('telescope.builtin', 'jumplist'),
      },
      l = b {
        desc = 'marks',
        lazy_req('telescope.builtin', 'marks'),
      },
      r = b {
        desc = 'register',
        lazy_req('telescope.builtin', 'register'),
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
      -- i = keys {
      --   prev = b { desc = 'declaration', vim.lsp.buf.declaration },
      --   next = b {
      --     desc = 'implementations',
      --     lazy_req('telescope.builtin', 'lsp_implementations'),
      --   },
      -- },
      -- j = b {
      --   desc = 'type definition',
      --   lazy_req('telescope.builtin', 'lsp_type_definitions'),
      -- },
    },
    -- redup = b { '``', desc = 'before last jump' },
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
    c = keys {
      prev = b { actions.asterisk_gz, desc = 'current word start' },
      next = b { actions.asterisk_z, desc = 'current word' },
    },
    d = np {
      desc = 'diagnostic',
      prev = vim.diagnostic.goto_prev,
      next = vim.diagnostic.goto_next,
    },
    e = keys {
      desc = 'peek',
      redup = b {
        desc = 'focus',
        '<c-w>w',
      },
      h = b {
        desc = 'git',
        lazy_req('gitsigns', 'blame_line', { full = true }),
      },
      k = b { desc = 'hover', vim.lsp.buf.hover },

      l = b {
        '<Plug>(Marks-preview)',
      },
      r = b {
        desc = 'reference',
        lazy_req('goto-preview', 'goto_preview_references'),
      },
      s = b {
        desc = 'definition',
        lazy_req('goto-preview', 'goto_preview_definition'),
      },
      t = b { 'UltestOutput', cmd = true },
      x = b { desc = 'signature help', vim.lsp.buf.signature_help },
    },
    f = keys {
      desc = 'loclist/trouble',
      d = b {
        desc = 'diagnostics',
        lazy_req(
          'my.utils.windows',
          'show_ui',
          'Trouble',
          'Trouble document_diagnostics'
        ),
      },
      s = b {
        desc = 'aerial symbols',
        lazy_req('my.utils.windows', 'show_ui', 'aerial', 'AerialOpen'),
      },
      h = b {
        desc = 'hunks',
        lazy_req('my.utils.windows', 'show_ui', 'Trouble', 'Gitsigns setqflist'),
      },
      u = b {
        desc = 'undo tree',
        lazy_req(
          'my.utils.windows',
          'show_ui',
          { 'undotree', 'diff' },
          'UndotreeToggle'
        ),
      },
    },
    h = np {
      desc = 'hunk',
      prev = function()
        print('www')
         require 'gitsigns'.prev_hunk()
      end,
      next = function()
        print('aaa')
         require 'gitsigns'.next_hunk()
      end,
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
          print 'up'
          require('neoscroll').scroll(-0.9, true, 250)
        end,
        next = function()
          print 'down'
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
          require('flies2.flies.search').search(false)
        end,
      },
      next = b {
        function()
          require('flies2.flies.search').search(true)
        end,
      },
    },
    ['<cr>'] = b { 'G', desc = 'line' },
  }
end

return M
