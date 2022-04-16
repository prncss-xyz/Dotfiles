local M = {}

function M.config()
  local ts = require('flies.objects.treesitter').new
  local buf = require('flies.objects.buffer').new()

  require('flies').setup {
    queries = {
      -- a: argument (targets)
      a = ts 'parameter',
      -- b: brackets (targets)
      c = ts 'komment',
      -- d: datetime
      e = buf,
      f = ts 'function',
      -- u: node; see also: David-Kunz/treesitter-unit
      -- h: qualifier
      i = ts 'conditional',
      j = ts 'block',
      k = ts 'call',
      l = ts 'token',
      -- m:
      -- n: qualifier
      -- o: xmode
      -- r = vo.paragraph,
      -- p: qualifier
      -- t: tag (targets)
      T = ts 'tag',
      Q = ts 'string',
      -- q: quotes (targets)
      -- u: hunk (gitsigns)
      -- v: variable segment
      -- w: word
      y = ts 'loop',
      x = ts 'class',
      ['<tab>'] = require('flies.objects.indent').new(),
      ['<cr>'] = require('flies.objects.line').new(),
      ['é'] = require('flies.objects.search').new(),
    },
--   qualifiers = require('bindings.parameters').qualifiers,
--   domains = require('bindings.parameters').domains,
  }
end

return M
