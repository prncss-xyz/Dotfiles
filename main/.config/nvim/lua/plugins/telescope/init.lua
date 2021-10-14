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
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
      file_ignore_patterns = {
        '.git/*',
        'node_modules/*',
      },
    },
    extensions = {
      bookmarks = {
        selected_browser = 'chromium',
        url_open_command = 'browser',
      },
    },
  }))

  require('telescope').load_extension 'repo'
  require('telescope').load_extension 'fzf'
  -- telescope.load_extension 'dap'
  telescope.load_extension 'heading'
  -- telescope.load_extension 'node_modules'
  -- telescope.builtin 'spell_suggest'
  if require'pager'.full then
    require('telescope').load_extension 'project'
    require('telescope').load_extension 'projects'
    require('telescope').load_extension 'node_modules'
  end
  -- gitbranches; see https://github.com/awesome-streamers/awesome-streamerrc/blob/master/ThePrimeagen/lua/theprimeagen/telescope.lua
end

M.project_files = function()
  local opts = {} -- define here if you want to define something
  if vim.fn.getcwd() == os.getenv 'HOME' .. '/Personal/neuron' then
    require('nononotes').prompt('edit', false, 'all')
    return
  end
  local ok = pcall(require('telescope.builtin').git_files, opts)
  if not ok then
    require('telescope.builtin').find_files(opts)
  end
end

-- M.md = require 'plugins.telescope.md'

return M
-- finders.new_oneshot_job
