local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'my.config.binder.utils'
  local np = util.np
  local lazy_req = util.lazy_req
  return keys {
    redup = keys {
      desc = 'telescope',
      -- also: require("luasnip.extras.select_choice")
      a = b {
        desc = 'oldfiles',
        lazy_req('telescope.builtin', 'oldfiles', { only_cwd = true }),
      },
      b = b {
        desc = 'buffers',
        lazy_req('telescope.builtin', 'buffers'),
      },
      c = b {
        desc = 'repo',
        lazy_req('telescope', 'extensions.repo.list'),
      },
      e = b {
        desc = 'files (workspace)',
        function()
          if false then
            require('telescope.builtin').find_files {
              prompt_title = 'files (project)',
              find_command = {
                'rg',
                '--files',
                '--hidden',
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
            prompt_title = 'files (workspace)',
            find_command = {
              'fd',
              '--hidden',
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
            prompt_title = 'files (local)',
            cwd = vim.fn.expand '%:p:h',
            find_command = {
              'fd',
              '--hidden',
              '--type',
              'f',
              '--strip-cwd-prefix',
            },
          }
        end,
      },
      g = b {
        desc = 'recent buffer',
        'req',
        'buffstory',
        'select',
      },
      h = b {
        desc = 'git status',
        function()
          require('telescope.builtin').git_status()
        end,
      },
      k = b {
        desc = 'node modules',
        lazy_req('telescope', 'extensions.my.modules'),
      },
      m = b {
        desc = 'plugins',
        function()
          require('telescope').extensions.repo.list {
            prompt_title = 'nvim plugins',
            cwd = '/prncss/home/.local/share/nvim/',
            search_dirs = { '~/.local/share/nvim/site/pack' },
          }
        end,
        -- lazy_req('telescope', 'extensions.my.installed_plugins'),
      },
      n = b {
        desc = 'notes',
        -- lazy_req('telescope', 'extensions.zk.notes'),
        lazy_req('telescope', 'extensions.my.zk_notes'),
      },
      r = b {
        desc = 'references',
        lazy_req('telescope.builtin', 'lsp_references'),
      },
      s = b {
        desc = 'workspace symbols',
        lazy_req('telescope.builtin', 'lsp_workspace_symbols'),
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

    e = b { desc = 'buf 1', lazy_req('buffstory', 'open', 1) },
    r = b { desc = 'buf 2', lazy_req('buffstory', 'open', 2) },
    t = b { desc = 'buf 3', lazy_req('buffstory', 'open', 3) },
    y = b { desc = 'buf 4', lazy_req('buffstory', 'open', 4) },
    k = b {
      desc = 'harpoon terminal 1',
      lazy_req('harpoon.term', 'gotoTerminal', 1),
    },
    l = b {
      desc = 'harpoon terminal 2',
      lazy_req('harpoon.term', 'gotoTerminal', 2),
    },
    [';'] = b {
      desc = 'repl terminal',
      'vim',
      'cmd',
      'IronFocus',
    },
    -- update "main/.config/nvim/lua/plugins/neo-tree.lua"
    u = b { desc = 'harpoon file 1', lazy_req('harpoon.ui', 'nav_file', 1) },
    i = b { desc = 'harpoon file 2', lazy_req('harpoon.ui', 'nav_file', 2) },
    o = b { desc = 'harpoon file 3', lazy_req('harpoon.ui', 'nav_file', 3) },
    p = b {
      desc = 'harpoon file 4',
      lazy_req('harpoon.ui', 'nav_file', 4),
    },
    a = b {
      desc = 'test file',
      function()
        require('my.utils.relative_files').alternative 'test'
      end,
    },
    b = keys {
      desc = 'bookmark',
      a = keys {
        desc = '0',
        prev = b { lazy_req('marks', 'prev_bookmark0') },
        next = b { lazy_req('marks', 'next_bookmark0') },
      },
      s = keys {
        desc = '1',
        prev = b { lazy_req('marks', 'prev_bookmark1') },
        next = b { lazy_req('marks', 'next_bookmark1') },
      },
      d = keys {
        desc = '2',
        prev = b { lazy_req('marks', 'prev_bookmark2') },
        next = b { lazy_req('marks', 'next_bookmark2') },
      },
      f = keys {
        desc = '3',
        prev = b { lazy_req('marks', 'prev_bookmark3') },
        next = b { lazy_req('marks', 'next_bookmark3') },
      },
    },
    c = b {
      desc = 'snippets',
      lazy_req('my.utils.snippets', 'edit'),
      -- require('my.utils.snippets').edit,
    },
    d = keys {
      desc = 'unimpaired directory',
      prev = b { '<Plug>(unimpaired-directory-previous)' },
      next = b { '<Plug>(unimpaired-directory-next)' },
    },
    f = keys {
      desc = 'quickfix/trouble/tree',
      b = b {
        desc = 'buffers',
        lazy_req('my.utils.windows', 'show_ui', 'neo-tree', 'Neotree buffers'),
      },
      d = b {
        desc = 'diagnostics',
        lazy_req(
          'my.utils.windows',
          'show_ui',
          'Trouble',
          'Trouble workspace_diagnostics'
        ),
      },
      f = b {
        desc = 'neo-tree',
        lazy_req('my.utils.windows', 'show_ui', 'neo-tree', 'Neotree'),
      },
      -- FIXME:
      g = b { require('my.utils.windows').show_ui_last, desc = 'last ui' },
      h = b {
        desc = 'neo-tree git',
        lazy_req(
          'my.utils.windows',
          'show_ui',
          'neo-tree',
          'Neotree git_status'
        ),
      },
      n = b {
        desc = 'zk',
        lazy_req(
          'my.utils.windows',
          'show_ui',
          'neo-tree',
          'Neotree source=neo-tree-zk'
        ),
      },
      l = b {
        desk = 'bookmarks',
        function()
          require('marks').bookmark_state:all_to_list 'quickfixlist'
          require('my.utils.windows').show_ui('Trouble', 'Trouble quickfix')
        end,
      },
      r = b {
        desc = 'trouble references',
        lazy_req(
          'my.utils.windows',
          'show_ui',
          'Trouble',
          'Trouble lsp_references'
        ),
      },
      w = b {
        lazy_req('my.utils.windows', 'show_ui', 'Trouble', 'TodoTrouble'),
      },
      x = b { require('my.utils.windows').show_ui, desc = 'close ui' },
    },
    g = b {
      desc = 'last buffer',
      function()
        require('buffstory').last()
      end,
    },
    n = b {
      desc = 'follow filename',
      'gf',
    },
    s = b {
      desc = 'snapshot file',
      function()
        require('my.utils.relative_files').alternative 'snapshot'
      end,
    },
    v = b {
      desc = 'css file',
      function()
        require('my.utils.relative_files').alternative 'css'
      end,
    },
    x = b {
      desc = 'edit playground file',
      require('my.utils.buffers').edit_playground_file,
    },
    ['.'] = b {
      desc = 'config file',
      function()
        require('my.utils.relative_files').projection 'config'
      end,
    },
  }
end

return M
