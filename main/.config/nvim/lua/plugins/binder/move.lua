local M = {}

function M.extend()
  local binder = require 'binder'
  local keys = binder.keys
  local b = binder.b
  local lazy_req = require('plugins.binder.util').lazy_req
  return keys {}
end

return M
