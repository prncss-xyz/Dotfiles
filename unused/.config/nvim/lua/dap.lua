
local M = {}
local dap = require 'dap'

local function pick_process()
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

function M.setup()
  vim.fn.sign_define(
    'DapBreakpoint',
    { text = '🛑', texthl = '', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapStopped',
    { text = '🟢', texthl = '', linehl = '', numhl = '' }
  )
  -- vim.fn.sign_define('DapLogPoint', {text='→', texthl='', linehl='', numhl=''})
  -- vim.fn.sign_define('DapBreakpointRejected', {text='R', texthl='', linehl='', numhl=''})

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
end

return M
