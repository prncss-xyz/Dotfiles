local M = {}

M.galaxyline = {
  text = '#$background',
}

M.setup = function()
  vim.cmd 'colorscheme neon'
  require('utils').deep_merge(vim.g, {
    rose_pine_variant = 'dawn',
    rose_pine_enable_italics = true,
    rose_pine_disable_background = false,
  })
  vim.cmd 'colorscheme rose-pine'
end

return M
