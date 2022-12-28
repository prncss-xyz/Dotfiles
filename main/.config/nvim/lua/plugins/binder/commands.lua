M = {}

-- REFACT: get consistent with commands

function M.setup()
  local command = require('legendary').command

  -- FIX:
  for _, v in ipairs {
    'lua=',
    'PutText',
  } do
    command { ':' .. v .. ' ', unfinished = true }
  end
end

return M
