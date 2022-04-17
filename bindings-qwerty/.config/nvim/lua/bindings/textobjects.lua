local M = {}

-- TODO: flies-exchange

function M.setup()
  local map = require('utils').map
  map('nox', 'gi', '<nop>', {})
  map('nox', 'ga', '<nop>', {})
  if false then
    map(
      'ox',
      'a' .. require('bindings.parameters').d.git,
      ':<c-u>Gitsigns select_hunk<cr>'
    )
  end
  local unit = 'u'
  -- outer unit includes blank lines above
  map('o', 'a' .. unit, ":<c-u>lua require('treesitter-unit').select(true)<cr>")
  map('x', 'a' .. unit, ":lua require('treesitter-unit').select(true)<cr>")
  if false then
    map(
      'o',
      'i' .. unit,
      ":<c-u>lua require('treesitter-unit').select(false)<cr>"
    )
    map('x', 'i' .. unit, ":lua require('treesitter-unit').select(false)<cr>")
  else
    map(
      'o',
      'i' .. unit,
      ":<c-u>lua require('nvim-treesitter.textobjects.select').select_textobject( '@node', 'o')<cr>"
    )
    map(
      'x',
      'i' .. unit,
      ":lua require('nvim-treesitter.textobjects.select').select_textobject( '@node', 'x')<cr>"
    )
  end
  map('o', 'ih' .. unit, ":<c-u>lua require('tsht').nodes()<cr>")
  map('x', 'ih' .. unit, ":lua require('tsht').nodes()<cr>")
  map('o', 'ah' .. unit, ":<c-u>lua require('tsht').nodes()<cr>")
  map('x', 'ah' .. unit, ":lua require('tsht').nodes()<cr>")
end

return M
