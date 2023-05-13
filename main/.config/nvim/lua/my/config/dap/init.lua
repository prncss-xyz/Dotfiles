local M = {}

function M.config()
  local dap = require 'dap'
  local dapui = require 'dapui'

  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
    require('nvim-dap-virtual-text').enable()
    require 'gitsigns'
    require('gitsigns').toggle_current_line_blame(false)
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
    require('nvim-dap-virtual-text').disable()
    require('gitsigns').toggle_current_line_blame(true)
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
    require('nvim-dap-virtual-text').disable()
    require('gitsigns').toggle_current_line_blame(true)
  end

  require 'my.config.dap.lua'
  require 'my.config.dap.javascript'
end

function M.launch()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    -- require('osv').launch { port = 8086 }
    require('osv').run_this()
    return
  elseif filetype == 'go' then
    require('dap').run {
      type = 'go',
      request = 'launch',
    }
  else
    require('dap').run {
      type = 'pwa-node',
      request = 'launch',
    }
    -- require('dap').launch()
    -- log_error 'unsupported filetype'
  end
end

return M
