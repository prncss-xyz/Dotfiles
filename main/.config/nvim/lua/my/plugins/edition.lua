return {
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
    -- :S
    'chrisgrieser/nvim-alt-substitute',
    opts = true,
    -- lazy-loading with `cmd =` does not work well with incremental preview
    event = 'CmdlineEnter',
  },
  {
    'IndianBoy42/fuzzy_slash.nvim',
    dependencies = {
      {
        'IndianBoy42/fuzzy.nvim',
        dependencies = {
          { 'nvim-telescope/telescope-fzf-native.nvim' },
        },
      },
    },
    opts = {
      word_pattern = '[^%s%!%"%#%$%%%&%\'%(%)%*%+%,%-%.%/%:%;%<%=%>%?%@%[%\\%]%^%`%{%|%}%~]+',
      register_nN_repeat = function(nN)
        require('my.utils.fuzzy_slash').register_nN_repeat(nN)
      end,
    },
    cmd = { 'Fz', 'FzNext', 'FzPrev', 'FzPattern', 'FzClear' },
    event = 'CmdlineEnter',
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
  },
  {
    'AckslD/nvim-FeMaco.lua',
    cmd = 'FeMaco',
    name = 'femaco',
    opts = {},
    enabled = false,
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
  -- navigation
  {
    'chentoast/marks.nvim',
    event = 'BufReadPost',
    opts = {
      default_mappings = false,
      refresh_interval = 0,
    },
    config = function(_, opts)
      require('marks').setup(opts)
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
    opts = {
      jump_on_sole_occurrence = true,
      keys = 'asdfjkl;ghqweruiopzxcvm,étybn',
      -- . does not work
    },
  },
  {
    'jackMort/ChatGPT.nvim',
    opts = {
      openai_params = {},
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = {
      'ChatGPT',
      'ChatGPTActAs',
      'ChatGPTEditWithInstructions',
      'ChatGPTRun',
      'ChatGPTRunCustomCodeAction',
    },
  },
}
