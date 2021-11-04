local m = {}

function m.setup()
  local dap_install = require 'dap-install'
  dap_install.setup {}
  dap_install.config('jsnode', {})

  local dbg_path = require('dap-install.config.settings').options['installation_path']
    .. 'jsnode/'

  require('dap').adapters.jest = {
    type = 'executable',
    command = 'jest',
    args = {},
    -- args = { dbg_path .. 'vscode-node-debug2/out/src/nodeDebug.js' },
  }
  require('telescope').load_extension 'dap'
end

return m
