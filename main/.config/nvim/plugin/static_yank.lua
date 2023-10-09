local group = vim.api.nvim_create_augroup('MyStaticYank', {})

-- keep cursor in place while yanking
-- for operators: https://vimways.org/2019/making-things-flow/
local cursor

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  group = group,
  callback = function()
    cursor = vim.api.nvim_win_get_cursor(0)
  end,
})
vim.api.nvim_create_autocmd('CursorMoved', {
  pattern = '*',
  group = group,
  callback = function()
    cursor = vim.api.nvim_win_get_cursor(0)
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  group = group,
  callback = function()
    if vim.fn.eval('v:event').operator == 'y' then
      vim.api.nvim_win_set_cursor(0, cursor)
    end
  end,
})
