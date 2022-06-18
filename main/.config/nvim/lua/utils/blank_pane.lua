local M = {}

local split
function M.open()
  local Split = require 'nui.split'
  local win = vim.api.nvim_get_current_win()
  if not split then
    split = Split {
      relative = 'editor',
      position = 'left',
      size = vim.g.u_pane_width,
    }
    split:mount()
  else
    split:show()
  end
  vim.api.nvim_set_current_win(win)
end

function M.close()
  split:hide()
end

return M
