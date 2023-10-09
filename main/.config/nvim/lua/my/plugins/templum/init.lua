return {
  dir = require('my.utils').local_repo 'templum.nvim',
  opts = {
    cb = function()
      return require 'my.plugins.templum.snippets'
    end,
  },
  event = 'VimEnter',
  -- dependencies = 'L3MON4D3/LuaSnip',
}
