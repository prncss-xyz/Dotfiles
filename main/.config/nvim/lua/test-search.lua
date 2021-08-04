-- small experiments, not working
local m = {}

local augroup = require('utils').augroup
function _G.Wrap(seq, hl)
  vim.cmd 'silent! autocmd! trailer'
  vim.fn.execute(seq)
  if hl then
    require('hlslens').start()
  end
  augroup('trailer', {
    {
      events = { 'CursorMoved', 'CursorMovedI' },
      targets = { '*' },
      command = function()
        vim.o.hlsearch = false
        vim.cmd 'autocmd! trailer'
      end,
    },
  })
end

local function wrap(seq, hl)
  return string.format('<cmd>lua _G.Wrap(%s, %s)<cr>', seq, hl)
  -- return string.format(
  --   '<cmd>lua _G.WrapPre(%s)<cr>%s<cmd>lua _G.WrapPost(%s)<cr>',
  --   hl,
  --   seq,
  --   hl
  -- )
end

--
-- local function eats(ops)
--   for _, op in ipairs(ops) do
--     map('n', 'cs' .. op, string.format('yi%s"_ca%s', op, op))
--     map('n', 'ds' .. op, string.format('yi%s"_da%s', op, op))
--   end
-- end
-- eats { '"', "'", '`', '(', '{', '[', 'w', 'W', 's', 'p', 't', '>' }
-- map('n', 'csm', ':lua Csm()<cr>')
-- map('n', 'dsm', ':lua Dsm()<cr>')
-- map('n', 'cs%', 'yi%"_c;', { noremap = false })
-- map('n', 'ds%', 'yi%"_d;', { noremap = false })
-- not repeatable

function _G.Dsm()
  vim.cmd "lua require('tsht').nodes()"
  vim.cmd 'normal! y'
  vim.cmd "lua require('tsht').nodes()"
  vim.cmd 'normal! "_d'
end

function _G.Csm()
  vim.cmd "lua require('tsht').nodes()"
  vim.cmd 'normal! y'
  vim.cmd "lua require('tsht').nodes()"
  vim.cmd 'normal! "_c'
end
return m
