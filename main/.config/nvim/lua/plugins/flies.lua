local M = {}

function M.config()
  local ts = require('flies.objects.treesitter').new
  local buf = require('flies.objects.buffer').new()
  local queries = {
    a = ts 'parameter',
    -- b: brackets (targets)
    c = ts 'komment',
    -- d:
    e = buf,
    f = ts 'function',
    -- g:
    -- h: qualifier
    i = ts 'conditional',
    j = ts 'block',
    k = ts 'call',
    l = ts 'token',
    -- m:
    -- n: qualifier
    -- o: xmode ...
    -- p: qualifier
    -- q: quotes (targets)
    -- r:
    -- s:
    -- t: tag (targets)
    T = ts 'tag',
    Q = ts 'string',
    -- u: node; see also: David-Kunz/treesitter-unit
    v = require('flies.objects.regex').variable_segment,
    w = require('flies.objects.regex').vimword,
    x = ts 'class',
    y = ts 'loop',
    -- z:
    [' '] = require('flies.objects.regex').bigword,
    ['<tab>'] = require('flies.objects.indent').new(),
    ['<cr>'] = require('flies.objects.line').new(),
    ['é'] = require('flies.objects.search').new(),
  }
  for c in string.gmatch(',.;:+-=~_*#/|\\&$', '.') do
    queries[c] = require('flies.objects.regex').separator.new(c)
  end

  require('flies').setup {
    queries = queries,
    qualifiers = require('bindings.parameters').qualifiers,
    domains = require('bindings.parameters').domains,
  }
end

return M

-- TODO: what is treesitter-unit outer/inner
