local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local utils = require 'plugins.binder.utils'
  local lazy_req = utils.lazy_req
  local repeatable = utils.repeatable

  -- NOTE:
  -- vim.keymap.set('n', 'q<space>', function()
  --   utils.keys ':'
  -- end)
  -- vim.keymap.set('x', 'q<space>', function()
  --   utils.keys ':'
  -- end)

  return keys {
    redup = keys {
      prev = b { require('utils.windows').show_ui_last, desc = 'last ui' },
      next = b { require('utils.windows').show_ui, desc = 'close ui' },
    },
    b = keys {
      desc = 'runner',
      redup = b {
        desc = 'dash run',
        ':DashRun<cr>',
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
        repeatable { lazy_req('dash', 'step') },
      },
      v = modes {
        desc = 'dash inspect',
        n = b { lazy_req('dash', 'inspect') },
        v = b { lazy_req('dash', 'vinspect') },
      },
      c = b {
        desc = 'dash continue',
        repeatable { lazy_req('dash', 'continue') },
      },
      p = b {
        desc = 'dash toggle breakpoit',
        lazy_req('dash', 'toggle_breakpoint'),
      },
    },
    c = keys {
      desc = 'windows',
      -- TODO: zoom
      prev = b { lazy_req('split', 'close'), desc = 'close' },
      q = b { desc = 'lsp', lazy_req('split', 'open_lsp'), modes = 'nx' },
      r = modes {
        desc = 'pop',
        n = b { lazy_req('split', 'pop', { target = 'here' }, 'n') },
        x = b { lazy_req('split', 'pop', { target = 'here' }, 'x') },
      },
      e = b {
        desc = 'swap',
        require('utils.windows').winpick_swap,
      },
      h = b {
        desc = 'horizontal split equal',
        ':sp<cr>',
      },
      j = modes {
        desc = 'open',
        n = b { lazy_req('split', 'open', {}, 'n') },
        x = b { lazy_req('split', 'open', {}, 'x') },
      },
      n = keys {
        prev = b {
          desc = 'clone to',
          require('utils.windows').winpick_clone_to,
        },
        next = b {
          desc = 'clone from',
          require('utils.windows').winpick_clone_from,
        },
      },
      x = b {
        desc = 'close',
        require('utils.windows').winpick_close,
      },
      w = b {
        desc = 'external',
        require('utils.windows').split_external,
      },
      z = keys {
        prev = b {
          desc = 'zen',
          'ZenMode',
          cmd = true,
        },
        next = b { require('utils.windows').zoom },
      },
      [';'] = b {
        utils.lazy(require('utils.windows').split_right, 85),
        desc = 'vertical 85',
      },
    },
    d = b { desc = 'filetype docu', require('utils').docu_current },
    e = keys {
      prev = b { desc = 'reset editor', require('utils').reset_editor },
      next = b {
        desc = 'current in new editor',
        require('utils').edit_current,
      },
    },
    h = keys {
      desc = 'git',
      redup = b {
        desc = 'neogit',
        lazy_req('utils.windows', 'show_ui', 'Neogit', 'Neogit'),
      },
      b = b {
        desc = 'branch',
        lazy_req(
          'utils.windows',
          'show_ui',
          'Neogit',
          lazy_req('neogit', 'open')
        ),
      },
      c = b {
        desc = 'commit',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      d = keys {
        desc = 'diffview',
        prev = b {
          desc = 'diffview',
          lazy_req('utils.windows', 'show_ui', 'Diffview', 'DiffviewOpen'),
        },
        next = b {
          desc = 'diffview file history',
          lazy_req(
            'utils.windows',
            'show_ui',
            'Diffview',
            'DiffviewFileHistory'
          ),
        },
      },
      H = b {
        desc = 'help',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      l = b {
        desc = 'log',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      p = keys {
        prev = b {
          desc = 'push',
          lazy_req('neogit', 'open'), -- split, vsplit
        },
        next = b {
          desc = 'pull',
          lazy_req('neogit', 'open'), -- split, vsplit
        },
      },
      r = b {
        desc = 'rebase',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      z = b {
        desc = 'stash',
        lazy_req('neogit', 'open'), -- split, vsplit
      },
      ['<cr>'] = b {
        desc = 'blame toggle',
        lazy_req('gitsigns', 'toggle_current_line_blame', { full = true }),
      },
    },
    i = b {
      desc = 'messages',
      '<cmd>Noice<cr>',
    },
    r = modes {
      desc = 'spectre',
      n = keys {
        next = b {
          desc = 'open',
          lazy_req('spectre', 'open'),
        },
        prev = b {
          desc = 'open file seach',
          lazy_req('spectre', 'open_file_search'),
        },
      },
      x = keys {
        next = b {
          desc = 'open visual',
          lazy_req('spectre', 'open_visual'),
        },
        prev = b {
          desc = 'open visual select word',
          lazy_req('spectre', 'open_visual', { select_word = true }),
        },
      },
    },
    j = keys {
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
    m = keys {
      desc = 'toggle',
      s = b {
        desc = 'toggle conceal',
        require('utils.vim').toggle_conceal,
      },
      t = b {
        desc = 'toggle cursor conceal',
        require('utils.vim').toggle_conceal_cursor,
      },
      m = b {
        desc = 'toggle foldsigns',
        function()
          if vim.wo.foldcolumn == '1' then
            vim.wo.foldcolumn = '0'
          else
            vim.wo.foldcolumn = '1'
          end
        end,
      },
    },
    l = keys {
      desc = 'loclist/trouble',
      d = b {
        desc = 'diagnostics',
        lazy_req(
          'utils.windows',
          'show_ui',
          'Trouble',
          'Trouble document_diagnostics'
        ),
      },
      h = b {
        desc = 'hunks',
        lazy_req('utils.windows', 'show_ui', 'Trouble', 'Gitsigns setqflist'),
      },
    },
    o = b {
      desc = 'open current external',
      require('utils').open_current,
    },
    -- t = b { desc = 'new terminal', require('utils').term },
    -- could merge with neo-tree
    t = keys {
      desc = 'quickfix/trouble/tree',
      b = b {
        desc = 'buffers',
        lazy_req('utils.windows', 'show_ui', 'neo-tree', 'Neotree buffers'),
      },
      d = b {
        desc = 'diagnostics',
        lazy_req(
          'utils.windows',
          'show_ui',
          'Trouble',
          'Trouble workspace_diagnostics'
        ),
      },
      f = b {
        desc = 'neo-tree',
        lazy_req('utils.windows', 'show_ui', 'neo-tree', 'Neotree'),
      },
      h = keys {
        desc = 'neo-tree git',
        lazy_req('utils.windows', 'show_ui', 'neo-tree', 'Neotree git_status'),
      },
      n = b {
        desc = 'zk',
        function()
          require('utils.windows').show_ui('neo-tree', function()
            vim.cmd 'Neotree source=zk'
          end)
        end,
      },
      l = b {
        desk = 'bookmarks',
        function()
          require('marks').bookmark_state:all_to_list 'quickfixlist'
          require('utils.windows').show_ui('Trouble', 'Trouble quickfix')
        end,
      },
      r = b {
        desc = 'trouble references',
        ':Trouble lsp_references<cr>',
      },
      w = b {
        lazy_req('utils.windows', 'show_ui', 'Trouble', 'TodoTrouble'),
      },
    },
    u = b {
      desc = 'undo tree',
      lazy_req(
        'utils.windows',
        'show_ui',
        { 'undotree', 'diff' },
        'UndotreeToggle'
      ),
    },
    v = keys {
      prev = b {
        desc = 'projects (directory)',
        lazy_req('telescope', 'extensions.my.project_directory'),
      },
      next = b {
        desc = 'projects',
        lazy_req('telescope', 'extensions.my.projects'),
      },
    },
    w = keys {
      desc = 'telescope',
      e = b {
        desc = 'files (workspace)',
        function()
          if true then
            require('telescope.builtin').find_files {
              find_command = {
                'rg',
                '--files',
                '--hidden',
                '-g',
                '!.git',
              },
            }
            return
          end
          if false then
            -- FIX:  fd results seems to diverge from what is met when called from command line
            -- in particular, some (but not all) hidden files are missing
            -- using git_files as a workarount
            require('telescope.builtin').git_files()
            return
          end
          require('telescope.builtin').find_files {
            find_command = {
              'fd',
              '--hidden',
              '--exclude',
              '.git',
              '--type',
              'f',
              '--strip-cwd-prefix',
            },
          }
        end,
      },
      f = b {
        desc = 'files (local)',
        function()
          require('telescope.builtin').find_files {
            cwd = vim.fn.expand '%:p:h',
            find_command = {
              'fd',
              '--hidden',
              '--exclude',
              '.git',
              '--type',
              'f',
              '--strip-cwd-prefix',
            },
          }
        end,
      },
      g = b {
        desc = 'buffstory select recent buffer',
        lazy_req('buffstory', 'select'),
      },
      h = b {
        desc = 'telescope status',
        function()
          require('telescope.builtin').git_status()
        end,
      },
      b = b {
        desc = 'buffers',
        lazy_req('telescope.builtin', 'buffers'),
      },
      c = b {
        desc = 'telescope repo',
        lazy_req('telescope', 'extensions.repo.list'),
      },
      -- FIXME:
      k = b {
        desc = 'node modules',
        lazy_req('telescope', 'extensions.my.node_modules'),
      },
      m = b {
        desc = 'plugins',
        lazy_req('telescope', 'extensions.my.installed_plugins'),
      },
      n = b {
        desc = 'notes',
        -- lazy_req('telescope', 'extensions.zk.notes'),
        lazy_req('telescope', 'extensions.my.zk_notes'),
      },
      o = b {
        desc = 'oldfiles',
        lazy_req('telescope.builtin', 'oldfiles', { only_cwd = true }),
      },
      r = b {
        desc = 'telescope references',
        function()
          require('telescope.builtin').lsp_references {}
        end,
      },
      w = b {
        desc = 'todo',
        lazy_req('telescope', 'extensions.todo-comments.todo'),
      },
      ['é'] = keys {
        prev = b {
          desc = 'live grep (workspace)',
          function()
            require('telescope.builtin').live_grep {
              prompt_title = 'live grep (workspace)',
            }
          end,
        },
        next = b {
          desc = 'live grep (local)',
          function()
            require('telescope.builtin').live_grep {
              prompt_title = 'live grep (local)',
              search_dirs = { vim.fn.expand('%:h', nil, nil) },
            }
          end,
        },
      },
    },
    -- w = b {
    --   desc = 'docs view',
    --   function()
    --     require('utils.windows').show_ui('docs-view', function()
    --       require('utils.docs-view').reveal()
    --     end)
    --   end,
    -- },
    x = b { desc = 'xplr', require('utils').xplr_launch },
    y = keys {
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
      m = b {
        desc = 'man pages',
        lazy_req('telescope.builtin', 'man_pages'),
      },
      o = b {
        -- FIXME:
        desc = 'modules',
        lazy_req('telescope', 'extensions.my.modules'),
      },
      y = b {
        desc = 'uniduck',
        lazy_req('telescope', 'extensions.my.uniduck'),
      },
    },
    z = keys {
      desc = 'neoclip',
      q = b {
        desc = 'marco',
        lazy_req('telescope', 'extensions.macroscope.default'),
      },
      r = b { desc = 'clip', lazy_req('telescope', 'extensions.neoclip.+') },
      f = b { desc = 'clip', lazy_req('telescope', 'extensions.neoclip.f') },
      y = b {
        desc = 'yank',
        lazy_req('telescope', 'extensions.neoclip.default'),
      },
    },
    ['<space>'] = b {
      desc = 'command',
      function()
        utils.keys ':'
      end,
      modes = 'nx',
    },
  }
end

return M
