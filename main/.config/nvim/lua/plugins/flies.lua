local M = {}

function M.config()
  local ts = require('flies.objects.treesitter').new
  local buf = require('flies.objects.buffer').new()
  local queries = {
    A = ts { 'parameter', blank_text_object = true },
    a = ts { 'swappable', blank_text_object = true },
    b = require('flies.objects.pair').new {
      { '(', ')' },
      { '[', ']' },
      { '{', '}' },
    },
    c = ts '@comment.outer',
    -- c = ts 'comment',
    -- d:
    e = buf,
    f = ts 'function',
    -- g:
    -- h: qualifier
    i = ts 'conditional',
    j = ts 'block',
    k = ts 'call',
    l = ts 'token',
    m = require('flies.objects.moeity').new(),
    -- m:
    -- n: qualifier
    -- o:
    -- p: qualifier
    -- q: quotes (targets)
    -- r:
    -- s:
    -- t: tag (targets)
    T = ts 'tag',
    -- Q = ts 'string',
    q = require('flies.objects.subline').string('"', "'", '`'),
    -- u: node; see also: David-Kunz/treesitter-unit
    v = require 'flies.objects.subline.variable_segment',
    w = require('flies.objects.subline').word(),
    x = ts 'class',
    y = ts 'loop',
    -- z:
    ['<space>'] = require('flies.objects.subline').bigword(),
    ['<tab>'] = require('flies.objects.indent').new(),
    ['<cr>'] = require 'flies.objects.subline.line',
    ['é'] = require('flies.objects.search').new(),
    ['"'] = require('flies.objects.subline').string '"',
    ["'"] = require('flies.objects.subline').string "'",
    ['`'] = require('flies.objects.subline').string '`',
  }
  -- targets: separator is multiline
  for c in string.gmatch(';:-=~*#&', '.') do
    queries[c] = require('flies.objects.pair').new {
      { c, c },
    }
  end
  for c in string.gmatch('._/|\\$', '.') do
    queries[c] = require('flies.objects.subline').separator(c)
  end

  require('flies').setup {
    queries = queries,
    qualifiers = require('plugins.binder.parameters').qualifiers,
    domains = require('plugins.binder.parameters').domains,
  }
end

return M
