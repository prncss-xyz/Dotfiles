local M = {}

local log_error = require('my.utils.vim').log_error

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

  local dap, dapui = require 'dap', require 'dapui'
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

  -- https://github.com/jbyuki/one-small-step-for-vimkind
  if false then
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
end

function M.launch()
  local filetype = vim.bo.filetype
  if filetype == 'lua' then
    -- require('osv').launch { port = 8086 }
    require('osv').run_this()
    return
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
