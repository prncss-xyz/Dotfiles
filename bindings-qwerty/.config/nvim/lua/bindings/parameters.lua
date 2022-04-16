local M = {}

local invert = require('utils').invert

M.a = invert {
  g = 'jump',
  H = 'help',
  h = 'edit',
  z = 'move',
  m = 'mark',
  Q = 'macro',
  q = 'editor',
  o = 'various',
  [' '] = 'leader',
}

M.d = invert {
  a = 'diagnostic',
  b = 'join',
  c = 'comment',
  u = 'git',
  j = 'up',
  k = 'down',
  L = 'loclist',
  l = 'left',
  s = 'symbol',
  z = 'spell',
  [';'] = 'right',
  ['é'] = 'search',
  ['<c-j>'] = 'next_search',
  ['<c-x>'] = 'prev_search',
}

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

local previous = invert(M.qualifiers).previous

M.p = function(c)
  return previous .. (c or ' ')
end

return M
