local M = {}

function M.setup()
  local actions = require 'telescope.actions'
  local deep_merge = require('utils').deep_merge
  local telescope = require 'telescope'
  telescope.setup(deep_merge(require('bindings').plugins.telescope(), {
    defaults = {
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
  }))

  telescope.load_extension 'md_help'
  telescope.load_extension 'installed_plugins'
  telescope.load_extension 'project_directory'
  telescope.load_extension 'my_projects'
end

return M
-- finders.new_oneshot_job
