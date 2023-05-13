local M = {}

local last_ui

function M.info()
  local context = require('hop.window').get_window_context()
  context = context[1].contexts[1]
  dump(context)
end

function M.show_ui(keep, cb)
  if type(keep) == 'string' then
    keep = { keep }
  elseif keep == nil then
    keep = {}
  end
  last_ui = {
    keep,
    cb,
  }
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    pcall(function()
      local buf = vim.api.nvim_win_get_buf(win)
      local bt = vim.api.nvim_buf_get_option(buf, 'buftype')
      local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
      if bt ~= '' then
        local del = true
        for _, k in ipairs(keep) do
          if vim.endswith(ft, k) then
            del = false
            break
          end
        end
        if del then
          if ft == 'neo-tree' then
            vim.cmd 'NeoTreeClose'
          elseif ft == 'aerial' then
            vim.cmd 'AerialCLose'
          elseif vim.startswith(ft, 'dap-') or vim.startswith(ft, 'dapui_') then
            require('dapui').close()
            vim.cmd 'DapVirtualTextDisable'
            require('nvim-dap-virtual-text').disable()
            require('gitsigns').toggle_current_line_blame(true)
          elseif ft == 'undotree' or ft == 'diff' then
            vim.cmd 'UndotreeToggle'
          else
            -- vim.notify('unknown command for buftype ' .. bt)
            -- vim.notify('unknown command for filetype ' .. ft)
            -- vim.api.nvim_win_close(win, false)
          end
        end
      end
    end)
  end
  vim.defer_fn(function()
    if type(cb) == 'function' then
      cb()
    elseif type(cb) == 'string' then
      vim.api.nvim_command(cb)
    end
  end, 0)
end

function M.show_ui_last()
  if last_ui then
    M.show_ui(unpack(last_ui))
  end
end

function M.split_right(size)
  local Split = require 'nui.split'
  local file = vim.fn.expand('%', nil, nil)
  Split({
    relative = 'editor',
    position = 'right',
    size = size,
  }):mount()
  vim.cmd('e ' .. file)
end

function M.split_external()
  local win = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(win)
  vim.api.nvim_open_win(
    bufnr,
    true,
    { external = true, width = 50, height = 20 }
  )
end

local group = vim.api.nvim_create_augroup('My_win', {})

local last_special
local last_regular

function is_regular(win)
  local bufnr = vim.api.nvim_win_get_buf(win)
  local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
  return buftype == ''
end

local function regular_buffer_filter(windows_id, _)
  return vim.tbl_filter(is_regular, windows_id)
end

local function special_buffer_filter(windows_id, _)
  return vim.tbl_filter(function(win)
    return not is_regular(win)
  end, windows_id)
end

vim.api.nvim_create_autocmd('WinLeave', {
  pattern = '*',
  group = group,
  callback = function()
    local win = vim.api.nvim_get_current_win()
    if is_regular(win) then
      last_regular = win
    else
      last_special = win
    end
  end,
})

function cycle(period, i0, i)
  local res = i + i0 - 1
  if res > period then
    return res - period
  end
  return res
end

function M.cycle_focus_within_buftype(want_regular)
  local current = vim.api.nvim_get_current_win()
  if is_regular(current) ~= want_regular then
    local win = want_regular and last_regular or last_special
    if win then
      return vim.api.nvim_set_current_win(win)
    end
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, win_ in ipairs(wins) do
      if is_regular(win_) == want_regular then
        return vim.api.nvim_set_current_win(win_)
      end
    end
  end
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local n = #wins
  local i0
  for i, win in ipairs(wins) do
    if win == current then
      i0 = i
      break
    end
  end
  for i = 1 + 1, n do
    local i_ = cycle(n, i0, i)
    local win = wins[i_]
    if is_regular(win) == want_regular then
      return vim.api.nvim_set_current_win(win)
    end
  end
end

function M.focus_any()
  local win = require('window-picker').pick_window {
    include_current_win = true,
    filter_func = function(windows_id)
      return windows_id
    end,
  }
  if win then
    return vim.api.nvim_set_current_win(win)
  end
end

function M.focus_buftype(want_regular)
  local current = vim.api.nvim_get_current_win()
  local win
  if is_regular(current) ~= want_regular then
    local win0 = want_regular and last_regular or last_special
    if win0 and vim.api.nvim_win_is_valid(win0) then
      win = win0
    end
  end
  if not win then
    local filter = want_regular and regular_buffer_filter
      or special_buffer_filter
    win = require('window-picker').pick_window {
      filter_func = filter,
    }
  end
  if win then
    vim.api.nvim_set_current_win(win)
  end
end

function M.pick_same_buftype() end

function M.pick(plain)
  plain = not not plain
  function filter(windows_id)
    return vim.tbl_filter(function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
      return (buftype == '') == plain
    end, windows_id)
  end

  local wins = vim.api.nvim_tabpage_list_wins(0)
  wins = filter(wins)
  if #wins == 2 then
    local current = vim.api.nvim_get_current_win()
    if wins[1] == current then
      return wins[2]
    elseif wins[2] == current then
      return wins[1]
    end
  end
  return require('window-picker').pick_window {
    filter_func = filter,
  }
end

function M.pick_focus(plain)
  local win = M.pick(plain)
  if win then
    vim.api.nvim_set_current_win(win)
  end
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
