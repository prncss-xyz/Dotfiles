local M = {}
local actions = require 'telescope.actions'
local deep_merge = require('utils').deep_merge

function M.setup()
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
      file_sorter = require('telescope.sorters').get_fzy_sorter,
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
      extensions = {
        fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
        },
      },
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

  telescope.load_extension 'fzy_native'
  -- telescope.load_extension 'dap'
  telescope.load_extension 'heading'
  -- telescope.load_extension 'node_modules'
  -- telescope.builtin 'man_pages'
  -- telescope.builtin 'spell_suggest'
  require('telescope').load_extension 'bookmarks'
  -- gitbranches; see https://github.com/awesome-streamers/awesome-streamerrc/blob/master/ThePrimeagen/lua/theprimeagen/telescope.lua
end

M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require('telescope.builtin').git_files, opts)
  if not ok then
    require('telescope.builtin').find_files(opts)
  end
end

M.md = require 'setup/telescope/md'

-- https://vim.fandom.com/wiki/To_switch_back_to_normal_mode_automatically_after_inaction
vim.cmd [[
" set 'updatetime' to 15 seconds when in insert mode
au InsertEnter * let updaterestore=&updatetime | set updatetime=5000
au InsertLeave * let &updatetime=updaterestore
]]

return M
-- finders.new_oneshot_job
