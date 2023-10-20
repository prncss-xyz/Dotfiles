return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-jest',
      'nvim-neotest/neotest-go',
      'mrcjkb/neotest-haskell',
      'nvim-neotest/neotest-plenary',

      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'antoinemadec/FixCursorHold.nvim',
        init = function()
          vim.g.cursorhold_updatetime = 100 -- https://github.com/antoinemadec/FixCursorHold.nvim
        end,
      },
    },
    config = function()
      require('neotest').setup {
        icons = {
          running = '勒',
        },
        adapters = {
          require 'neotest-plenary',
          -- require 'neotest-vitest',
          -- require 'neotest-jest',
          -- require 'neotest-go',
          -- require 'neotest-haskell',
        },
        diagnostic = {
          enabled = true,
          severity = vim.diagnostic.severity.ERROR,
        },
        consumers = {
          overseer = require 'neotest.consumers.overseer',
        },
        overseer = {
          enabled = true,
          force_default = false,
        },
      }
    end,
    lazy = true,
  },
}
