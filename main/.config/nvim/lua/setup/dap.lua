local dap = require 'dap'

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
  },
}

dap.adapters.nlua = function(callback)
  -- callback { type = 'server', host = config.host, port = config.port }
  callback { type = 'server', host = '127.0.0.1', port = 30001 }
end

local launch = function()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    require('osv').launch { type = 'server', host = '127.0.0.1', port = 30001 }
  end
end

return {
  launch = launch,
}
