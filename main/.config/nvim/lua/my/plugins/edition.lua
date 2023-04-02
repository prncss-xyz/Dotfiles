return {
  {
    dir = require('my.utils').local_repo 'flies2.nvim',
    config = require('my.config.flies2').config,
    keys = { '<plug>(flies-select)' },
  },
  { 'linty-org/readline.nvim' },
  {
    'Wansmer/treesj',
    opts = {},
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
  },
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = require('my.config.comment').config,
    keys = {
      '<plug>(comment_toggle_blockwise)',
      '<plug>(comment_toggle_blockwise_visual)',
      '<plug>(comment_toggle_linewise)',
      '<plug>(comment_toggle_linewise_visual)',
    },
  },
  {
    'nvim-pack/nvim-spectre',
    config = require('my.config.nvim-spectre').config,
    name = 'spectre',
    module = 'spectre',
  },
  {
    'gbprod/substitute.nvim',
    config = {
      range = {
        prefix = false,
        prompt_current_text = false,
        confirm = false,
        complete_word = false,
        motion1 = false,
        motion2 = false,
        suffix = '',
      },
      exchange = {
        motion = false,
      },
    },
  },
  {
    'AckslD/nvim-FeMaco.lua',
    cmd = 'FeMaco',
    name = 'femaco',
    opts = {},
    enable = false,
  },

  -- completion
  {
    'L3MON4D3/LuaSnip',
    config = require('my.config.luasnip').config,
  },
  {
    'hrsh7th/nvim-cmp',
    -- event = { 'InsertEnter' },
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = require('my.config.cmp').config,
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      'hrsh7th/cmp-nvim-lsp',
    },
  },
  {
    'windwp/nvim-autopairs',
    config = require('my.config.nvim-autopairs').config,
    event = 'InsertEnter',
  },

  -- navigation
  {
    'chentoast/marks.nvim',
    event = 'BufReadPost',
    config = function()
      require('marks').setup {
        default_mappings = false,
        refresh_interval = 0,
      }
      -- https://github.com/chentoast/marks.nvim/issues/40
      vim.api.nvim_create_autocmd('cursorhold', {
        pattern = '*',
        callback = require('marks').refresh,
      })
    end,
  },
  {
    'phaazon/hop.nvim',
    module = 'hop',
    config = require('my.config.hop').config,
  },
}
