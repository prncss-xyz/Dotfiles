local actions = require 'telescope.actions'
require('telescope').setup {
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
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
      },
      ['n'] = {
        ['<c-j>'] = actions.file_split,
        ['<c-l>'] = actions.file_vsplit,
      },
    },
    file_ignore_patterns = {
      '.git/*',
      'node_modules/*',
    },
  },
}

require('telescope').load_extension 'fzy_native'
require('telescope').load_extension 'dap'

-- gitbranches; see https://github.com/awesome-streamers/awesome-streamerrc/blob/master/ThePrimeagen/lua/theprimeagen/telescope.lua

_G.Project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require('telescope.builtin').git_files, opts)
  if not ok then
    require('telescope.builtin').find_files(opts)
  end
end

-- finders.new_oneshot_job
