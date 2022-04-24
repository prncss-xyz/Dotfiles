local M = {}

function M.setup()
  vim.g.targets_nl = 'np'
  if false then
    return
  end
  vim.cmd [[
    autocmd User targets#mappings#user call targets#mappings#extend({
    \ ',': {},
    \ '.': {},
    \ ';': {},
    \ ':': {},
    \ '+': {},
    \ '-': {},
    \ '=': {},
    \ '~': {},
    \ '_': {},
    \ '*': {},
    \ '#': {},
    \ '/': {},
    \ '\': {},
    \ '|': {},
    \ '&': {},
    \ '$': {},
    \ 'a': {},
    \ 'b': {},
    \ 'q': {},
    \ '"': {},
    \ "'": {},
    \ '`': {},
    \ })
  ]]
end

return M
