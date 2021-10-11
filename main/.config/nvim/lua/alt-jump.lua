local m={}

local pos = true

function m.reset()
  vim.fn.feedkeys('mXmY', 'n')
end

function m.toggle()
  if pos then
    vim.fn.feedkeys('mX`Y', 'n')
  else
    vim.fn.feedkeys('mY`X', 'n')
  end
  pos = not pos
end

return m
