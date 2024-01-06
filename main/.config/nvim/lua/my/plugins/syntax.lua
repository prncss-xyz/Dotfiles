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
      autotag = {
        enable = true,
      },
      context_commentstring = {
        enable_autocommand = false,
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- installs relevant grammar on file opening
      local group = vim.api.nvim_create_augroup('MyTS', {})
      local ts_parsers = require 'nvim-treesitter.parsers'
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*' },
        group = group,
        callback = function()
          local ft = vim.bo.filetype
          local parser = ts_parsers.filetype_to_parsername[ft]
          if not parser then
            return
          end
          local is_installed = ts_parsers.has_parser(ts_parsers.ft_to_lang(ft))
          if not is_installed then
            vim.cmd { cmd = 'TSInstall', args = { parser } }
          end
        end,
      })
    end,
    dependencies = {
      'HiPhish/rainbow-delimiters.nvim',
    },
    event = 'ColorSchemePre',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
    cmd = {
      'TSContextEnable',
      'TSContextDisable',
      'TSContextToggle',
    },
    event = 'VeryLazy',
    enabled = false,
  },
  {
    'code-biscuits/nvim-biscuits',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
    event = 'VeryLazy',
    enabled = false,
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
    event = 'VeryLazy',
  },
  {
    'mfussenegger/nvim-ts-hint-textobject',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    enabled = false,
  },
  {
    'nvim-treesitter/playground',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
    enabled = true,
  },
  -- Use tressitter to autoclose and autorename HTML tag
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'InsertEnter',
  },
  {
    -- annotation toolkit
    'danymat/neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enabled = true,
      snippet_engine = 'luasnip',
    },
  },

  -- syntax
  { 'ajouellette/sway-vim-syntax', ft = 'sway' },
  -- use 'fladson/vim-kitty'
}
