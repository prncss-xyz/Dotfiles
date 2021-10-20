local M = {}
local deep_merge = require('utils').deep_merge

function M.setup()
  local o = {
    watch_index = {
      interval = 100,
    },
    sign_priority = 5,
    status_formatter = nil, -- Use default
  }
  -- FIXME: creates binding conflict
  -- deep_merge(o, require('bindings').plugins.gitsigns)
  deep_merge(o, require('signs').plugins.gitsigns)
  require('gitsigns').setup(o)
end

return M
