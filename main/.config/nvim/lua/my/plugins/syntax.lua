return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'markdown',
        'markdown_inline',
        'bash',
        'c',
        'css',
        'fish',
        'go',
        'graphql',
        'html',
        'javascript',
        'json',
        'lua',
        'python',
        'query',
        'ql',
        'regex',
        'toml',
        'tsx',
        'typescript',
        'yaml',
        'vim', -- noice.nvim needs it
      },
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = { 'markdown' },
      },
      indent = {
        enable = true,
      },
      context_commentstring = {
        enable_autocommand = false,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      vim.treesitter.language.register('markdown', 'mdx')
    end,
    dependencies = {
      'HiPhish/rainbow-delimiters.nvim',
    },
    event = 'ColorSchemePre',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      min_window_height = 30,
      --[[ multiline_threshold = 3,
      trim_scope = 'outer', ]]
    },
    cmd = {
      'TSContextEnable',
      'TSContextDisable',
      'TSContextToggle',
    },
    event = 'VeryLazy',
    enabled = true,
  },
  {
    'code-biscuits/nvim-biscuits',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      cursor_line_only = true,
    },
    event = 'VeryLazy',
    enabled = true,
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = function()
      local rainbow_delimiters = require 'rainbow-delimiters'
      return {
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
    config = function(_, opts)
      vim.g.rainbow_delimiters = opts
    end,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
    event = 'VeryLazy',
  },

  -- syntax
  { 'ajouellette/sway-vim-syntax', ft = 'sway' },
  -- use 'fladson/vim-kitty'
}
