local M = {}

function M.config()
  print 'caca'
  require 'caca'
  require('sniprun').setup {
    selected_interpreters = {
      'Python3_jupyter',
    },
    display = { 'LongTempFloatingWindow' },
  }
end

return M
