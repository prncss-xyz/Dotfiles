return {
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
}
