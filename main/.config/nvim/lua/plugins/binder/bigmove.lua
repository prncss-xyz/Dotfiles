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
    a = b { desc = 'edit alt', require('utils.buffers').edit_alt },
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
      desc = 'refresh buffer list',
      lazy_req('buffstory', 'refresh_list'),
    },
    d = keys {
      desc = 'unimpaired directory',
      prev = b { '<Plug>(unimpaired-directory-previous)' },
      next = b { '<Plug>(unimpaired-directory-next)' },
    },
    e = b {
      desc = 'edit file',
      function()
        util.keys(':edit ' .. vim.fn.expand('%:h:p', nil, nil) .. '/')
      end,
    },
    f = keys {
      next = b {
        desc = 'project files',
        require('utils.buffers').project_files,
      },
      prev = b {
        desc = 'files (project)',
        function()
          require('telescope.builtin').find_files {
            cwd = vim.fn.expand('%:p:h', nil, nil),
            find_command = { 'fd', '-H', '--type', 'f' },
          }
        end,
      },
    },
    g = b { desc = 'buffers', lazy_req('telescope.builtin', 'buffers') },
    h = b {
      desc = 'recent buffer',
      lazy_req('buffstory', 'select'),
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
      redup = b {
        desc = 'notes',
        -- lazy_req('telescope', 'extensions.zk.notes'),
        lazy_req('telescope', 'extensions.my.zk_notes'),
      },
      c = b {
        desc = 'cd',
        lazy_req('zk', 'cd'),
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
          local api = require 'zk.api'
          local path = string.format('journal/%s.md', os.date '%x')
          api.list(
            nil,
            { select = { 'filename', 'filenameStem', 'path', 'absPath' } },
            function(_, entries)
              for _, entry in ipairs(entries) do
                if path == entry.path then
                  vim.api.nvim_command('e ' .. entry.absPath)
                  break
                end
              end
              vim.defer_fn(function()
                require('zk').new { dir = 'journal' }
              end, 100)
            end
          )
        end,
      },
      z = keys {
        prev = b {
          desc = 'new note from content',
          function()
            local zk_util = require 'zk.util'
            local location = zk_util.get_lsp_location_from_selection()
            local selected_text = zk_util.get_text_in_range(location.range)
            require('plugins.binder.utils').keys '<esc>'
            vim.ui.input({ prompt = 'note title' }, function(title)
              if title ~= '' then
                vim.defer_fn(function()
                  require('zk').new {
                    dir = 'notes',
                    title = title,
                    content = selected_text,
                    insertLinkAtLocation = location,
                  }
                end, 100)
              end
            end)
          end,
          modes = 'x',
        },
        next = modes {
          x = b {
            desc = 'new note',
            function()
              local zk_util = require 'zk.util'
              local location = zk_util.get_lsp_location_from_selection()
              local selected_text = zk_util.get_text_in_range(location.range)
              require('zk').new {
                dir = 'notes',
                title = selected_text,
                insertLinkAtLocation = location,
              }
            end,
          },
          n = b {
            desc = 'new note',
            function()
              vim.ui.input({ prompt = 'note title' }, function(title)
                if title ~= '' then
                  vim.defer_fn(function()
                    require('zk').new { dir = 'notes', title = title }
                  end, 100)
                end
              end)
            end,
          },
        },
      },
      k = b {
        desc = 'new task',
        function()
          vim.ui.input({ prompt = 'task title' }, function(title)
            vim.defer_fn(function()
              require('zk').new { dir = 'tasks', title = title }
            end, 100)
          end)
        end,
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
    w = b {
      desc = 'todo',
      lazy_req('telescope', 'extensions.todo-comments.todo'),
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
