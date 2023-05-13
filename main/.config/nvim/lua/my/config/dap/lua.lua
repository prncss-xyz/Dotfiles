local dap = require 'dap'
-- https://github.com/jbyuki/one-small-step-for-vimkind
if true then
  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = 'Attach to running Neovim instance',
    },
  }

  dap.adapters.nlua = function(callback, config)
    callback {
      type = 'server',
      host = config.host or '127.0.0.2',
      port = config.port or 8086,
    }
  end
else
  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = 'Attach to running Neovim instance',
      host = function()
        local value = vim.fn.input 'Host [127.0.0.1]: '
        if value ~= '' then
          return value
        end
        return '127.0.0.1'
      end,
      port = function()
        local val = tonumber(vim.fn.input 'Port: ')
        assert(val, 'Please provide a port number')
        return val
      end,
    },
  }
  dap.adapters.nlua = function(callback, config)
    callback { type = 'server', host = config.host, port = config.port }
  end
end
