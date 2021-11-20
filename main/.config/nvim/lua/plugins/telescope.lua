local M = {}

function M.setup()
  local telescope = require 'telescope'
  local mappings = require('bindings').plugins.telescope()
  telescope.setup{
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
      -- file_sorter = require('telescope.sorters').get_fzy_sorter,
      file_ignore_patterns = {
        '.git/*',
        'node_modules/*',
      },
    },
  }

  -- local telescope extensions
  telescope.load_extension 'md_help'
  telescope.load_extension 'gitignore'
  telescope.load_extension 'project_directory'
  telescope.load_extension 'my_projects'
  telescope.load_extension 'modules'
  telescope.load_extension 'refactoring'
  telescope.load_extension 'installed_plugins'
end

return M
-- finders.new_oneshot_job
