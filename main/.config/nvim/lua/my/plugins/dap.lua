return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
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
    enabled = true,
  },
  {
    'rcarriga/nvim-dap-ui',
    name = 'dapui',
    opts = {},
    dependencies = {
      --[[ 'mfussenegger/nvim-dap', ]]
      'nvim-neotest/nvim-nio',
    },
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
    enabled = true,
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
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = 'go',
    opts = {},
    enabled = true,
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    dependencies = { 'mfussenegger/nvim-dap' },
    opts = {
      adapters = {
        'pwa-node',
        'pwa-chrome',
        'pwa-msedge',
        'node-terminal',
        'pwa-extensionHost',
      }, -- which adapters to register in nvim-dap
    },
    config = function(_, opts)
      require('dap-vscode-js').setup(opts)

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
    end,
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  },
}
