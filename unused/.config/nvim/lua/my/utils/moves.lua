local M = {}

function M.fwd_or_cb(cb)
  local buffers = require 'flies.utils.buffers'
  local pos = buffers.get_cursor()
  local row, col = unpack(pos)
  local line = buffers.get_line(0, row)
  if col <= #line then
    col = col + 1
    buffers.set_cursor { row, col }
  else
    cb()
  end
end

local function prev(pos, ofs)
  local row, col = unpack(pos)
  local buffers = require 'flies.utils.buffers'
  if
    row > buffers.get_eob(0)
    or buffers.get_line(0, row):sub(1, col - 1):match '^%s*$'
  then
    if row == 1 then
      return { 1, 1 }
    end
    row = row - 1
    local len = buffers.get_line(0, row):len()
    return { row, len + ofs }
  end
  return { row, col - 1 }
end

local function next_(pos, ofs)
  local row, col = unpack(pos)
  local buffers = require 'flies.utils.buffers'
  local line = buffers.get_line(0, row)
  if col < line:len() + ofs then
    return { row, col + 1 }
  end
  if row == buffers.get_eob(0) then
    return { row, col }
  end
  row = row + 1
  line = buffers.get_line(0, row)
  if line == '' then
    return { row, 1 }
  end
  col = line:find '%S' or line:len()
  return { row, col }
end

function M.fwd(insert)
  local windows = require 'flies.utils.windows'
  local pos = windows.get_cursor()
  windows.set_cursor(next_(pos, insert and 1 or 0))
end

function M.bwd(insert)
  local windows = require 'flies.utils.windows'
  local pos = windows.get_cursor()
  windows.set_cursor(prev(pos, insert and 1 or 0))
end

return M
