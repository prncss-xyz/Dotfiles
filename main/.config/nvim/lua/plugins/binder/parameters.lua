local M = {}

local invert = require('utils').invert

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
  j = 'up',
  k = 'down',
  l = 'left',
  ['é'] = 'search',
  [';'] = 'right',
  ['<c-j>'] = 'next_search',
  ['<c-x>'] = 'prev_search',
}

return M
