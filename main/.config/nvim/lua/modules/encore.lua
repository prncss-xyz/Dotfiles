local M = {}

-- n/N fFtT ?? s 
-- textobjects

local backward
local forward

local function exec(e)
  if type(e) == 'string' then
    return (vim.cmd(e))
  end
  if type(e) == 'function' then
    return e()
  end
end

function M.register(b, f)
  backward = b
  forward = f
end

function M.backward()
  exec(backward)
end

function M.backward()
  exec(forward)
end

return M
