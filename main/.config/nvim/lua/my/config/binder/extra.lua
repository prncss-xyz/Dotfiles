local M = {}

function M.extend()
  local d = require('my.config.binder.parameters').d
  local utils = require 'my.config.binder.utils'
  local binder = require 'binder'
  local keys = binder.keys
  local modes = binder.modes
  local b = binder.b
  local search_cword = require('my.utils.browser').search_cword
  local search_visual = require('my.utils.browser').search_visual

  local function map_search(base, desc)
    return modes {
      desc = desc,
      n = b {
        function()
          search_cword(base)
        end,
      },
      x = b {
        function()
          search_visual(base)
        end,
      },
    }
  end

  local function devdocs(mode)
    local base = 'https://devdocs.io/#q='
    local ft = vim.bo.filetype
    if ft ~= '' then
      base = base .. ' ' .. ft .. ' '
    end
    if mode == 'n' then
      search_cword(base)
    else
      search_visual(base)
    end
  end

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
      l = b { desc = 'launch', lazy_req('my.config.dap', 'launch') },
      o = keys {
        prev = b { desc = 'step out', lazy_req('dap', 'step_out') },
        next = b {
          desc = 'step over',
          lazy_req('dap', 'step_over'),
        },
      },
      r = b { desc = 'repl open', lazy_req('dap', 'repl.open') },
      s = b {
        desc = 'dap launch',
        function()
          require('my.utils.dap').launch()
        end,
      },
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
    c = b {
      desc = 'select adjacent command lines',
      require 'my.utils.select_comment',
    },
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
            -- FIXME: not working
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
      d = b {
        desc = 'duplicate file',
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
      y = keys {
        l = b {
          desc = 'yank filename',
          function()
            require('khutulun').yank_filename()
          end,
        },
        y = b {
          desc = 'yank filepath',
          function()
            require('khutulun').yank_filepath()
          end,
        },
      },
      r = b {
        desc = 'rename file',
        function()
          require('khutulun').rename()
        end,
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
    g = keys {
      desc = 'runner',
      redup = modes {
        n = b {
          function()
            require('dash').execute()
          end,
        },
        x = b {
          function()
            require('dash').execute_visual()
          end,
        },
      },
      y = b {
        desc = 'dash connect<cr>',
        ':DashConnect<cr>',
      },
      m = b {
        desc = 'carrot eval',
        ':CarrotEval<cr>',
      },
      n = b {
        desc = 'carrot new block',
        ':CarrotNewBlock<cr>',
      },
      s = b {
        desc = 'dash step',
        b { lazy_req('dash', 'step') },
      },
      v = modes {
        desc = 'dash inspect',
        n = b { lazy_req('dash', 'inspect') },
        v = b { lazy_req('dash', 'vinspect') },
      },
      c = b {
        desc = 'dash continue',
        b { lazy_req('dash', 'continue') },
      },
      p = b {
        desc = 'dash toggle breakpoint',
        lazy_req('dash', 'toggle_breakpoint'),
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
        next = b {
          desc = 'diffview file history',
          lazy_req(
            'my.utils.ui_toggle',
            'activate',
            'diffview',
            'DiffviewFileHistory'
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
      s = b {
        desc = 'stage buffer',
        lazy_req('gitsigns', 'stage_buffer'),
        -- '<cmd>Gitsigns stage_buffer<cr>',
      },
      x = b {
        desc = 'reset buffer',
        function()
          require('my.utils.confirm').confirm('Reset buffer (y/n)?', function()
            require('gitsigns').reset_buffer()
          end, true)
        end,
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
    i = b {
      desc = 'messages (noice)',
      '<cmd>Noice<cr>',
    },
    j = keys {
      desc = 'typescript',
      -- Despite the name, this command fixes a handful of specific issues,
      -- most notably non-async functions that use await and unreachable code.
      a = b {
        desc = 'fix all',
        'req',
        'vtsls',
        'commands.fix_all',
        -- lazy_req('typescript', 'actions.fixAll'),
      },
      o = b {
        desc = 'organize imports',
        'req',
        'vtsls',
        'commands.oraanize_imports',
        -- lazy_req('typescript', 'actions.organizeImports'),
      },
      s = b {
        desc = 'go to source definition',
        'req',
        'vtsls',
        'commands.goto_source_definition',
      },
      -- operates with full paths: .renameFile(source, target)
      v = b {
        desc = 'rename file',
        'req',
        'vtsls',
        'commands.rename_file',
        -- '<cmd>TypescriptRenameFile<cr>',
      },
      y = b {
        desc = 'add missing imports',
        'req',
        'vtsls',
        'commands.add_missing_imports',
        -- lazy_req('typescript', 'actions.addMissingImports'),
      },
      x = b {
        desc = 'remove unused',
        'req',
        'vtsls',
        'commands.remove_unused_imports',
        -- lazy_req('typescript', 'actions.removeUnused'),
      },
      z = b {
        desc = 'haskell eval all',
        'req',
        'haskell-tools',
        'lsp.buf_eval_all',
      },
    },
    k = keys {
      c = b {
        desc = 'PackerCompile',
        '<cmd>PackerCompile<cr>',
      },
      i = b {
        desc = 'PackerInstall',
        '<cmd>PackerInstall<cr>',
      },
      m = b {
        desc = 'StartupTime',
        '<cmd>StartupTime<cr>',
      },
      p = b {
        desc = 'PackerProfile',
        '<cmd>PackerProfile<cr>',
      },
      r = b {
        desc = 'Reload',
        require('my.utils.buffers').reload,
      },
      s = b {
        desc = 'PackerSync',
        '<cmd>PackerSync<cr>',
      },
      t = b {
        desc = 'PackerStatus',
        '<cmd>PackerStatus<cr>',
      },
      u = b {
        desc = 'PackerUpdate',
        '<cmd>PackerUpdate<cr>',
      },
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
          -- FIXME:
          local theme = vim.api.nvim_exec('colorscheme', true)
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
      f = b {
        desc = 'fold (markdown)',
        '<cmd>FoldToggle<cr>',
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
      q = b {
        desc = 'open',
        lazy_req('my.utils.ui_toggle', 'activate', 'overseer', 'OverseerOpen'),
      },
      y = b {
        desc = 'browse dev',
        require('my.utils.browser').browse_dev,
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
      redup = modes {
        desc = 'repl send',
        n = b {
          function()
            require('flies.operations.act').exec(
              { domain = 'outer', around = 'never' },
              nil,
              require('iron.core').visual_send
            )
          end,
        },
        x = b {
          'req',
          'iron.core',
          'visual_send',
        },
      },
      c = b {
        desc = 'interrupt',
        function()
          require('iron.core').send(nil, string.char(3))
        end,
      },
      d = b {
        desc = 'cr',
        function()
          require('iron.core').send(nil, string.char(13))
        end,
      },
      h = b {
        desc = 'live eval',
        'req',
        'haskell-tools',
        'lsp.buf_eval_all',
      },
      l = b {
        desc = 'cr',
        function()
          require('iron.core').send(nil, string.char(12))
        end,
      },
      q = b {
        desc = 'close',
        'req',
        'iron.core',
        'close_repl',
      },
      --[[
        send_mark = {{'n'}, core.send_mark},
        mark_visual = {{'v'}, core.mark_visual},
        remove_mark = {{'n'}, marks.drop_last},
        clear_hl = {{'v'}, marks.clear_hl},
      --]]
    },
    s = modes {
      desc = 'spectre',
      n = keys {
        next = b {
          desc = 'open',
          lazy_req('my.utils.ui_toggle', 'activate', 'spectre', function()
            require('spectre').open()
          end),
        },
        prev = b {
          desc = 'open file seach',
          lazy_req('my.utils.ui_toggle', 'activate', 'spectre', function()
            require('spectre').open_file_search()
          end),
        },
      },
      x = keys {
        next = b {
          desc = 'open visual',
          lazy_req('my.utils.ui_toggle', 'activate', 'spectre', function()
            require('spectre').open_visual()
          end),
        },
        prev = b {
          desc = 'open visual select word',
          lazy_req('spectre', 'open_visual', { select_word = true }),
        },
      },
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
          if true and vim.bo.filetype == 'lua' then
            require('plenary.test_harness').test_directory(vim.fn.expand '%:p')
          else
            require('my.utils.relative_files').test_current_file()
            -- vim.cmd.update()
            -- require('neotest').run.run { vim.fn.expand '%' }
          end
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
    -- x = keys {
    --   desc = 'tester',
    --   n = b {
    --     function ()
    --       require "flies.operations.move_again".next()
    --     end
    --   },
    --   p = b {
    --     function ()
    --       require "flies.operations.move_again".prev()
    --     end
    --   },
    --   x = b {
    --     function()
    --       require('flies.operations.move').exec()
    --     end,
    --   },
    -- },
    -- x = modes {
    --   desc = 'tester',
    --   n = b {
    --     function()
    --       require('flies.operations.wrap').exec 'n'
    --     end,
    --   },
    --   x = b {
    --     function()
    --       require('flies.operations.wrap').exec 'x'
    --     end,
    --   },
    -- },
    -- x = keys {
    --   redup = b {
    --     desc = 'tester',
    --     function()
    --       require('flies.operations.select').exec()
    --     end,
    --   },
    --   r = b {
    --     desc = 'refactoring telescope',
    --     function()
    --       require('telescope').extensions.refactoring.refactors()
    --     end,
    --   },
    -- },
    y = keys {
      desc = 'search',
      arch = map_search(
        'https://wiki.archlinux.org/index.php?search=',
        'archlinux wiki'
      ),
      aur = map_search(
        'https://aur.archlinux.org/packages/?K=',
        'aur packages'
      ),
      ca = map_search(
        'https://www.cairn.info/resultats_recherche.php?searchTerm=',
        'cairn'
      ),
      cn = map_search('https://www.cnrtl.fr/definition/', 'cnrtl'),
      ddg = map_search('https://duckduckgo.com/?q=', 'duckduckgo'),
      dds = modes {
        desc = 'devdocs',
        n = b {
          function()
            devdocs 'n'
          end,
        },
        x = b {
          function()
            devdocs 'x'
          end,
        },
      },
      eru = map_search(
        'https://www.erudit.org/fr/recherche/?funds=%C3%89rudit&funds=UNB&basic_search_term=',
        'erudit'
      ),
      fr = map_search(
        'https://pascal-francis.inist.fr/vibad/index.php?action=search&terms=',
        'francis'
      ),
      gh = map_search('https://github.com/search?q=', 'github'),
      go = map_search('https://google.ca/search?q=', 'google'),
      lh = map_search('https://www.libhunt.com/search?query=', 'libhunt'),
      mdn = map_search('https://developer.mozilla.org/en-US/search?q=', 'mdn'),
      nell = map_search(
        'https://nelligan.ville.montreal.qc.ca/search*frc/a?searchtype=Y&searcharg=',
        'nelligan'
      ),
      npm = map_search('https://www.npmjs.com/search?q=', 'npm'),
      o = b {
        desc = 'open current cfile',
        '<cmd>call jobstart(["xdg-open", expand("<cfile>")]<cr>, {"detach": v:true})<cr>',
      },
      pac = map_search('https://archlinux.org/packages/?q=', 'arch packages'),
      sea = map_search('https://www.seriouseats.com/search?q=', 'seriouseats'),
      sep = map_search(
        'https://plato.stanford.edu/search/searcher.py?query=',
        'sep'
      ),
      sp = map_search('https://www.persee.fr/search?ta=article&q=', 'persée'),
      st = map_search(
        'https://usito.usherbrooke.ca/d%C3%A9finitions/',
        'usito'
      ),
      u = b {
        desc = 'browse current cfile',
        require('my.utils.browser').browse_cfile,
      },
      we = map_search('https://en.wikipedia.org/wiki/', 'wikipidia en'),
      wf = map_search('https://fr.wikipedia.org/wiki/', 'wikipidia fr'),
      y = map_search(
        'https://www.youtube.com/results?search_query=',
        'youtube'
      ),
    },
    -- f = b { desc = 'xplr', require('utils').xplr_launch },
    z = keys {
      desc = 'harpoon',
      redup = keys {
        redup = b {
          desc = 'harpoon ui',
          lazy_req('harpoon.ui', 'toggle_quick_menu'),
        },
      },
      y = b { desc = 'harpoon add', lazy_req('harpoon.mark', 'add_file') },
      [' '] = b {
        desc = 'harpoon command menu',
        lazy_req('harpoon.cmd-ui', 'toggle_quick_menu'),
      },
    },
    ['<tab>'] = keys {
      f = b {
        desc = 'Femaco',
        '<cmd>Femaco<cr>',
      },
      g = b {
        desc = 'TSPlaygroundToggle',
        '<cmd>TSPlaygroundToggle<cr>',
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
