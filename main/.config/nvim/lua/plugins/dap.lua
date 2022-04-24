local M = {}

--[[
.. https://www.reddit.com/r/neovim/comments/tylrud/how_can_i_skip_unecessary_files_before_debugging/
dap.run({
  type = "node2",
  skipFiles = { "<node_internals>/**/*.js" },
  -- ...
})
--]]

local function pick_process()
  local dap = require 'dap'
  local output = vim.fn.system { 'ps', 'a' }
  local lines = vim.split(output, '\n')
  local procs = {}
  for _, line in pairs(lines) do
    -- output format
    --    " 107021 pts/4    Ss     0:00 /bin/zsh <args>"
    local parts = vim.fn.split(vim.fn.trim(line), ' \\+')
    local pid = parts[1]
    local name = table.concat({ unpack(parts, 5) }, ' ')
    if pid and pid ~= 'PID' then
      pid = tonumber(pid)
      if pid ~= vim.fn.getpid() then
        table.insert(procs, { pid = tonumber(pid), name = name })
      end
    end
  end
  local choices = { 'Select process' }
  for i, proc in ipairs(procs) do
    table.insert(
      choices,
      string.format('%d: pid=%d name=%s', i, proc.pid, proc.name)
    )
  end
  local choice = vim.fn.inputlist(choices)
  if choice < 1 or choice > #procs then
    return nil
  end
  return procs[choice].pid
end

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
  vim.cmd "au FileType dap-repl lua require('dap.ext.autocompl').attach()"

  --[[
- `DapBreakpoint` which defaults to `B` for breakpoints
- `DapBreakpointCondition` which defaults to `C` for conditional breakpoints
- `DapLogPoint` which defaults to `L` and is for log-points
- `DapStopped` which defaults to `→` and is used to indicate the position where
  the debugee is stopped.
- `DapBreakpointRejected`, defaults to `R` for breakpoints which the debug
  adapter rejected.
--]]

  dap.defaults.fallback.external_terminal = {
    command = os.getenv 'TERMINAL',
    args = { '-e' },
  }
  dap.defaults.fallback.force_external_terminal = true

  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = 'Attach to running Neovim instance',
      host = function()
        return '127.0.0.1'
      end,
      port = function()
        local val = 54231
        return val
      end,
    },
  }
  dap.adapters.nlua = function(callback, config)
    callback { type = 'server', host = config.host, port = config.port }
    -- callback { type = 'server', host = '127.0.0.1', port = 30001 }
  end

  -- git clone https://github.com/microsoft/vscode-node-debug2.git
  -- cd vscode-node-debug2
  -- npm install
  -- npm run build
  dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = {
      os.getenv 'HOME'
        .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js',
    },
  }
  dap.configurations.javascript = {
    {
      name = 'Launch',
      type = 'node2',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = 'Attach to process',
      type = 'node2',
      request = 'attach',
      processId = function()
        return require('dap.utils').pick_process()
      end,
    },
  }
  -- git clone https://github.com/Microsoft/vscode-chrome-debug
  -- cd ./vscode-chrome-debug
  -- npm install
  -- npm run build
  dap.adapters.chrome = {
    type = 'executable',
    command = 'node',
    args = {
      os.getenv 'HOME' .. '/path/to/vscode-chrome-debug/out/src/chromeDebug.js',
    }, -- TODO adjust
  }

  dap.configurations.javascriptreact = { -- change this to javascript if needed
    {
      type = 'chrome',
      request = 'attach',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      port = 9222,
      webRoot = '${workspaceFolder}',
    },
  }

  dap.configurations.typescriptreact = { -- change to typescript if needed
    {
      type = 'chrome',
      request = 'attach',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      port = 9222,
      webRoot = '${workspaceFolder}',
    },
  }
end

function M.launch()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    -- require('osv').launch()
    require('osv').run_this()
    return
  end
  print('no launcher for filetype ' .. filetype)
end

vim.api.nvim_create_user_command('LaunchOSV', function()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    -- require('osv').run_this()
    require('osv').launch { type = 'server', host = '127.0.0.1', port = 30000 }
  end
end, { narg = 0 })

--   local dap_install = require 'dap-install'
--   dap_install.setup {}
--   dap_install.config('jsnode', {})
--
--   local dbg_path = require('dap-install.config.settings').options['installation_path']
--     .. 'jsnode/'
--
--   require('dap').adapters.jest = {
--     type = 'executable',
--     command = 'jest',
--     args = {},
--     -- args = { dbg_path .. 'vscode-node-debug2/out/src/nodeDebug.js' },
--   }
--   require('telescope').load_extension 'dap'
-- end

return M
