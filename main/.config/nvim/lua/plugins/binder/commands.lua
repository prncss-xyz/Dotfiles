M = {}

-- REFACT: get consistent with commands

function M.setup()
  local command = require('legendary').command

  for _, v in ipairs {
    'Dump',
    'PutText',
  } do
    command { ':' .. v .. ' ', unfinished = true }
  end
end

return M
