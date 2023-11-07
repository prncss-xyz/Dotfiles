return {
  {
    'kevinhwang91/nvim-hlslens',
    name = 'hlslens',
    opts = {
      calm_down = true,
    },
    event = 'VeryLazy',
  },
  {
    'utilyre/sentiment.nvim',
    event = 'VeryLazy', -- keep for lazy loading
    opts = {},
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    'stevearc/aerial.nvim',
    opts = {
      layout = {
        default_direction = 'left',
        min_width = require('my.parameters').pane_width,
      },
      backends = {
        'treesitter',
        'lsp',
        'markdown',
      },
      filter_kind = false,
    },
    cmd = {
      'AerialOpen',
      'AerialClose',
      'AerialInfo',
      'AerialNext',
      'AerialPrev',
    },
  },
  {
    'RRethy/vim-illuminate',
    opts = {
      under_cursor = false,
      filetypes_denylist = { 'NeogitStatus' },
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
    event = 'VeryLazy',
  },
}
