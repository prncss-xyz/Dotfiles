local M = {}

-- could be a feature of autopairs
local pats = {
  default = { '(', ')', '{', '}', '[', ']', '<', '>', '"', "'", '`', ',' },
  markdown = {
    '**',
    '*',
    '```',
    '_',
    '(',
    ')',
    '{',
    '}',
    '[',
    ']',
    '<',
    '>',
    '"',
    "'",
    '`',
    ',',
  },
}

function M.tab(fwd)
  local buffers = require 'longnose.utils.buffers'
  local ft = vim.bo.filetype
  local pos = buffers.get_cursor(0)
  local line = buffers.get_line(0, pos[1])
  local pat = pats[ft] or pats.default
  if fwd then
    local part = line:sub(pos[2])
    for _, p in ipairs(pat) do
      if vim.startswith(part, p) then
        buffers.set_cursor(0, { pos[1], pos[2] + p:len() })

        return true
      end
    end
  else
    local part = line:sub(1, pos[2] - 1)
    for _, p in ipairs(pat) do
      if vim.endswith(part, p) then
        buffers.set_cursor(0, { pos[1], pos[2] - p:len() })
        return true
      end
    end
  end
end

return M
