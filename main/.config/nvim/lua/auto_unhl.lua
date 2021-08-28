-- triggers undo commands unexpectedly
local m = {}

function m.auto()
  vim.cmd 'autocmd! trailer'
  require('hlslens.main').cmdl_search_leave()
  vim.o.hlsearch = false
end

vim.cmd [[
  augroup trailer
  augroup END
]]

function m.post()
  vim.o.hlsearch = true
  require('hlslens').start()
  vim.cmd [[
    augroup trailer
      autocmd!
      autocmd CursorMoved,CursorMovedI * lua require'auto_unhl'.auto()
    augroup END]]
end

-- local map = require('utils').map
-- map( '', 'n', "n<cmd>lua require'auto_unhl'.post()<cr>")
-- map( '', 'N', "N<cmd>lua require'auto_unhl'.post()<cr>")
-- map('n', '*', "*N<cmd>lua require'auto_unhl'.post()<cr>")
-- map('n', 'g*', "g*N<cmd>lua require'auto_unhl'.post()<cr>")
-- map(
--   'x',
--   '*',
--   "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>N<cr><cmd>lua require'auto_unhl'.post()<cr>"
-- )

return m
