local M = {}
M.setup = function()
  vim.o.background = 'dark' -- Color name (:help cterm-colors) or ANSI code
  vim.cmd 'colorscheme solarized-low'
end

return M
