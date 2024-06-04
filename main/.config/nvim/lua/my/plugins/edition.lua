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
    -- :S
    'chrisgrieser/nvim-alt-substitute',
    opts = true,
    -- lazy-loading with `cmd =` does not work well with incremental preview
    event = 'CmdlineEnter',
    enabled = false,
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
  {
    'AckslD/nvim-FeMaco.lua',
    cmd = 'FeMaco',
    name = 'femaco',
    opts = {},
    enabled = false,
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
    'jackMort/ChatGPT.nvim',
    opts = {
      api_key_cmd = 'pass show openai.com/keys/princesse@princesse.xyz',
      openai_params = {},
      predefined_chat_gpt_prompts = 'https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv',
      actions_paths = { vim.env.HOME .. '/Personal/chatGPT.nvim/actions.json' },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = {
      'ChatGPT',
      'ChatGPTActAs',
      'ChatGPTCompleteCode',
      'ChatGPTEditWithInstructions',
      'ChatGPTRun',
    },
    enabled = false,
  },
  {
    'gsuuon/model.nvim',
    init = function()
      vim.filetype.add {
        extension = {
          mchat = 'mchat',
        },
      }
    end,
    config = function()
      local util = require 'model.util'
      local function pass(path)
        return function()
          local str = vim.fn.system { 'pass', 'show', path }
          str = str:gsub('\n', '')
          return str
        end
      end
      require('model').setup {
        secrets = {
          ANTHROPIC_API_KEY = pass 'anthropic.com/juliette.lamarche.xyz@gmail.com/keys/nvim',
          GOOGLE_API_KEY = pass 'google.com/juliette.lamarche.xyz@gmail.com/keys/nvim',
          PALM_API_KEY = pass 'google.com/juliette.lamarche.xyz@gmail.com/keys/nvim',
          GROQ_API_KEY = pass 'groq.com/juliette.lamarche.xyz@gmail.com/keys/nvim',
          OPENAI_API_KEY = pass 'openai.com/juliette.lamarche.xyz@gmail.com/keys/nvim',
          HUGGINGFACE_API_KEY = pass 'huggingface.co/juliette.lamarche.xyz@gmail.com/nvim',
        },
        prompts = util.module.autoload 'my.prompt_library',
        chats = util.module.autoload 'my.chat_library',
      }
    end,
    keys = {
      { '<c-m>x', ':Mdelete<cr>', mode = 'n' },
      { '<c-m>v', ':Mselect<cr>', mode = 'n' },
      { '<c-m><space>', ':Mchat<cr>', mode = 'n' },
      { '<c-cr>', '<cmd>Mchat<cr>', mode = 'i' },
      { ':', ':', mode = 'n' },
    },
    ft = 'mchat',
    cmd = {
      'M',
      'Model',
      'Mchat',
      'Mdelete',
      'MCancel','MShow','MCadd', 'MCremove', 'MCclear','MCPaste',

    },
    enabled = true,
  },
  {
    'robitx/gp.nvim',
    opts = {
      openai_api_key = {
        'pass',
        'show',
        'openai.com/keys/juliette.lamarche.xyz@gmail.com',
      },
    },
    cmd = {
      'GpChatNew',
      'GpChatPaste',
      'GpChatToggle',
      'GpChatFinder',
      'GpChatRespond',
      'GpChatDelete',
      'GpRewrite',
      'GpAppend',
      'GpPrepend',
      'GpEnew',
      'GpNew',
      'GpVnew',
      'GpTabnew',
      'GpPopup',
      'GpImplement',
      'GpContext',
      'GpNextAgent',
      'GpAgent',
      'GpStop',
      'GpInspectPlugin',
      --TODO: GpWisper, GpImage
    },
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
      'stevearc/dressing.nvim',
      'folke/edgy.nvim',
    },
    config = function()
      require('codecompanion').setup {
        adapters = {
          anthropic = require('codecompanion.adapters').use('anthropic', {
            env = {
              api_key = 'cmd:pass show anthropic/juliette.lamarche.xyz@gmail.com',
            },
          }),
        },
        strategies = {
          chat = 'anthropic',
          inline = 'anthropic',
          tool = 'anthropic',
        },
        log_level = 'TRACE',
      }
      -- Expand `cc` into CodeCompanion in the command line
      vim.cmd [[cab cc CodeCompanion]]
    end,
    cmd = {
      'CodeCompanion',
      'CodeCompanionChat',
      'CodeCompanionAdd',
      'CodeCompanionToggle',
      'CodeCompanionActions',
    },
    enabled = false,
  },
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
}
