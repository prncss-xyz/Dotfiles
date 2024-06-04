local M = {}

function M.blank()
  local text = ''
  for i = 1, vim.v.count1 do
    text = text .. '\n'
    local buffers = require 'longnose.my.utils.buffers'
    local cursor = buffers.get_cursor(0)
    -- TODO:
    -- buffers.text_replace(0, {, , text})
  end
end

function M.local_repo(name)
  return os.getenv 'HOME' .. '/Projects/github.com/prncss-xyz/' .. name
end

-- https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/util.lua
function M.extract_nvim_hl(name)
  local hl_str = vim.api.nvim_exec('highlight ' .. name, true)
  local hl = {
    fg = hl_str:match 'guifg=([^%s]+)' or '',
    bg = hl_str:match 'guibg=([^%s]+)' or '',
    style = hl_str:match 'gui=([^%s]+)' or '',
    name = name,
  }
  return hl
end

--- Print Lua objects in command line
---
---@param ... any Any number of objects to be printed each on separate line.
function M.put(...)
  local objects = {}
  -- Not using `{...}` because it removes `nil` input
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))

  return ...
end

--- Print Lua objects in current buffer
---
---@param ... any Any number of objects to be printed each on separate line.
function M.put_text(...)
  local objects = {}
  -- Not using `{...}` because it removes `nil` input
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  local lines = vim.split(table.concat(objects, '\n'), '\n')
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(lnum, lines)

  return ...
end

function M.term()
  require('plenary').job
    :new({
      command = vim.env.TERMINAL,
      args = {},
    })
    :start()
end

function M.open_current()
  require('plenary').job
    :new({
      command = 'xdg-open',
      args = { vim.fn.expand('%', nil, nil) },
    })
    :start()
end

function M.xplr_launch()
  require('plenary').job
    :new({
      command = vim.env.TERMINAL,
      args = { 'xplr', vim.fn.expand('%', nil, nil) },
    })
    :start()
end

function M.edit_current()
  local current = vim.fn.expand('%', nil, nil)
  require('plenary').job
    :new({
      command = vim.env.TERMINAL,
      -- args = {'-e', 'nvim', current},
      -- without sh, nvim occupies only small portion of terminal
      args = { '-e', 'sh', '-c', 'nvim ' .. current },
    })
    :start()
end

function M.reset_editor()
  require('plenary').job
    :new({
      command = 'swaymsg',
      -- args = {'-e', 'nvim', current},
      -- without sh, nvim occupies only small portion of terminal
      args = { 'exec', vim.env.TERMINAL, ' -e', 'sh -c nvim' },
    })
    :sync()
  vim.cmd 'quitall'
end

return M
