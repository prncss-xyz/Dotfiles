local M = {}

function M.extend()
  local cmd = require('binder.helpers').cmd
  local cmd_partial = require('binder.helpers').cmd_partial
  local d = require('my.config.binder.parameters').d
  local utils = require 'my.config.binder.utils'
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b

  local lazy_req = require('my.config.binder.utils').lazy_req
  return keys {
    a = keys {
      desc = 'dap',
      b = keys {
        prev = b {
          desc = 'clear breakpoints',
          lazy_req('dap', 'clear_breakpoints'),
        },
        next = b {
          desc = 'toggle breakpoints',
          lazy_req('dap', 'toggle_breakpoint'),
        },
      },
      c = b { desc = 'continue', lazy_req('dap', 'continue') },
      h = keys {
        prev = b {
          "<cmd>lua require'dap.ui.variables'.hover()<cr>",
          desc = 'hover',
        },
        next = b {
          "<cmd>lua require'dap.ui.widgets'.hover()<cr>",
          desc = 'widgets',
        },
      },
      i = b { desc = 'step into', lazy_req('dap', 'step_into') },
      -- l = b { desc = 'launch', lazy_req('dap', 'launch') },
      l = b { desc = 'launch', lazy_req('my.utils.dap', 'launch') },
      o = keys {
        prev = b { desc = 'step out', lazy_req('dap', 'step_out') },
        next = b {
          desc = 'step over',
          lazy_req('dap', 'step_over'),
        },
      },
      r = b { desc = 'repl open', lazy_req('dap', 'repl.open') },
      t = keys {
        c = b {
          "<cmd>lua require'telescope'.extensions.dap.commands{}<cr>",
          desc = 'commands',
        },
        [','] = b {
          "<cmd>lua require'telescope'.extensions.dap.configurations{}<cr>",
          desc = 'configurations',
        },
        b = b {
          "<cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<cr>",
          desc = 'list breakpoints',
        },
        v = b {
          "<cmd>lua require'telescope'.extensions.dap.variables{}<cr>",
          desc = 'dap variables',
        },
        f = b {
          "<cmd>lua require'telescope'.extensions.dap.frames{}<cr>",
          desc = 'dap frames',
        },
      },
      v = b {
        "<cmd>lua require'dap.ui.variables'.visual_hover()<cr>",
        desc = 'visual hover',
      },
      w = b {
        desc = 'ui',
        lazy_req('my.utils.ui_toggle', 'activate', 'dap', function()
          require('nvim-dap-virtual-text').enable()
          require('gitsigns').toggle_current_line_blame(false)
          require('dapui').open()
        end),
      },
      x = keys {
        prev = b { desc = 'disconnect', lazy_req('dap', 'disconnect') },
        next = b { desc = 'terminate', lazy_req('dap', 'terminate') },
      },
      ['.'] = b { desc = 'run last', lazy_req('dap', 'run_last') },
      [d.up] = b { desc = 'up', lazy_req('dap', 'up') },
      [d.down] = b { desc = 'down', lazy_req('dap', 'down') },
      ['?'] = b {
        "<cmd>lua require'dap.ui.variables'.scopes()<cr>",
        desc = 'variables scopes',
      },
      ['<cr>'] = b {
        desc = 'run to cursor',
        lazy_req('dap', 'run_to_cursor'),
      },
    },
    b = keys {
      desc = 'snippets',
      r = b {
        desc = 'reload',
        function()
          require('my.config.luasnip').load()
        end,
      },
      redup = b {
        desc = 'edit',
        function()
          require('luasnip.loaders').edit_snippet_files()
        end,
      },
    },
    c = keys {
      desc = 'tabs',
      redup = b {
        desc = 'open',
        'gt',
      },
      n = b {
        desc = 'new',
        cmd 'tabnew %',
      },
      d = keys {
        desc = 'tabmove ends',
        prev = b {
          cmd 'tabmove 0',
        },
        next = b {
          cmd 'tabmove $',
        },
      },
      v = keys {
        desc = 'tabmove',
        prev = b {
          cmd 'tabmove -',
        },
        next = b {
          cmd 'tabmove +',
        },
      },
      x = b {
        desc = 'close',
        cmd 'tabclose',
      },
    },
    --[[ c = b {
      desc = 'select adjacent command lines',
      require 'my.utils.select_comment',
    }, ]]
    d = keys {
      --   desc = 'show line',
      --   lazy('vim.diagnostic.open_float', nil, { source = 'always' }),
      c = keys {
        prev = b { desc = 'incoming calls', vim.lsp.buf.incoming_call },
        next = b { desc = 'outgoing calls', vim.lsp.buf.outgoing_calls },
      },

      e = b {
        desc = 'toggle emmet',
        function()
          require('my.utils.lsp').toggle_client 'emmet_ls'
        end,
      },
      s = b { desc = 'definition', vim.lsp.buf.definition },
      k = b { desc = 'hover', vim.lsp.buf.hover },
      r = b { desc = 'references', vim.lsp.buf.references },
      t = b { desc = 'go to type definition', vim.lsp.buf.type_definition },
      w = keys {
        desc = 'worspace folder',
        a = b {
          desc = 'add workspace folder',
          vim.lsp.buf.add_workspace_folder,
        },
        l = b {
          desc = 'ls workspace folder',
          vim.lsp.buf.list_workspace_folder,
        },
        d = b {
          desc = 'rm workspace folder',
          vim.lsp.buf.remove_workspace_folder,
        },
      },
      x = b { desc = 'signature help', vim.lsp.buf.signature_help },
    },
    e = keys {
      desc = 'help',
      redup = b {
        desc = 'tags',
        -- tab | horizontal | vertical
        function()
          require('telescope.builtin').help_tags {
            -- FIX: not working (seems like a bug in telescope)
            cmd = 'vertical',
          }
        end,
      },
      c = b {
        desc = 'highlights',
        lazy_req('telescope.builtin', 'highlights'),
      },
      d = b {
        desc = 'markdown files',
        lazy_req('telescope', 'extensions.my.md_help'),
      },
      f = b { desc = 'filetype docu', require('my.utils').docu_current },
      m = b {
        desc = 'man pages',
        lazy_req('telescope.builtin', 'man_pages'),
      },
      o = b {
        -- FIXME:
        desc = 'modules',
        lazy_req('telescope', 'extensions.my.modules'),
      },
      w = b {
        desc = 'docs view',
        lazy_req('my.utils.ui_toggle', 'activate', 'docs-view', function()
          require('my.utils.docs-view').reveal()
        end),
      },
      y = b {
        desc = 'uniduck',
        lazy_req('telescope', 'extensions.my.uniduck'),
      },
      h = b {
        desc = 'hoogle search signature',
        'req',
        'haskell-tools',
        'hoogle.hoogle_signature',
      },
    },
    f = keys {
      desc = 'file',
      d = b {
        desc = 'duplicate',
        function()
          require('khutulun').duplicate()
        end,
      },
      e = modes {
        n = b {
          desc = 'edit',
          function()
            require('khutulun').create()
          end,
        },
        x = b {
          desc = 'create new file from selection',
          function()
            require('khutulun').create_from_selection()
          end,
        },
      },
      h = keys {
        'git',
        s = b {
          desc = 'stage buffer',
          lazy_req('gitsigns', 'stage_buffer'),
          -- '<cmd>Gitsigns stage_buffer<cr>',
        },
        d = b {
          desc = 'diffview file history',
          lazy_req(
            'my.utils.ui_toggle',
            'activate',
            'diffview',
            'DiffviewFileHistory'
          ),
        },
        x = b {
          desc = 'reset buffer',
          function()
            require('my.utils.confirm').confirm(
              'Reset buffer (y/n)?',
              function()
                require('gitsigns').reset_buffer()
              end,
              true
            )
          end,
        },
      },
      w = b {
        desc = 'word count',
        cmd '!wc %',
      },
      y = keys {
        l = b {
          desc = 'yank filename',
          function()
            require('khutulun').yank_filename()
          end,
        },
        r = b {
          desc = 'yank relative filepath',
          function()
            require('khutulun').yank_relative_filepath()
          end,
        },
        y = b {
          desc = 'yank absolute filepath',
          function()
            require('khutulun').yank_absolute_filepath()
          end,
        },
      },
      b = b {
        desc = 'browse',
        'req',
        'my.utils.browser',
        'browse_file',
      },
      c = b {
        desc = 'most recent',
        'req',
        'my.utils.buffers',
        'edit_most_recent_file',
      },
      r = b {
        desc = 'rename',
        function()
          require('khutulun').rename()
        end,
      },
      s = b {
        desc = 'source',
        cmd 'update!|source %',
      },
      v = b {
        desc = 'move file',
        function()
          require('khutulun').move()
        end,
      },
      x = b {
        desc = 'delete file',
        function()
          require('khutulun').delete()
        end,
      },
    },
    -- g = keys {
    --   desc = 'runner',
    --   redup = modes {
    --     n = b {
    --       function()
    --         require('dash').execute()
    --       end,
    --     },
    --     x = b {
    --       function()
    --         require('dash').execute_visual()
    --       end,
    --     },
    --   },
    --   y = b {
    --     desc = 'dash connect<cr>',
    --     ':DashConnect<cr>',
    --   },
    --   m = b {
    --     desc = 'carrot eval',
    --     ':CarrotEval<cr>',
    --   },
    --   n = b {
    --     desc = 'carrot new block',
    --     ':CarrotNewBlock<cr>',
    --   },
    --   s = b {
    --     desc = 'dash step',
    --     b { lazy_req('dash', 'step') },
    --   },
    --   v = modes {
    --     desc = 'dash inspect',
    --     n = b { lazy_req('dash', 'inspect') },
    --     v = b { lazy_req('dash', 'vinspect') },
    --   },
    --   c = b {
    --     desc = 'dash continue',
    --     b { lazy_req('dash', 'continue') },
    --   },
    --   p = b {
    --     desc = 'dash toggle breakpoint',
    --     lazy_req('dash', 'toggle_breakpoint'),
    --   },
    -- },
    g = keys {
      desc = 'runners',
      redup = b {
        desc = 'raise',
        'req',
        'my.utils.repl',
        'focus',
      },
      s = b {
        desc = 'send',
        'req',
        'my.utils.repl',
        'send',
        modes = 'nx',
      },
      x = b {
        desc = 'stop',
        'req',
        'my.utils.repl',
        'stop',
      },
      d = b {
        desc = 'lsp codelens eval',
        'vim',
        'lsp.codelens.run',
      },
      l = b {
        desc = 'clear',
        'req',
        'my.utils.repl',
        'clear',
      },
      c = b {
        desc = 'interrupt',
        'req',
        'my.utils.repl',
        'interrupt',
      },
      p = keys {
        desc = 'scratch',
        prev = b {
          desc = 'select',
          'req',
          'my.utils.scratch',
          'select',
        },
        next = b {
          desc = 'open',
          'req',
          'my.utils.scratch',
          'open',
        },
      },
      ['<cr>'] = b {
        desc = 'cr',
        'req',
        'my.utils.repl',
        'cr',
      },
    },
    h = keys {
      desc = 'git',
      redup = keys {
        desc = 'hunk',
        d = b {
          desc = 'diff this',
          lazy_req('gitsigns', 'diffthis'),
        },
        e = b {
          desc = 'preview hunk',
          lazy_req('gitsigns', 'preview_hunk'),
        },
        s = keys {
          prev = b {
            desc = 'stage',
            lazy_req('gitsigns', 'undo_stage_hunk'),
          },
          next = b {
            desc = 'stage',
            lazy_req('gitsigns', 'stage_hunk'),
          },
        },
        v = b {
          desc = 'select',
          cmd = "':<C-U>Gitsigns select_hunk<CR>'",
        },
        x = b {
          desc = 'reset',
          lazy_req('gitsigns', 'reset_hunk'),
        },
      },
      a = b {
        desc = 'neogit',
        lazy_req('my.utils.ui_toggle', 'activate', 'neogit', 'Neogit'),
      },
      b = b {
        desc = 'branch',
        lazy_req('my.utils.ui_toggle', 'activate', 'neogit', function()
          require('neogit').open { 'branch' }
        end),
      },
      c = keys {
        desc = 'commit',
        prev = b {
          desc = 'popup',
          lazy_req('neogit', 'open', { 'commit' }), -- split, vsplit
        },
        redup = b {
          desc = 'commit',
          require('my.utils.git').commit,
        },
        a = b {
          desc = 'amend',
          require('my.utils.git').amend,
        },
      },
      d = keys {
        desc = 'diffview',
        prev = b {
          desc = 'diffview',
          lazy_req(
            'my.utils.ui_toggle',
            'activate',
            'diffview',
            'DiffviewOpen'
          ),
        },
      },
      k = b {
        desc = 'help',
        lazy_req('neogit', 'open', { 'help' }), -- split, vsplit
      },
      l = b {
        desc = 'log',
        lazy_req('neogit', 'open', { 'log' }), -- split, vsplit
      },
      p = keys {
        prev = b {
          desc = 'push',
          lazy_req('neogit', 'open', { 'push' }), -- split, vsplit
        },
        next = b {
          desc = 'pull',
          lazy_req('neogit', 'open', { 'pull' }), -- split, vsplit
        },
      },
      r = b {
        desc = 'rebase',
        lazy_req('neogit', 'open', { 'rebase' }), -- split, vsplit
      },
      z = b {
        desc = 'stash',
        lazy_req('neogit', 'open', { 'stash' }), -- split, vsplit
      },
      ['<cr>'] = b {
        desc = 'blame toggle',
        lazy_req('gitsigns', 'toggle_current_line_blame', { full = true }),
      },
    },
    i = keys {
      desc = 'messages (noice)',
      prev = b {
        desc = 'history',
        lazy_req('my.utils.ui_toggle', 'activate', 'noice', 'Noice history'),
      },
      next = b {
        desc = 'last',
        lazy_req('my.utils.ui_toggle', 'activate', 'noice', 'Noice last'),
      },
    },
    I = b {
      function()
        require('flies.operations.inspect'):call()
      end,
    },
    j = keys {
      desc = 'lsp',
      redup = b {
        desc = 'start',
        'req',
        'my.utils.lsp',
        'start',
      },
      z = b {
        desc = 'haskell eval all',
        'req',
        'haskell-tools',
        'lsp.buf_eval_all',
      },
    },
    k = keys {
      desc = 'lazy',
      redup = b { desc = 'home', cmd 'Lazy home' },
      c = b { desc = 'check health', cmd 'Lazy health' },
      d = b { desc = 'debug', cmd 'Lazy debug' },
      h = b { desc = 'help', cmd 'Lazy help' },
      i = b { desc = 'install', cmd 'Lazy install' },
      l = b { desc = 'log', cmd 'Lazy log' },
      p = b { desc = 'profile', cmd 'Lazy profile' },
      r = b { desc = 'reload', cmd_partial 'Lazy reload ' },
      s = b { desc = 'sync', cmd 'Lazy sync' },
      u = b { desc = 'update', cmd 'Lazy update' },
      x = b { desc = 'clean', cmd 'Lazy clean' },
    },
    l = keys {
      desc = 'neoclip',
      q = b {
        desc = 'marco',
        lazy_req('telescope', 'extensions.macroscope.default'),
      },
      r = b { desc = 'clip', lazy_req('telescope', 'extensions.neoclip.plus') },
      f = b { desc = 'clip', lazy_req('telescope', 'extensions.neoclip.f') },
      y = b {
        desc = 'yank',
        lazy_req('telescope', 'extensions.neoclip.default'),
      },
    },
    m = keys {
      desc = 'toggle',
      b = b {
        desc = 'background color',
        function()
          local theme = vim.cmd 'colorscheme'
          if theme == 'material' then
            require('material.functions').find_style()
            return
          end
          if vim.o.background == 'light' then
            vim.o.background = 'dark'
            return
          end
          vim.o.background = 'light'
        end,
      },
      c = b {
        desc = 'cursor conceal',
        require('my.utils.vim').toggle_conceal_cursor,
      },
      m = b {
        desc = 'foldsigns',
        function()
          if vim.wo.foldcolumn == '1' then
            vim.wo.foldcolumn = '0'
          else
            vim.wo.foldcolumn = '1'
          end
        end,
      },
      s = b {
        desc = 'conceal',
        require('my.utils.vim').toggle_conceal,
      },
      t = b {
        desc = 'theme',
        lazy_req('telescope.builtin', 'colorscheme'),
      },
    },
    n = keys {
      desc = 'zk',
      a = b {
        desc = 'open asset',
        require('my.utils.zk').open_asset,
      },
      redup = b {
        desc = 'notes',
        -- lazy_req('telescope', 'extensions.zk.notes'),
        lazy_req('telescope', 'extensions.my.zk_notes'),
      },
      c = b {
        desc = 'cd',
        lazy_req('zk', 'cd'),
      },
      d = b {
        desc = 'delete asset',
        require('my.utils.zk').remove_asset,
      },
      r = b {
        desc = 'refresh, index',
        lazy_req('zk', 'index'),
      },
      s = b {
        desc = 'put sdr',
        require('my.utils.zk').put_sdr,
      },
      l = keys {
        prev = b {
          desc = 'links',
          function()
            -- FIXME:
            require('telescope').extensions.my.zk_notes {
              title = 'links',
              linkBy = { vim.api.nvim_buf_get_name(0) },
              recursive = true,
            }
          end,
        },
        next = b {
          desc = 'backlinks',
          function()
            require('telescope').extensions.my.zk_notes {
              title = 'backlinks',
              linkTo = { vim.api.nvim_buf_get_name(0) },
              recursive = true,
            }
          end,
        },
      },
      j = b {
        desc = 'new journal entry',
        function()
          require('my.utils.zk').new_journal_entry 'journal'
        end,
      },
      z = keys {
        prev = b {
          desc = 'new note from content',
          require('my.utils.zk').new_note_from_content,
          modes = 'x',
        },
        next = modes {
          x = b {
            desc = 'new note with title',
            require('my.utils.zk').new_note_with_title,
          },
        },
      },
      o = b {
        desc = 'orphans',
        function()
          require('telescope').extensions.my.zk_notes {
            title = 'orphans',
            orphan = true,
          }
        end,
      },
      t = b {
        desc = 'tags',
        lazy_req('telescope', 'extensions.zk.tags'),
      },
    },
    o = keys {
      desc = 'overseer',
      redup = b {
        desc = 'run cmd',
        ':OverseerRun<cr>',
      },
      c = b {
        desc = 'run shell cmd',
        ':OverseerRunCmd<cr>',
      },
      z = b {
        desc = 'open',
        lazy_req('my.utils.ui_toggle', 'activate', 'overseer'),
      },
    },
    -- could merge with macroscope
    q = keys {
      desc = 'marco',
      prev = b {
        desc = 'record',
        'q',
      },
      next = b { desc = 'play', '@' }, -- @@ play again
      -- ['.'] = b { desc = 'play last', '@@' },
    },
    r = keys {
      desc = 'repl',
      redup = b {
        desc = 'send',
        'req',
        'my.utils.repl',
        'send',
        modes = 'nx',
      },
      c = b {
        desc = 'interrupt',
        'req',
        'my.utils.repl',
        'interrupt',
        modes = 'n',
      },
      f = b {
        desc = 'focus',
        'req',
        'my.utils.repl',
        'focus',
        modes = 'n',
      },
      x = b {
        desc = 'stop',
        'req',
        'my.utils.repl',
        'stop',
        modes = 'n',
      },
      h = b {
        desc = 'live eval',
        'req',
        'haskell-tools',
        'lsp.buf_eval_all',
      },
      l = b {
        desc = 'clear',
        'req',
        'my.utils.repl',
        'restart',
        modes = 'n',
      },
    },
    s = keys {
      desc = 'replace',
      redup = b { desc = 'muren open', cmd 'MurenOpen' },
      x = b { desc = 'muren close', cmd 'MurenClose' },
      t = b { desc = 'muren toggle', cmd 'MurenToggle' },
      f = b { desc = 'muren fresh', cmd 'MurenFresh' },
      u = b { desc = 'muren unique', cmd 'MurenUnique' },
      r = b { desc = 'ssr', 'req', 'ssr', 'open', modes = 'nx' },
      --[[ r = modes {
        n = keys {
          next = b {
            desc = 'spectre open',
            lazy_req('my.utils.ui_toggle', 'activate', 'spectre', function()
              require('spectre').open()
            end),
          },
          prev = b {
            desc = 'spectre open file seach',
            lazy_req('my.utils.ui_toggle', 'activate', 'spectre', function()
              require('spectre').open_file_search()
            end),
          },
        },
        x = keys {
          next = b {
            desc = 'spectre open visual',
            lazy_req('my.utils.ui_toggle', 'activate', 'spectre', function()
              require('spectre').open_visual()
            end),
          },
          prev = b {
            desc = 'spectre open visual select word',
            lazy_req('spectre', 'open_visual', { select_word = true }),
          },
        },
      }, ]]
    },
    t = keys {
      desc = 'neotest',
      T = b {
        desc = 'run nearest',
        function()
          if false and vim.bo.filetype == 'lua' then
            require('plenary.test_harness').test_directory(
              vim.fn.expand '%:p',
              { minimal_init = 'tests_init.lua' }
            )
          else
            vim.cmd.update()
            require('neotest').run.run()
          end
        end,
      },
      redup = b {
        desc = 'run',
        function()
          vim.cmd.update()
          -- require('neotest').overseer.run {}
          -- require('neotest').overseer.run { vim.fn.expand '%' }
          require('neotest').run.run { vim.fn.expand '%' }
        end,
      },
      w = b {
        dest = 'toggle watch',
        function()
          require 'neotest'
          if vim.g.watch_test then
            print 'not watching tests..'
            vim.g.watch_test = false
            require('neotest').summary.close()
          else
            print 'watching tests..'
            vim.g.watch_test = true
            require('neotest').summary.open()
          end
        end,
      },
      x = b {
        desc = 'stop',
        lazy_req('neotest', 'run.stop'),
      },
      o = b {
        desc = 'output',
        function()
          require('neotest').output.open { enter = true }
        end,
      },
      s = b {
        desc = 'summary',
        function()
          require('neotest').summary.toggle()
        end,
      },
      -- require("neotest").run.run({strategy = "dap"})
      -- require("neotest").run.attach()
    },
    u = keys {
      -- could merge with window
      prev = b { desc = 'scroll top', lazy_req('neoscroll', 'zt', 250) },
      next = b { desc = 'scroll bottom', lazy_req('neoscroll', 'zb', 250) },
      c = b { desc = 'scroll middle', lazy_req('neoscroll', 'zz', 250) },
    },
    v = b { desc = 'reselect', 'gv' },
    w = keys {
      desc = 'windows',
      prev = b { lazy_req('split', 'close'), desc = 'close' },
      d = b {
        desc = 'toggle tabs',
        'req',
        'telescope-tabs',
        'go_to_previous',
      },
      e = b {
        desc = 'focus',
        '<c-w>w',
      },
      f = b {
        desc = 'split float',
        lazy_req('my.utils.windows', 'split_float'),
      },
      h = b {
        desc = 'horizontal split equal',
        ':sp<cr>',
      },
      i = b {
        require('my.utils.windows').info,
      },
      j = modes {
        desc = 'open',
        n = b { lazy_req('split', 'open', {}, 'n') },
        x = b { lazy_req('split', 'open', {}, 'x') },
      },
      q = b { desc = 'lsp', lazy_req('split', 'open_lsp'), modes = 'nx' },
      r = modes {
        desc = 'pop',
        n = b { lazy_req('split', 'pop', { target = 'here' }, 'n') },
        x = b { lazy_req('split', 'pop', { target = 'here' }, 'x') },
      },
      w = b {
        desc = 'external',
        require('my.utils.windows').split_external,
      },
      z = keys {
        prev = b {
          desc = 'zen',
          'ZenMode',
          cmd = true,
        },
        next = b { require('my.utils.windows').zoom },
      },
      [';'] = b {
        utils.lazy(require('my.utils.windows').split_right, 100),
        desc = 'vertical 85',
      },
    },
    X = b {
      desc = 'telescope undo',
      function()
        require('telescope').extensions.undo.undo()
      end,
      -- ["<cr>"] = require("telescope-undo.actions").yank_additions,
      -- ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
      -- ["<C-cr>"] = require("telescope-undo.actions").restore,
    },
    y = keys {
      desc = 'browse',
      redup = b {
        desc = 'search',
        'req',
        'my.utils.browser',
        'search',
        modes = 'nx',
      },
      u = b {
        desc = 'link',
        'req',
        'my.utils.browser',
        'browse_link',
      },
      d = b {
        desc = 'server',
        'req',
        'my.utils.browser',
        'browse_server',
      },
    },
    -- f = b { desc = 'xplr', require('utils').xplr_launch },
    ['<tab>'] = keys {
      f = b {
        desc = 'Femaco',
        '<cmd>Femaco<cr>',
      },
      g = b {
        desc = 'TSPlayground',
        'req',
        'my.utils.ui_toggle',
        'activate',
        'tsplayground',
      },
      h = b {
        desc = 'TSHighlightCapturesUnderCursor',
        '<cmd>TSHighlightCapturesUnderCursor<cr>',
      },
    },
    [' '] = b {
      desc = 'command',
      function()
        require('my.utils').keys ':'
      end,
      modes = 'nx',
    },
  }
end

return M
