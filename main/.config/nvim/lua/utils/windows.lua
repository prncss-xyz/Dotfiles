local M = {}

function M.show_ui(keep, cb)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bt = vim.api.nvim_buf_get_option(buf, 'buftype')
    if bt ~= '' then
      vim.api.nvim_win_close(win, false)
    end
  end
  if cb then
    cb()
  end
end

function M.split_right(size)
  local Split = require 'nui.split'
  local file = vim.fn.expand('%', nil, nil)
  Split({
    relative = 'editor',
    position = 'left',
    size = size,
  }):mount()
  vim.cmd('e ' .. file)
end

function M.winpick_focus()
  local win = require('window-picker').pick_window {}
  if win then
    vim.api.nvim_set_current_win(win)
  end
end

function M.winpick_close()
  local win = require('window-picker').pick_window {}
  if win then
    vim.api.nvim_win_close(win, true)
  end
end

local function regular_buffer_filter(windows_id, _)
  return vim.tbl_filter(function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    local bt = vim.api.nvim_buf_get_option(buf, 'buftype')
    if bt == '' then
      return true
    end
  end, windows_id)
end

function M.winpick_clone_to()
  local win1 = require('window-picker').pick_window {
    filter_func = regular_buffer_filter,
  }
  if win1 then
    local win2 = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win2)
    vim.api.nvim_win_set_buf(win1, buf)
  end
end

function M.winpick_clone_from()
  local win1 = require('window-picker').pick_window {
    filter = regular_buffer_filter,
  }
  if win1 then
    local win2 = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win1)
    vim.api.nvim_win_set_buf(win2, buf)
  end
end

function M.winpick_swap()
  local win1 = require('window-picker').pick_window {
    filter = regular_buffer_filter,
  }
  if win1 then
    local win2 = vim.api.nvim_get_current_win()
    local buf1 = vim.api.nvim_win_get_buf(win1)
    local buf2 = vim.api.nvim_win_get_buf(win2)
    vim.api.nvim_win_set_buf(win1, buf2)
    vim.api.nvim_win_set_buf(win2, buf1)
  end
end

--- Zoom in and out of a buffer, making it full screen in a floating window
---
--- This function is useful when working with multiple windows but temporarily
--- needing to zoom into one to see more of the code from that buffer. Call it
--- again (without arguments) to zoom out.
---
---@param buf_id number Buffer identifier (see |bufnr()|) to be zoomed.
---   Default: 0 for current.
---@param config table Optional config for window (as for |nvim_open_win()|).

-- Window identifier of current zoom (for `zoom()`)
local zoom_winid = nil

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
