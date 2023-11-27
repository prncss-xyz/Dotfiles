local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local cmd = require('binder.helpers').cmd
  return keys {
    a = b {
      desc = 'current buffer fuzzy find',
      'req',
      'telescope.builtin',
      'current_buffer_fuzzy_find',
      { bufnr = 0 },
    },
    b = b {
      desc = 'buffers',
      'req',
      'telescope.builtin',
      'buffers',
    },
    c = keys {
      prev = b {
        desc = 'repo',
        'req',
        'telescope',
        'extensions.repo.list',
      },
      next = b {
        desc = 'tabs',
        'req',
        'telescope-tabs',
        'list_tabs',
      },
    },
    e = b {
      desc = 'files (smart-open)',
      'req',
      'telescope',
      'extensions.smart_open.smart_open',
      {
        cwd_only = true,
        filename_first = false,
      },
    },
    f = b {
      desc = 'files (local)',
      function()
        require('telescope.builtin').find_files {
          prompt_title = 'files (local)',
          -- cannot serialize this:
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
      'req',
      'telescope.builtin',
      'git_status',
    },
    i = b {
      desc = 'noice (messages)',
      cmd 'Noice telescope',
    },
    k = b {
      desc = 'terminal',
      '<cmd>TermSelect<cr>',
    },
    -- k = b {
    --   desc = 'node modules',
    --   lazy_req('telescope', 'extensions.my.modules'),
    -- },
    m = b {
      desc = 'plugins',
      function()
        require('telescope').extensions.repo.list {
          prompt_title = 'nvim plugins',
          search_dirs = { vim.env.HOME .. '/.local/share/nvim/lazy' },
        }
      end,
    },
    n = b {
      desc = 'notes',
      'req',
      'telescope',
      'extensions.my.zk_notes',
    },
    o = b {
      desc = 'oldfiles',
      'req',
      'telescope.builtin',
      'oldfiles',
    },
    r = b {
      desc = 'references',
      'req',
      'telescope.builtin',
      'lsp_references',
    },
    s = keys {
      prev = b {
        desc = 'workspace symbols',
        'req',
        'telescope.builtin',
        'lsp_workspace_symbols',
      },
      next = b {
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
    },
    v = b {
      desc = 'yank history',
      'req',
      'telescope',
      'extensions.yank_history.yank_history',
    },
    w = b {
      desc = 'todo',
      'req',
      'telescope',
      'extensions.todo-comments.todo',
    },
    z = b {
      desc = 'diagnostics',
      'req',
      'telescope.builtin',
      'diagnostics',
    },
    Z = b {
      desc = 'spell',
      'req',
      'telescope.builtin',
      'spell_suggest',
    },
    ['.'] = b {
      desc = 'dotfiles',
      function()
        require('telescope.builtin').find_files {
          prompt_title = 'files (local)',
          -- cannot serialize this:
          cwd = '~/Dotfiles',
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
    ['é'] = keys {
      prev = b {
        desc = 'live grep (workspace)',
        function()
          local conf = require('telescope.config').values
          require('telescope.builtin').live_grep {
            prompt_title = 'live grep (workspace)',
            vimgrep_arguments = table.insert(
              conf.vimgrep_arguments,
              '--fixed-strings'
            ),
          }
        end,
      },
      next = b {
        desc = 'live grep (local)',
        function()
          local conf = require('telescope.config').values
          require('telescope.builtin').live_grep {
            prompt_title = 'live grep (local)',
            search_dirs = { vim.fn.expand '%:h' },
            vimgrep_arguments = table.insert(
              conf.vimgrep_arguments,
              '--fixed-strings'
            ),
          }
        end,
      },
    },
  }
end

return M
