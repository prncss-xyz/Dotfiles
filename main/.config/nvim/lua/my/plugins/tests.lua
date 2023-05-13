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
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-jest',
      'nvim-neotest/neotest-go',
      'mrcjkb/neotest-haskell',

      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
    },
    config = function()
      require('neotest').setup {
        icons = {
          running = '勒',
        },
        adapters = {
          -- require 'neotest-plenary',
          require 'neotest-vitest',
          -- require 'neotest-jest',
          require 'neotest-go',
          require 'neotest-haskell',
        },
        diagnostic = {
          enabled = true,
          severity = vim.diagnostic.severity.ERROR,
        },
        -- causes overseer run popup to appear when lauching jest debug
        -- works fine when calling neotest directly
        -- consumers = {
        -- overseer = require 'neotest.consumers.overseer',
        -- },
        -- overseer = {
        --   enabled = true,
        --   -- when this is true (the default), it will replace all neotest.run.* commands
        --   force_default = false,
        -- },
      }
    end,
    lazy = false,
  },
  {
    'mfussenegger/nvim-dap',
    name = 'dap',
    config = require('my.config.dap').config,
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
  },
  {
    'leoluz/nvim-dap-go',
    opts = {},
  },
}
