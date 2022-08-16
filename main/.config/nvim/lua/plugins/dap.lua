local M = {}

function M.config()
  local dap = require 'dap'
  vim.fn.sign_define(
    'DapBreakpoint',
    { text = 'ﱣ', texthl = 'DiagnosticError', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapStopped',
    { text = '', texthl = 'DiagnosticHint', linehl = '', numhl = '' }
  )

  -- https://github.com/jbyuki/one-small-step-for-vimkind
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

  -- https://github.com/mxsdev/nvim-dap-vscode-js
  for _, language in ipairs { 'typescript', 'javascript' } do
    require('dap').configurations[language] = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach',
        processId = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
      },
    }
  end
end

function M.launch()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand '%'
  if filetype == 'lua' then
    -- require('osv').launch()
    require('osv').run_this()
    return
  end

  if filetype == 'javascript' then
    if vim.endswith(filename, '.test.js') then
      require('neotest').run.run { strategy = 'dap' }
      return
    end
  end
  print('no launcher for filetype ' .. filetype)
end

return M
