return {
  {
    -- user has disappeared
    dir = os.getenv 'HOME' .. '/Projects/github.com/linty-org/readline.nvim',
  },
  {
    'Wansmer/treesj',
    opts = {
      use_default_keymaps = false,
      notify = false,
    },
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
  },
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = function()
      return {
        mappings = {
          basic = false,
          extra = false,
        },
        pre_hook = require(
          'ts_context_commentstring.integrations.comment_nvim'
        ).create_pre_hook(),
      }
    end,
    config = function(_, opts)
      local ft = require 'Comment.ft'
      ft.set('sway', '#%s')
      require('Comment').setup(opts)
    end,
    keys = {
      '<plug>(comment_toggle_blockwise)',
      '<plug>(comment_toggle_blockwise_visual)',
      '<plug>(comment_toggle_linewise)',
      '<plug>(comment_toggle_linewise_visual)',
    },
  },
  {
    'MagicDuck/grug-far.nvim',
    opts = {},
    cmd = { 'GrugFar' },
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
    opts = {},
    config = function(_, opts)
      require('refactoring').setup(opts)
      require('telescope').load_extension 'refactoring'
    end,
  },
  {
    'gbprod/yanky.nvim',
    opts = {
      preserve_cursor_position = {
        enabled = true,
      },
      ring = {
        storage = 'sqlite',
      },
      highlight = {
        timer = 200,
      },
      system_clipboard = {
        sync_with_ring = false,
      },
      dependencies = { 'kkharji/sqlite.lua' },
    },
    event = 'BufReadPost',
  },
  -- search and replace
  {
    'cshuaimin/ssr.nvim',
    opts = {
      close = 'q',
      next_match = 'n',
      prev_match = 'N',
      replace_confirm = '<cr>',
      replace_all = '<leader><cr>',
    },
  },
  {
    'chrisgrieser/nvim-alt-substitute',
    opts = true,
    -- lazy-loading with `cmd =` does not work well with incremental preview
    event = 'CmdlineEnter',
    enabled = false,
  },
  {
    'nvim-pack/nvim-spectre',
    opts = {
      mapping = {
        ['run_replace'] = {
          map = ',R',
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = 'replace all',
        },
      },
      name = 'spectre',
    },
    enabled = false,
  },
  {
    'AckslD/muren.nvim',
    config = {},
    cmd = {
      'MurenToggle',
      'MurenOpen',
      'MurenClose',
      'MurenFresh',
      'MurenUnique',
    },
    enabled = false,
  },
}
