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
    'cbochs/portal.nvim',
    opts = {
      window_options = {
        relative = 'cursor',
        width = 80,
        height = 3,
        col = 2,
        focusable = false,
        border = 'single',
        noautocmd = true,
      },
      labels = {
        'a',
        's',
        'd',
        'f', --[[ 'j', 'k', 'l', ';'  ]]
      },
    },
    cmd = 'Portal',
  },
  {
    'LeonHeidelbach/trailblazer.nvim',
    opts = {
      auto_save_trailblazer_state_on_exit = true,
      auto_load_trailblazer_state_on_enter = true,
      force_mappings = {},
      force_quickfix_mappings = {},
    },
    config = function(_, opts)
      require('trailblazer').setup(opts)
      vim.api.nvim_create_autocmd('VimLeave', {
        desc = 'save trailblazer session on leave',
        pattern = '*',
        command = 'TrailBlazerSaveSession',
      })
    end,
    event = 'BufReadPost',
    cmd = {
      'TrailBlazerNewTrailMark',
      'TrailBlazerTrackBack',
      'TrailBlazerPeekMovePreviousUp',
      'TrailBlazerPeekMoveNextDown',
      'TrailBlazerMoveToNearest',
      'TrailBlazerMoveToTrailMarkCursor',
      'TrailBlazerDeleteAllTrailMarks',
      'TrailBlazerPasteAtLastTrailMark',
      'TrailBlazerPasteAtAllTrailMarks',
      'TrailBlazerTrailMarkSelectMode',
      'TrailBlazerToggleTrailMarkList',
      'TrailBlazerOpenTrailMarkList',
      'TrailBlazerCloseTrailMarkList',
      'TrailBlazerSwitchTrailMarkStack',
      'TrailBlazerAddTrailMarkStack',
      'TrailBlazerDeleteTrailMarkStacks',
      'TrailBlazerDeleteAllTrailMarkStacks',
      'TrailBlazerSwitchNextTrailMarkStack',
      'TrailBlazerSwitchPreviousTrailMarkStack',
      'TrailBlazerSetTrailMarkStackSortMode',
      'TrailBlazerSaveSession',
      'TrailBlazerLoadSession',
      'TrailBlazerDeleteSession',
    },
  },
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
    enabled = false,
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
    enabled = false,
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
