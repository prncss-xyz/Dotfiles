local M = {}

function M.config()
  local telescope = require 'telescope'
  local actions = require 'telescope.actions'
  telescope.setup {
    defaults = {
      mappings = {
        i = {
          ['<c-q>'] = actions.send_to_qflist,
          ['<c-t>'] = function(...)
            require('trouble.providers.telescope').open_with_trouble(...)
          end,
        },
        n = {
          ['<c-q>'] = actions.send_to_qflist,
          ['<c-t>'] = function(...)
            require('trouble.providers.telescope').open_with_trouble(...)
          end,
          ['<c-h>'] = actions.file_split,
          ['<c-v>'] = actions.file_vsplit,
        },
      },
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--hidden',
      },
      color_devicons = true,
      file_ignore_patterns = {
        '.git/*',
        'node_modules/*',
      },
    },
    extensions = {
      cheat = {
        mappings = {},
      },
      -- curently not in use
      frecency = {
        default_workspace = 'CWD',
        ignore_patterns = { '*.git/*', '*/tmp/*', 'node_modules/*' },
        show_unindexed = false,
        workspaces = {
          dot = vim.g.dotfiles,
          vim = vim.g.vim_dir,
          notes = vim.env.HOME .. 'Personal/neuron',
          data = vim.env.HOME .. '.local/share',
        },
      },
    },
  }
end

return M
