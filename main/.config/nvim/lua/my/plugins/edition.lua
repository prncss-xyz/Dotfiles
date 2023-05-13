return {
  {
    dir = require('my.utils').local_repo 'flies.nvim',
    config = require('my.config.flies').config,
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
    opts = {
      mappings = {
        basic = false,
        extra = false,
      },
    },
    config = function(_, opts)
      local ft = require 'Comment.ft'
      ft.set('sway', '#%s')
      opts.pre_hook = require(
        'ts_context_commentstring.integrations.comment_nvim'
      ).create_pre_hook()
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
    config = require('my.config.nvim-spectre').config,
    name = 'spectre',
    module = 'spectre',
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

  -- completion
  {
    'L3MON4D3/LuaSnip',
    config = require('my.config.luasnip').config,
    cmd = 'LuaSnipUnlinkCurrent',
  },
  {
    'hrsh7th/nvim-cmp',
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
    commit = '1cad30fcffa282c0a9199c524c821eadc24bf939',
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
  {
    'codota/tabnine-nvim',
    build = './dl_binaries.sh',
    opts = {
      disable_auto_comment = false,
      -- accept_keymap = '<plug>(nop)',
      accept_keymap = '<c-y>',
      dismiss_keymap = '<c-e>',
      debounce_ms = 800,
      suggestion_color = { gui = '#808080', cterm = 244 },
      exclude_filetypes = { 'TelescopePrompt' },
    },
    name = 'tabnine',
    config = true,
    cmd = {
      'TabnineHub',
      'TabnineHubUrl',
      'TabnineStatus',
      'TabnineDisable',
      'TabnineEnable',
      'TabnineToggle',
    },
    event = 'InsertEnter',
    enabled = true,
  },
}
