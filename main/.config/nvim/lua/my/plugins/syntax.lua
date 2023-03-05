return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = require('my.config.nvim-treesitter-context').config,
    event = 'VeryLazy',
  },
  {
    'mrjones2014/nvim-ts-rainbow',
    event = 'VeryLazy',
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'VeryLazy',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = require('my.config.nvim-treesitter').config,
    event = 'ColorSchemePre'
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
