
local actions = require('telescope.actions')
require "telescope".setup {
  defaults = {
    color_devicons = true,
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true
      }
    },
    mappings = {
      i = {
        ["<C-q>"] = actions.send_to_qflist,
      },
    },
    file_ignore_patterns = {
      ".git/*",
      "node_modules/*"
    }
  }
}

require('telescope').load_extension('fzy_native')

-- gitbranches; see https://github.com/awesome-streamers/awesome-streamerrc/blob/master/ThePrimeagen/lua/theprimeagen/telescope.lua 
