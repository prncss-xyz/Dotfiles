local M = {}

function M.config()
  local telescope = require 'telescope'
  local mappings = require('bindings').plugins.telescope()
  telescope.setup {
    defaults = {
      mappings = mappings,
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

  telescope.load_extension 'md_help'
  telescope.load_extension 'gitignore'
  telescope.load_extension 'project_directory'
  telescope.load_extension 'my_projects'
  telescope.load_extension 'modules'
  telescope.load_extension 'installed_plugins'
  telescope.load_extension 'luasnip'
  telescope.load_extension 'frecency'
end

return M
