return {
  {
    'mfussenegger/nvim-dap',
    name = 'dap',
    config = function(_, _)
      require 'dapui'
    end,
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = {
          'williamboman/mason.nvim',
        },
        opts = {
          automatic_installation = true,
        },
      },
    },
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    name = 'dapui',
    opts = {},
    config = function()
      require('dapui').setup()
      local dap = require 'dap'
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

      dap.listeners.after.event_initialized['dapui_config'] = dapui_open
      dap.listeners.before.event_terminated['dapui_config'] = dapui_close
      dap.listeners.before.event_exited['dapui_config'] = dapui_close
    end,
  },
  {
    'jbyuki/one-small-step-for-vimkind',
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = 'lua',
    name = 'osv',
    opts = {},
    config = function()
      local dap = require 'dap'
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
    enabled = true,
  },
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    opts = {},
    enabled = false,
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    enabled = false,
  },
}
