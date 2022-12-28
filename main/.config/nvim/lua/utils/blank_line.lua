local M = {}

function M.blank_line(fwd)
  local buffers = require 'longnose.utils.buffers'
  local text = ''
  for _ = 1, vim.v.count1 do
    text = text .. '\n'
  end
  local pos = buffers.get_cursor(0)
  if fwd then
    buffers.text_replace(0, { { { pos[1] + 1, 1 }, { pos[1] + 1, 0 }, text } })
  else
    buffers.text_replace(0, { { { pos[1], 1 }, { pos[1], 0 }, text } })
  end
end

return M
