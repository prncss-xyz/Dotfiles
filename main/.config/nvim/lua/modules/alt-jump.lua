local M = {}

local pos = true

function M.reset()
  vim.fn.feedkeys('mXmY', 'n"')
end

function M.pop()
  M.toggle()
  M.reset()
end

function M.toggle()
  if pos then
    vim.fn.feedkeys('"mX`Y', 'n')
  else
    vim.fn.feedkeys('mY`X', 'n')
  end
  pos = not pos
end

return M
