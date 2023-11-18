local M = {}

local invert = require('my.utils.std').invert

M.qualifiers = {
  p = 'previous',
  n = 'next',
  h = 'hint',
}

-- TODO: default configuration
M.domains = {
  i = 'inner',
  a = 'outer',
}

M.d = invert {
  j = 'down',
  k = 'up',
  l = 'left',
  ['é'] = 'search',
  [';'] = 'right',
  ['<c-j>'] = 'next_search',
  ['<c-x>'] = 'prev_search',
}

M.selection_chars = 'asdfjkl;ghqweruiopzxcvm,étybn'

return M
