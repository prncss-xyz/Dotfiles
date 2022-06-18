local M = {}

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

function M.stop_by_name(name)
  local client = require('plugins.lsp.utils').get_client(name)
  if not client then
    return
  end
  vim.lsp.stop_client(client, true)
end

-- From echasnovski/mini.nvim

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

function M.starts_with(full, prefix)
  if full:sub(1, prefix:len()) == prefix then
    return true
  end
end

function M.split_string(str, delimiter)
  local result = {}
  local from = 1
  local delim_from, delim_to = string.find(str, delimiter, from)
  while delim_from do
    table.insert(result, string.sub(str, from, delim_from - 1))
    from = delim_to + 1
    delim_from, delim_to = string.find(str, delimiter, from)
  end
  table.insert(result, string.sub(str, from))
  return result
end

-- ?? vim.tbl_deep_extend instead ??
-- TODO merge arrays
function M.deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == 'table') and (type(t1[k] or false) == 'table') then
      M.deep_merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

function M.invert(tbl)
  local res = {}
  for key, value in pairs(tbl) do
    res[value] = key
  end
  return res
end

-- http://lua-users.org/wiki/StringRecipes
function M.encode_uri(str)
  if str then
    str = str:gsub('\n', '\r\n')
    str = str:gsub('([^%w %-%_%.%~])', function(c)
      return ('%%%02X'):format(string.byte(c))
    end)
    str = str:gsub(' ', '+')
  end
  return str
end

function M.file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return M
