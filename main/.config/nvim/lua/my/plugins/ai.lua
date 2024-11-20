return {
  {
    'yetone/avante.nvim',
    version = false,
    opts = {
      provider = 'gemini',
      gemini = {
        api_key_name = 'cmd:pass show google.com/juliette.lamarche.xyz@gmail.com/keys/nvim',
      },
      claude = {
        api_key_name = 'cmd:pass show anthropic.com/juliette.lamarche.xyz@gmail.com/keys/nvim',
      },
      openai = {
        api_key_name = 'cmd:pass show openai.com/juliette.lamarche.xyz@gmail.com/keys/nvim',
      }
    },
    build = 'make',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = {
      'AvanteAsk',
      'AvanteChat',
      'AvanteToggle',
      'AvanteEdit',
      'AvanteRefresh',
      'AvanteBuild',
      'AvanteSwitchProvider',
      'AvanteClear',
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
      'MCancel',
      'MShow',
      'MCadd',
      'MCremove',
      'MCclear',
      'MCPaste',
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
    enabled = false,
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
}
