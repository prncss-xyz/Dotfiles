local utils = require 'utils'
local job_sync = utils.job_sync

local project_root = function()
  local pr = job_sync(vim.fn.expand '~/.local/bin/project_root', {})[1]
  vim.cmd('cd ' .. pr)
end
