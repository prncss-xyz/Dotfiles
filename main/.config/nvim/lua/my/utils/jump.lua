local M = {}

-- move amongst jumplist position within current buffer,
-- also includes initial cursor position to the list

local register = require('flies.actions.move_again').register
local jumps, index, len, pos

local function go(fwd)
  local count = vim.v.count1
  local index_old = index
  local bufnr = vim.api.nvim_get_current_buf()
  while true do
    if fwd then
      index = index - 1
      if index == 0 then
        break
      end
    else
      len = len or #jumps
      index = index + 1
      if index > len then
        if count == 1 then
          vim.api.nvim_win_set_cursor(0, pos)
          return
        end
        break
      end
    end
    local jump = jumps[index]
    if jump and jump.bufnr == bufnr then
      count = count - 1
      if count == 0 then
        vim.api.nvim_win_set_cursor(0, { jump.lnum, jump.col })
        return
      end
    end
  end
  index = index_old
end

local function init()
  pos = vim.api.nvim_win_get_cursor(0)
  jumps, index = unpack(vim.fn.getjumplist())
  index = index + 1 -- correcting for zero-based index
  register(function()
    go(true)
  end, function()
    go(false)
  end)
end

function M.next()
  init()
  go(true)
end

return M
