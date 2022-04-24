local M = {}

-- keep cursor in place while yanking
-- for operators: https://vimways.org/2019/making-things-flow/
local cursor

function M.setup()
  vim.api.nvim_create_autocmd('VimEnter', {
    pattern = 'VimEnter',
    callback = function()
      cursor = vim.fn.getpos '.'
    end,
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    pattern = 'VimEnter',
    callback = function()
      cursor = vim.fn.getpos '.'
    end,
  })

  vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = 'VimEnter',
    callback = function()
      if vim.fn.eval('v:event').operator == 'y' then
        vim.fn.setpos('.', cursor)
      end
    end,
  })
end

return M
