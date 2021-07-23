-- bootstraping packer
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute(
    '!git clone https://github.com/wbthomason/packer.nvim ' .. install_path
  )
  execute 'packadd packer.nvim'
end

vim.cmd 'packadd packer.nvim'
return require('packer').startup(function()
  use { 'wbthomason/packer.nvim', opt = true }
  -- use 'kabouzeid/nvim-lspinstall'
  -- Utils
  use 'tami5/sql.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('setup/treesitter').setup()
    end,
    requires = {
      'p00f/nvim-ts-rainbow',
      {
        'nvim-treesitter/playground',
        cmd = { 'Tsplaygroundtoggle' },
      },
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-textsubjects',
      -- Use 'tressitter 'to autoclose and autorename html tag
      'windwp/nvim-ts-autotag',
      -- Language support
      {
        'lewis6991/spellsitter.nvim',
        config = function()
          require('spellsitter').setup()
        end,
      },
      -- shows the context of the currently visible buffer contents
      {
        'romgrk/nvim-treesitter-context',
        config = function()
          require('treesitter-context.config').setup {
            enable = true,
          }
        end,
      },
    },
  }

  -- TUI
  use {
    'nvim-lua/plenary.nvim',
  }
  use {
    'nvim-lua/popup.nvim',
  }
  -- pictograms
  use {
    'onsails/lspkind-nvim',
    config = function()
      require('lspkind').init {
        symbol_map = {
          Snippet = '',
          Field = '識',
        },
      }
    end,
  }
  use {
    'nvim-telescope/telescope.nvim',
    event = 'CursorHold',
    config = function()
      require('setup/telescope').setup()
    end,
    requires = {
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'crispgm/telescope-heading.nvim',
      'sudormrfbin/cheatsheet.nvim',
      'nvim-telescope/telescope-dap.nvim',
    },
  }
  use 'kyazdani42/nvim-web-devicons'

  -- Installers
  use 'Pocco81/DAPInstall.nvim'

  -- Projects
  use 'ethanholz/nvim-lastplace'
  use {
    'windwp/nvim-projectconfig',
    config = function()
      require('nvim-projectconfig').load_project_config {
        project_dir = '~/Media/Projects/projects-config/',
      }
    end,
  }
  use {
    'rmagatti/auto-session',
    config = function()
      require('setup/auto-session').setup()
    end,
    requires = {
      'rmagatti/session-lens',
      config = function()
        require('session-lens').setup {
          shorten_path = false,
        }
      end,
    },
  }

  -- Lua dev
  use 'nanotee/luv-vimdocs'
  use 'folke/lua-dev.nvim'
  use 'milisims/nvim-luaref'
  use 'glepnir/prodoc.nvim'

  -- Navigation
  use 'kevinhwang91/nvim-hlslens'
  use 'haya14busa/vim-asterisk'
  use 'andymass/vim-matchup'
  use 'bkad/CamelCaseMotion'
  use 'hrsh7th/vim-eft'
  use {
    'ggandor/lightspeed.nvim',
    config = function()
      require('lightspeed').setup {}
    end,
  }
  use 'mfussenegger/nvim-ts-hint-textobject'

  -- Edition
  use 'kana/vim-textobj-user'
  use 'matze/vim-move'
  use 'svermeulen/vim-cutlass'
  use 'tommcdo/vim-exchange'
  use 'machakann/vim-sandwich'
  use 'mattn/emmet-vim'
  -- segment in camelCase etc words; changed bindings
  use '~/Media/Projects/vim-textobj-variable-segment'
  use {
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language('default', {
        prefer_single_line_comments = true,
      })
    end,
  }
  use {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = function()
      require('setup/lsp').setup()
    end,
    requires = {
      {
        'kosayoda/nvim-lightbulb',
        config = function()
          require('utils').augroup('NvimLightbulb', {
            {
              events = { 'CursorHold', 'CursorHoldI' },
              targets = { '*' },
              command = function()
                require('nvim-lightbulb').update_lightbulb()
              end,
            },
          })
        end,
        use {
          'folke/trouble.nvim',
          after = 'nvim-lspconfig',
          config = function()
            require('trouble').setup {}
          end,
          cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh' },
        },
      },
    },
  }

  -- use "jose-elias-alvarez/nvim-lsp-ts-utils"
  use {
    'mfussenegger/nvim-dap',
    config = function()
      require('setup/dap').setup()
    end,
    requires = {
      {
        'theHamsta/nvim-dap-virtual-text',
        after = 'nvim-dap',
      },
      {
        'rcarriga/nvim-dap-ui',
        after = 'nvim-dap',
        config = function()
          require('dapui').setup {}
        end,
      },
    },
  }
  use 'jbyuki/one-small-step-for-vimkind'
  use 'vim-test/vim-test'
  use {
    'rcarriga/vim-ultest',
    requires = { 'vim-test/vim-test' },
    run = ':UpdateRemotePlugins',
  }

  -- Language syntax
  use 'potatoesmaster/i3-vim-syntax'

  use {
    'rafcamlet/nvim-luapad',
    cmd = {
      'Luapad',
      'LuaRun',
      'Lua',
    },
  }

  -- UI
  use 'haringsrob/nvim_context_vt'
  use {
    'mbbill/undotree', -- FIXME
    command = { 'UndotreeToggle' },
  }
  use {
    'folke/zen-mode.nvim',
    config = function()
      require('setup/zen-mode').setup()
    end,
    cmd = { 'ZenMode' },
  }
  use 'wellle/visual-split.vim'
  use { 'kevinhwang91/nvim-bqf' }
  use {
    'hrsh7th/nvim-compe',
    event = 'InsertEnter',
    wants = { 'LuaSnip', 'nvim-autopairs' },
    config = function()
      require 'setup/compe'
    end,
    requires = {
      {
        'L3MON4D3/LuaSnip',
        wants = 'friendly-snippets',
        event = 'InsertCharPre',
        config = function()
          require 'setup/luasnip'
        end,
      },
      {
        'rafamadriz/friendly-snippets',
        event = 'InsertCharPre',
      },
      {
        -- insert or delete brackets, parens, quotes in pair
        'windwp/nvim-autopairs',
        event = 'InsertCharPre',
        config = function()
          require('nvim-autopairs').setup {}
        end,
      },
    },
  }
  use {
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    config = function()
      require('setup/gitsigns').setup()
    end,
  }
  use {
    'sindrets/diffview.nvim',
    config = function()
      require('diffview').setup()
    end,
    -- this does not seem to have an effect
    cmd = {
      'DiffviewOpen',
      'DiffViewToggleFiles',
      'DiffViewFocusFiles',
      'DiffViewRefresh',
    },
  }
  use {
    'glepnir/galaxyline.nvim',
    config = function()
      require 'setup/galaxyline'
    end,
  }
  use 'brettanomyces/nvim-terminus'
  use 'romgrk/barbar.nvim'
  -- use 'akinsho/nvim-bufferline.lua'
  use 'lukas-reineke/indent-blankline.nvim'
  use {
    'liuchengxu/vista.vim',
  }
  use 'simrat39/symbols-outline.nvim'
  use {
    'folke/twilight.nvim',
    config = function()
      require('twilight').setup {}
    end,
    cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
  }
  use {
    'metakirby5/codi.vim',
    -- cmd = { 'Codi', 'Codi!', 'Codi!!' },
  }

  -- Integration
  use 'tpope/vim-eunuch'

  -- Natural languages
  use {
    'vigoux/LanguageTool.nvim',
    cmd = { 'LanguageToolSetup', 'LanguageToolCheck' },
  }
  -- Learning
  -- use {"tzachar/compe-tabnine", run = "sh install.sh"} -- is that ok? crashes
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end,
  }
  use {
    'RishabhRD/nvim-cheat.sh',
    requires = 'RishabhRD/popfix',
    cmd = {
      'Cheat',
      'CheatWithoutComments',
      'CheatList',
      'CheatListWithoutComments',
    },
  }

  -- FX
  use {
    'edluffy/specs.nvim', -- not working
  }
  use {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {}
    end,
  }

  -- Notes
  use '~/Media/Projects/closet'
  use {
    '~/Media/Projects/nononotes-nvim',
    config = function()
      require('setup/nononotes').setup()
    end,
  }
  -- use '~/Media/Projects/snippets'

  -- Color schemes
  use 'rafamadriz/neon'
  -- classics
  use 'ishan9299/nvim-solarized-lua'
  use 'sainnhe/gruvbox-material'
  use 'shaunsingh/nord.nvim'
  use 'NTBBloodbath/doom-one.nvim'
  use 'sainnhe/edge'
  use 'sainnhe/everforest'
  use 'sainnhe/sonokai'
  use 'folke/tokyonight.nvim'
  use 'marko-cerovac/material.nvim'
  --
  -- old but cute --
  -- monochromish
  use 'fcpg/vim-orbital'
  use 'wadackel/vim-dogrun'
  -- poly
  use 'whatyouhide/vim-gotham'
  -- more poly
  use 'pineapplegiant/spaceduck'
  use 'glepnir/oceanic-material'
end)
