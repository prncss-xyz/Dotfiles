local M = {}

M.galaxyline = {
  text = '#$background',
}

M.setup = function()
  vim.o.background = 'dark' -- Color name (:help cterm-colors) or ANSI code
  vim.cmd 'colorscheme neon'
  require('modules.utils').deep_merge(vim.g, {
    neon_italic_keyword = true,
    neon_italic_boolean = true,
  })
end

return M
