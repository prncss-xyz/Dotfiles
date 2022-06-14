local M = {}

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

return M
