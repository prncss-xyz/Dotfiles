local M = {}

-- TODO: flies-exchange

function M.setup()
  local map = require('utils').map
  map('nox', 'gi', '<nop>', {})
  map('nox', 'ga', '<nop>', {})
  map(
    'ox',
    'a' .. require('bindings.parameters').d.git,
    ':<c-u>Gitsigns select_hunk<cr>'
  )
  map('o', 'ai', ":<c-u>lua require('treesitter-unit').select(true)<cr>")
  map('x', 'ai', ":lua require('treesitter-unit').select(true)<cr>")
  if true then
    map('o', 'ii', ":<c-u>lua require('treesitter-unit').select()<cr>")
    map('x', 'ii', ":lua require('treesitter-unit').select()<cr>")
    map(
      'o',
      'ii',
      ":<c-u>lua require('nvim-treesitter.textobjects.select').select_textobject( '@node', 'o')<cr>"
    )
    map(
      'x',
      'ii',
      ":lua require('nvim-treesitter.textobjects.select').select_textobject( '@node', 'x')<cr>"
    )
  else
    map('o', 'ihi', ":<c-u>lua require('tsht').nodes()<cr>")
    map('x', 'ihi', ":lua require('tsht').nodes()<cr>")
  end

  local ts = require('flies.objects.treesitter').new
  local buf = require('flies.objects.buffer').new()
  local vo = require 'flies.objects.vim'

  require('flies').setup {
    queries = {
      -- a: argument (targets)
      a = ts 'parameter',
      -- b: brackets (targets)
      c = ts 'komment',
      -- d: datetime
      e = buf,
      f = ts 'function',
      -- h: qualifier
      -- i: node; see also: David-Kunz/treesitter-unit
      j = ts 'block',
      k = ts 'call',
      l = ts 'token',
      -- m:
      -- n: qualifier
      -- o: xmode
      -- r = vo.paragraph,
      -- p: qualifier
      s = vo.sentence,
      -- t: tag (targets)
      T = ts 'tag',
      Q = ts 'string',
      -- q: quotes (targets)
      -- u: hunk (gitsigns)
      -- v: variable segment
      -- w: word
      x = ts 'class',
      y = ts 'conditional',
      z = ts 'loop',
      ['<space>'] = vo.bigword,
      ['<tab>'] = require('flies.objects.indent').new(),
      ['<cr>'] = require('flies.objects.line').new(),
      ['é'] = require('flies.objects.search').asterisk_z,
    },
    qualifiers = require('bindings.parameters').qualifiers,
    domains = require('bindings.parameters').domains,
  }
end

return M
