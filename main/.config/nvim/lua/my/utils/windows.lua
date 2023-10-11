local M = {}

function M.info()
  print 'info'
end

function M.close()
  vim.api.nvim_win_close(0, true)
end

function M.split_float()
  local Popup = require 'nui.popup'
  local bufnr = vim.api.nvim_win_get_buf(0)
  Popup({
    bufnr = bufnr,
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
    },
    position = '50%',
    size = {
      width = '80%',
      height = '80%',
    },
  }):mount()
end

function M.split_right(size)
  local Split = require 'nui.split'
  local bufnr = vim.api.nvim_win_get_buf(0)
  Split({
    relative = 'editor',
    position = 'right',
    size = size,
  }):mount()
  vim.api.nvim_win_set_buf(0, bufnr)
end

function M.split_external()
  local bufnr = vim.api.nvim_win_get_buf(0)
  vim.api.nvim_open_win(
    bufnr,
    true,
    { external = true, width = 50, height = 20 }
  )
end

local function pick(cb)
  local win = require('window-picker').pick_window {}
  if win and vim.api.nvim_win_is_valid(win) then
    return cb(win)
  end
end

function M.winpick()
  pick(vim.api.nvim_set_current_win)
end

-- Window identifier of current zoom (for `zoom()`)
local zoom_winid = nil

--- Zoom in and out of a buffer, making it full screen in a floating window
---
--- This function is useful when working with multiple windows but temporarily
--- needing to zoom into one to see more of the code from that buffer. Call it
--- again (without arguments) to zoom out.
---
---@param buf_id number Buffer identifier (see |bufnr()|) to be zoomed.
---   Default: 0 for current.
---@param config table Optional config for window (as for |nvim_open_win()|).
function M.zoom(buf_id, config)
  if zoom_winid and vim.api.nvim_win_is_valid(zoom_winid) then
    vim.api.nvim_win_close(zoom_winid, true)
    zoom_winid = nil
  else
    buf_id = buf_id or 0
    -- Currently very big `width` and `height` get truncated to maximum allowed
    local default_config = {
      relative = 'editor',
      row = 0,
      col = 0,
      width = 1000,
      height = 1000,
    }
    config = vim.tbl_deep_extend('force', default_config, config or {})
    zoom_winid = vim.api.nvim_open_win(buf_id, true, config)
    vim.cmd 'normal! zz'
  end
end

return M
