local M = {}

local plugin_by_ft = {
  -- lua = 'conjure',
}

local function get_current()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, 'buftype')
  return ft, plugin_by_ft[ft]
end

function M.rise()
  local ft, plugin = get_current()
  if plugin == 'conjure' then
  else
    require('iron.core').focus_on(ft)
  end
end

function M.send()
  local ft, plugin = get_current()
  if plugin == 'conjure' then
  else
    require('iron.core').send_line(ft, { 'x=3+1', 'x+5' })
  end
end

function M.restart()
  local _, plugin = get_current()
  if plugin == 'conjure' then
  else
    require('iron.core').restart()
  end
end

return M
