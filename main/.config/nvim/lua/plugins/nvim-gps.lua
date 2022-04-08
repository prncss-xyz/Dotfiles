local M = {}

function M.config()
  local symbols = require('symbols').symbols
  require('nvim-gps').setup {
    enabled = true,
    icons = {
      ['class-name'] = symbols.Class .. ' ',
      ['function-name'] = symbols.Function .. ' ',
      ['method-name'] = symbols.Method .. ' ',
      ['container-name'] = symbols.Array .. ' ',
      ['tag-name'] = symbols.Property .. ' ',
    },
    separator = ' > ',
  }
end

return M
