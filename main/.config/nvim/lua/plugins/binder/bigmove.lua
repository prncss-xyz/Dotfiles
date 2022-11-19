local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local modes = binder.modes
  local util = require 'plugins.binder.utils'
  local np = util.np
  local lazy_req = util.lazy_req
  require('key-menu').set('n', 'zb')
  require('key-menu').set('n', 'zp')
  return keys {
    redup = keys {
      redup = b {
        desc = 'harpoon ui',
        lazy_req('harpoon.ui', 'toggle_quick_menu'),
      },
      y = b { desc = 'harpoon add', lazy_req('harpoon.mark', 'add_file') },
      j = b { desc = 'harpoon file 1', lazy_req('harpoon.ui', 'nav_file', 1) },
      k = b { desc = 'harpoon file 2', lazy_req('harpoon.ui', 'nav_file', 2) },
      l = b { desc = 'harpoon file 3', lazy_req('harpoon.ui', 'nav_file', 3) },
      [';'] = b {
        desc = 'harpoon file 4',
        lazy_req('harpoon.ui', 'nav_file', 4),
      },
      [' '] = b {
        desc = 'harpoon command menu',
        lazy_req('harpoon.cmd-ui', 'toggle_quick_menu'),
      },
    },
    -- a = b { desc = 'test file', require('utils.buffers').edit_alt },
    a = b {
      desc = 'test file',
      function()
        require('utils.relative_files').alternative 'test'
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
      desc = 'telescope repo',
      lazy_req('telescope', 'extensions.repo.list'),
    },
    d = keys {
      desc = 'unimpaired directory',
      prev = b { '<Plug>(unimpaired-directory-previous)' },
      next = b { '<Plug>(unimpaired-directory-next)' },
    },
    e = keys {
      prev = b {
        desc = 'rename file',
        require('utils.buffers').rename,
      },
      next = b {
        desc = 'edit file',
        require('utils.buffers').edit,
      },
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
      desc = 'files (project)',
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
    i = keys {
      prev = b { desc = 'declaration', vim.lsp.buf.declaration },
      next = b {
        desc = 'implementations',
        lazy_req('telescope.builtin', 'lsp_implementations'),
      },
    },
    j = b {
      desc = 'type definition',
      lazy_req('telescope.builtin', 'lsp_type_definitions'),
    },
    -- FIXME:
    k = b {
      desc = 'node modules',
      lazy_req('telescope', 'extensions.my.node_modules'),
    },
    n = keys {
      desc = 'zk',
      a = b {
        desc = 'open asset',
        require('plugins.zk.utils').open_asset,
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
        require('plugins.zk.utils').remove_asset,
      },
      r = b {
        desc = 'index',
        lazy_req('zk', 'index'),
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
          require('plugins.zk.utils').new_journal_entry 'journal'
        end,
      },
      z = keys {
        prev = b {
          desc = 'new note from content',
          require('plugins.zk.utils').new_note_from_content,
          modes = 'x',
        },
        next = modes {
          x = b {
            desc = 'new note with title',
            require('plugins.zk.utils').new_note_with_title,
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
    -- v = b {
    --   desc = 'move file',
    --   lazy_req('telescope', 'extensions.my.move'),
    -- },
    m = b {
      desc = 'plugins',
      lazy_req('telescope', 'extensions.my.installed_plugins'),
    },
    o = b {
      desc = 'oldfiles',
      lazy_req('telescope.builtin', 'oldfiles', { only_cwd = true }),
    },
    l = b {
      desc = 'edit playground file',
      require('utils.buffers').edit_playground_file,
    },
    r = keys {
      prev = b {
        desc = 'trouble references',
        ':Trouble lsp_references<cr>',
      },
      next = b {
        desc = 'telescope references',
        function()
          require('telescope.builtin').lsp_references {}
        end,
      },
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
    u = b {
      desc = 'snapshot file',
      function()
        require('utils.relative_files').alternative 'snapshot'
      end,
    },
    v = b {
      desc = 'css file',
      function()
        require('utils.relative_files').alternative 'css'
      end,
    },
    w = b {
      desc = 'todo',
      lazy_req('telescope', 'extensions.todo-comments.todo'),
    },
    ['.'] = b {
      desc = 'config file',
      function()
        require('utils.relative_files').projection 'config'
      end,
    },
    ['é'] = keys {
      prev = b {
        desc = 'live grep',
        lazy_req('telescope.builtin', 'live_grep'),
      },
      next = b {
        desc = 'live grep local',
        function()
          require('telescope.builtin').live_grep {
            search_dirs = { vim.fn.expand('%:h', nil, nil) },
          }
        end,
      },
    },
  }
end

return M
