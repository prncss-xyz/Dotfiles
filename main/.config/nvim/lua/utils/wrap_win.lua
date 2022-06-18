local M = {}

local vim = vim
-- https://stackoverflow.com/questions/13848429/is-there-a-way-to-have-window-navigation-wrap-around-in-vim

local function move(direction, opposite)
  local win = vim.fn.eval 'winnr()'
  vim.cmd('wincmd ' .. direction)
  if win ~= vim.fn.eval 'winnr()' then
    return
  end
  vim.cmd('999wincmd ' .. opposite)
end

function M.left()
  move('h', 'l')
end

function M.right()
  move('l', 'h')
end

function M.up()
  move('k', 'j')
end

function M.down()
  move('j', 'k')
end

return M
