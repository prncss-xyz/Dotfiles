local M = {}

function M.config()
  local pairs = {
    { '(', ')' },
    { '[', ']' },
    { '{', '}' },
    { '<', '>' },
  }

  local ts = require 'flies.objects.treesitter'
  local queries = {
    A = ts:new { 'parameter', blank_text_object = true },
    a = ts:new { 'swappable', blank_text_object = true },
    b = require('flies.objects.pair'):new(pairs),
    c = ts:new '@comment.outer',
    d = require('flies.objects.subline').number,
    e = require 'flies.objects.buffer',
    f = require 'flies.objects.moeity',
    g = require('flies.objects.moeity').reversed:new(),
    -- h: qualifier
    i = ts:new 'conditional',
    j = ts:new 'block',
    k = ts:new 'call',
    l = ts:new 'loop',
    -- n: qualifier
    -- -- o:
    o = ts:new 'token',
    -- p: qualifier
    Q = ts:new 'string',
    q = require('flies.objects.subline').string:new { "'", '"', '`' },
    -- -- r:
    s = ts:new 'function',
    t = ts:new 'tag',
    u = require 'flies.objects.treesitter-unit',
    v = require 'flies.objects.subline.variable_segment',
    w = require('flies.objects.subline').vimword,
    x = ts:new 'class',
    -- -- y:
    -- -- z:
    ['<space>'] = require('flies.objects.subline').bigword,
    -- ['<tab>'] = require('flies.objects.indent').new(),
    ['<cr>'] = require 'flies.objects.subline.line',
    ['é'] = require 'flies.objects.search',
    ['"'] = require('flies.objects.subline').string:new { '"' },
    ["'"] = require('flies.objects.subline').string:new { "'" },
    ['`'] = require('flies.objects.subline').string:new { '`' },
  }
  -- targets: separator is multiline
  for c in string.gmatch(';:-=~*#&', '.') do
    queries[c] = require('flies.objects.pair'):new { { c, c } }
  end
  for _, pair in ipairs(pairs) do
    local l, r = unpack(pair)
    queries[l] = require('flies.objects.pair'):new { pair }
    queries[r] = require('flies.objects.pair'):new { pair, reversed = true }
  end
  for c in string.gmatch('._/|\\$', '.') do
    queries[c] = require('flies.objects.subline').separator:new(c)
  end
  require('flies').setup {
    queries = queries,
    qualifiers = require('plugins.binder.parameters').qualifiers,
    domains = require('plugins.binder.parameters').domains,
  }
end

return M
