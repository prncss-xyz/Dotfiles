return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = require('my.config.nvim-treesitter-context').config,
    event = 'VeryLazy',
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      local rainbow_delimiters = require 'rainbow-delimiters'
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
          -- tsx = 'rainbow-delimiters-react',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
    event = 'ColorScheme',
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'VeryLazy',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = require('my.config.nvim-treesitter').config,
    event = 'ColorSchemePre',
  },
  { 'mfussenegger/nvim-ts-hint-textobject' },
  {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
  },
  -- Use tressitter to autoclose and autorename HTML tag
  { 'windwp/nvim-ts-autotag', event = 'InsertEnter' },
  {
    -- annotation toolkit
    'danymat/neogen',
    opts = {
      enabled = true,
      snippet_engine = 'luasnip',
    },
  },

  -- syntax
  { 'ajouellette/sway-vim-syntax', ft = 'sway' },
  -- use 'fladson/vim-kitty'
}
