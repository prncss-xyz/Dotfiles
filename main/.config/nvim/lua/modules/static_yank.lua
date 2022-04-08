local M = {}

-- keep cursor in place while yanking
-- for operators: https://vimways.org/2019/making-things-flow/

local cursor

function M.setup()
  local augroup = require('utils').augroup
  augroup('CursorGet', {
    {
      events = { 'VimEnter', 'CursorMoved' },
      targets = { '*' },
      command = function()
        cursor = vim.fn.getpos '.'
      end,
    },
  })
  augroup('CursorSet', {
    {
      events = { 'TextYankPost' },
      targets = { '*' },
      command = function()
        if vim.fn.eval('v:event').operator == 'y' then
          vim.fn.setpos('.', cursor)
        end
      end,
    },
  })
end

return M
