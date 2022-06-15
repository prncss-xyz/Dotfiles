local M = {}

-- https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/util.lua
function M.extract_nvim_hl(name)
  local hl_str = vim.api.nvim_exec('highlight ' .. name, true)
  local hl = {
    fg = hl_str:match('guifg=([^%s]+)') or '',
    bg = hl_str:match('guibg=([^%s]+)') or '',
    style = hl_str:match('gui=([^%s]+)') or '',
    name = name,
  }
  return hl
end

return M
