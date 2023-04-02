return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      --[[ 'nvim-neotest/neotest-plenary', ]]
      -- not working, issues with lazy loading
    },
    config = require('my.config.neotest').config,
  },
  {
    'mfussenegger/nvim-dap',
    name = 'dap',
    config = require('my.config.dap').config,
    dependencies = {
      'theHamsta/nvim-dap-virtual-text',
    },
    lazy = false,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {},
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    name = 'dapui',
    opts = {},
    lazy = false,
  },
  {
    'jbyuki/one-small-step-for-vimkind',
    dependencies = { 'mfussenegger/nvim-dap' },
    name = 'osv',
  },
}
