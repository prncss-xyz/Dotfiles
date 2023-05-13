local dap = require 'dap'

if false then
  dap.adapters.javascript = {
    {
      -- https://vitest.dev/guide/debugging.html
      type = 'pwa-node',
      request = 'launch',
      name = 'Debug current test file',
      autoAttachChildProcesses = true,
      skipFiles = { '<node_internals>/**', '**/node_modules/**' },
      program = '${workspaceRoot}/node_modules/vitest/vitest.mjs',
      args = { 'run', '${relativeFile}' },
      smartStep = true,
    },
    -- {
    --   type = 'pwa-node',
    --   request = 'launch',
    --   name = 'Launch file',
    --   program = '${file}',
    --   cwd = '${workspaceFolder}',
    -- },
    -- {
    --   type = 'pwa-node',
    --   request = 'attach',
    --   name = 'Attach',
    --   processId = require('dap.utils').pick_process,
    --   cwd = '${workspaceFolder}',
    -- },
  }
else
  if false then
    dap.adaperts['pwa-node'] = {
      type = 'executable',
      commmand = 'node',
      args = {},
    }
    dap.configurations.javascript =
      require('my.config.nvim-dap-vscode-js').adapters
    dap.configurations.typescript =
      require('my.config.nvim-dap-vscode-js').adapters
  else
    dap.configurations.javascript =
      require('my.config.nvim-dap-vscode-js').adapters
    dap.configurations.typescript =
      require('my.config.nvim-dap-vscode-js').adapters
  end
end
if false then
  dap.adapters.javascript = {
    {
      -- https://vitest.dev/guide/debugging.html
      type = 'pwa-node',
      request = 'launch',
      name = 'Debug current test file',
      autoAttachChildProcesses = true,
      skipFiles = { '<node_internals>/**', '**/node_modules/**' },
      program = '${workspaceRoot}/node_modules/vitest/vitest.mjs',
      args = { 'run', '${relativeFile}' },
      smartStep = true,
    },
    -- {
    --   type = 'pwa-node',
    --   request = 'launch',
    --   name = 'Launch file',
    --   program = '${file}',
    --   cwd = '${workspaceFolder}',
    -- },
    -- {
    --   type = 'pwa-node',
    --   request = 'attach',
    --   name = 'Attach',
    --   processId = require('dap.utils').pick_process,
    --   cwd = '${workspaceFolder}',
    -- },
  }
else
  if false then
    dap.adaperts['pwa-node'] = {
      type = 'executable',
      commmand = 'node',
      args = {},
    }
    dap.configurations.javascript =
      require('my.config.nvim-dap-vscode-js').adapters
    dap.configurations.typescript =
      require('my.config.nvim-dap-vscode-js').adapters
  else
    dap.configurations.javascript =
      require('my.config.nvim-dap-vscode-js').adapters
    dap.configurations.typescript =
      require('my.config.nvim-dap-vscode-js').adapters
  end
end
