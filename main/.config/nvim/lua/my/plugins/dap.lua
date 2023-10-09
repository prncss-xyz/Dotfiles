local function dapui_open()
  local dapui = require 'dapui'
  dapui.open()
  require('nvim-dap-virtual-text').enable()
  -- require 'gitsigns'
  require('gitsigns').toggle_current_line_blame(false)
end

local function dapui_close()
  local dapui = require 'dapui'
  dapui.open()
  require('nvim-dap-virtual-text').disable()
  require('gitsigns').toggle_current_line_blame(true)
end

return {
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'leoluz/nvim-dap-go',
    },
    opts = {
      ensure_installed = { 'go-debug-adapter' },
      automatic_installation = true,
    },
  },
  {
    'mfussenegger/nvim-dap',
    name = 'dap',
    opts = {},
    config = function(_, opts)
      local deep_merge = require('my.utils.std').deep_merge
      local dap = require 'dap'
      deep_merge(dap, opts)
      dap.listeners.after.event_initialized['dapui_config'] = dapui_open
      dap.listeners.before.event_terminated['dapui_config'] = dapui_close
      dap.listeners.before.event_exited['dapui_config'] = dapui_close
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
    end,
    dependencies = {
      'theHamsta/nvim-dap-virtual-text',
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
    },
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    name = 'dapui',
    opts = {},
  },
  {
    'jbyuki/one-small-step-for-vimkind',
    dependencies = { 'mfussenegger/nvim-dap' },
    name = 'osv',
    opts = {},
  },
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    opts = {},
    enabled = false,
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    opts = {},
    enabled = false,
  },
}
