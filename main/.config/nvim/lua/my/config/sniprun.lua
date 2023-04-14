local M = {}

function M.config()
  require('sniprun').setup {
    selected_interpreters = {
      'Python3_jupyter',
    },
    display = { 'LongTempFloatingWindow' },
  }
end

return M
