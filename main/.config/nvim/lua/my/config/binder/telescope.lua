local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  return keys {
    a = b {
      desc = 'oldfiles',
      'req',
      'telescope.builtin',
      'oldfiles',
      { only_cwd = true },
    },
    b = b {
      desc = 'buffers',
      'req',
      'telescope.builtin',
      'buffers',
    },
    c = b {
      desc = 'repo',
      'req',
      'telescope',
      'extensions.repo.list',
    },
    d = b {
      desc = 'diagnostics',
      'req',
      'telescope.builtin',
      'diagnostics',
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
    E = b {
      desc = 'files (workspace)',
      'req',
      'telescope.builtin',
      'find_files',
      {
        prompt_title = 'files (workspace)',
        find_command = {
          'fd',
          '--hidden',
          '--type',
          'f',
          '--strip-cwd-prefix',
        },
      },
    },
    f = b {
      desc = 'files (local)',
      'req',
      'telescope.builtin',
      'find_files',
      {
        prompt_title = 'files (local)',
        cwd = vim.fn.expand '%:p:h',
        find_command = {
          'fd',
          '--hidden',
          '--type',
          'f',
          '--strip-cwd-prefix',
        },
      },
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
      'req',
      'telescope',
      'extensions.repo.list',
      {
        prompt_title = 'nvim plugins',
        cwd = '/prncss/home/.local/share/nvim/',
        search_dirs = { '~/.local/share/nvim/site/pack' },
      },
    },
    n = b {
      desc = 'notes',
      'req',
      'telescope',
      'extensions.my.zk_notes',
    },
    r = b {
      desc = 'references',
      'req',
      'telescope.builtin',
      'lsp_references',
    },
    s = b {
      desc = 'workspace symbols',
      'req',
      'telescope.builtin',
      'lsp_workspace_symbols',
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
      desc = 'spell',
      'req',
      'telescope.builtin',
      'spell_suggest',
    },
    ['é'] = keys {
      prev = b {
        desc = 'live grep (workspace)',
        'req',
        'telescope.builtin',
        'live_grep',
        {
          prompt_title = 'live grep (workspace)',
        },
      },
      next = b {
        desc = 'live grep (local)',
        function()
          require('telescope.builtin').live_grep {
            prompt_title = 'live grep (local)',
            search_dirs = { vim.fn.expand '%:h' },
          }
        end,
      },
    },
  }
end

return M
