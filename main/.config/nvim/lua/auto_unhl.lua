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

function _G.unhl_n()
  local res = vim.o.hlsearch and 'n' or ''
  res = res .. "\\<cmd>require'auto_unhl'.post()\\<cr>"
  return res
end

return m
