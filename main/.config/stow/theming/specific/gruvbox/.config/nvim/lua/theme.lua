local M = {}

-- M.galaxyline = {
--   text = '#$background',
-- }

M.setup = function()
  vim.o.background = 'light' -- Color name (:help cterm-colors) or ANSI code
  vim.cmd 'colorscheme gruvbox-material'
  require('utils').deep_merge(vim.g, {
  })
end

return M
