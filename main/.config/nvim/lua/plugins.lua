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
  -- Utils
  use 'tami5/sql.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require 'setup.treesitter'
    end,
    requires = {
      'p00f/nvim-ts-rainbow',
      {
        'nvim-treesitter/playground',
        cmd = { 'TSPlaygroundToggle' },
      },
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-textsubjects',
      'mfussenegger/nvim-ts-hint-textobject',
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
      --
      {
        'romgrk/nvim-treesitter-context',
        config = function()
          require('treesitter-context.config').setup {
            enable = true,
          }
        end,
      },
      'haringsrob/nvim_context_vt',
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
    -- after = 'trouble',
    config = function()
      require('setup/telescope').setup()
    end,
    requires = {
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'crispgm/telescope-heading.nvim',
      'sudormrfbin/cheatsheet.nvim',
      -- 'nvim-telescope/telescope-dap.nvim',
      {
        after = 'telescope.nvim',
        'rmagatti/session-lens',
        config = function()
          require('session-lens').setup {
            shorten_path = false,
          }
        end,
      },
      {
        after = 'telescope.nvim',
        '~/Media/Projects/nononotes-nvim',
        config = function()
          require('setup/nononotes').setup()
        end,
      },
    },
  }
  use 'kyazdani42/nvim-web-devicons'

  -- Installers
  -- use 'Pocco81/DAPInstall.nvim'

  -- Projects

  use {
    'windwp/nvim-projectconfig',
    config = function()
      require('nvim-projectconfig').load_project_config {
        project_dir = '~/Media/Projects/projects-config/',
      }
    end,
  }
  use {
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup {
        lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
        lastplace_open_folds = true,
      }
    end,
  }
  -- UI
  use 'kevinhwang91/nvim-hlslens'

  -- Lua dev
  use 'nanotee/luv-vimdocs'
  use 'folke/lua-dev.nvim'
  use 'milisims/nvim-luaref'
  use 'glepnir/prodoc.nvim'

  -- Navigation
  use 'haya14busa/vim-asterisk'
  use 'andymass/vim-matchup'
  use 'hrsh7th/vim-eft'
  use {
    'ggandor/lightspeed.nvim',
    config = function()
      require('lightspeed').setup {}
    end,
  }

  -- Edition
  use {
    'monaqa/dial.nvim',
    config = function()
      local dial = require 'dial'
      dial.augends['custom#boolean'] = dial.common.enum_cyclic {
        name = 'boolean',
        strlist = { 'true', 'false' },
      }
      dial.config.searchlist.normal = {
        'number#decimal',
        'number#hex',
        'number#binary',
        'date#[%Y-%m-%d]',
        'markup#markdown#header',
        'custom#boolean',
      }
    end,
  }
  use {
    'jghauser/mkdir.nvim',
    config = function()
      require 'mkdir'
    end,
  }

  use {
    'kana/vim-textobj-user',
    requires = {
      -- ,w etc
      '~/Media/Projects/vim-textobj-variable-segment',
      -- same syntactic group
      -- ay, iy
      'kana/vim-textobj-syntax',
      -- remap vim, abbvr: numbers etc.
      'preservim/vim-textobj-sentence',

      -- last pasted text
      -- gb
      'saaguero/vim-textobj-pastedtext',
      -- last searched pattern
      -- a/ i/ a? i?
      'kana/vim-textobj-lastpat',
      -- current line
      -- al il
      'kana/vim-textobj-line',
      -- TODO: smart quote navigation: ". ."
      -- markdown
      -- headers: 1) ]] [[ 2) ][ [] 3) ]} [{ x) ]h [h
      --
      'coachshea/vim-textobj-markdown',
      -- indent level
      -- same) ai ii same or deaper) aI iI
      -- text blocs
      -- current or next) ]m [m
      -- current or previous) ]n [n
      'michaeljsmith/vim-indent-object',
    },
  }
  use {
    'AckslD/nvim-anywise-reg.lua',
    config = function()
      require 'setup/anywise_reg'
    end,
  }

  use {
    -- weirdly seams required to format yaml frontmatter
    'godlygeek/tabular',
    requires = {
      'plasticboy/vim-markdown',
      ft = 'markdown',
      -- unsuccessful setting options here
    },
  }

  -- use {
  --   'preservim/vim-pencil',
  --   local deep_merge = require('utils').deep_merge
  --   config = function()
  --     vim.cmd [[
  --       let g:pencil#conceallevel = 3     " 0=disable, 1=one char, 2=hide char, 3=hide all (def)
  --       let g:pencil#concealcursor = 'c'  " n=normal, v=visual, i=insert, c=command (def)
  --     ]]
  --     deep_merge(vim, {
  --       -- g = {
  --       --   ['pencil#conceallevel'] = 3, -- 0=disable, 1=one char, 2=hide char, 3=hide all (def)
  --       --   ['pencil#concealcursor'] = 'c', -- n=normal, v=visual, i=insert, c=command (def)
  --       -- },
  --     })
  --   end,
  -- }
  -- use 'matze/vim-move'
  use {
    'kevinhwang91/nvim-hclipboard',
    config = function()
      require 'setup.hclipboard'
    end,
  }
  -- use 'svermeulen/vim-cutlass'
  use 'tommcdo/vim-exchange'
  use 'machakann/vim-sandwich'
  use 'mattn/emmet-vim'
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
    config = function()
      require('setup/lsp').setup()
    end,
    -- needs to load early for trouble can integrate with telescope
    -- event = 'BufReadPre'
    requires = {
      -- {
      --   'kabouzeid/nvim-lspinstall',
      --   -- after = 'nvim-lspconfig',
      --   config = function()
      --     require('lspinstall').setup()
      --     require('setup/lsp').setup()
      --   end,
      -- },
      --
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
      },
      {
        'folke/trouble.nvim',
        after = 'nvim-lspconfig',
        config = function()
          require('trouble').setup {
            use_lsp_diagnostic_signs = true,
          }
        end,
        -- cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh' },
      },
      -- { -- not working
      --   'stevearc/aerial.nvim',
      --   config = function()
      --     vim.g.aerial = {
      --       default_direction = 'prefer_left',
      --     }
      --   end,
      -- },
      {
        'simrat39/symbols-outline.nvim',
        config = function()
          vim.g.symbols_outline = {
            auto_preview = false,
            position = 'left',
            -- lsp_blacklist = { 'efm' },
          }
        end,
      },
    },
  }
  use {
    'numToStr/Navigator.nvim',
    config = function ()
      require'Navigator'.setup{}
    end
  }

  -- use "jose-elias-alvarez/nvim-lsp-ts-utils"
  -- use {
  --   'mfussenegger/nvim-dap',
  --   config = function()
  --     require('setup/dap').setup()
  --   end,
  --   requires = {
  --     {
  --       'theHamsta/nvim-dap-virtual-text',
  --       after = 'nvim-dap',
  --     },
  --     {
  --       'rcarriga/nvim-dap-ui',
  --       after = 'nvim-dap',
  --       config = function()
  --         require('dapui').setup {}
  --       end,
  --     },
  --   },
  -- }
  -- use 'jbyuki/one-small-step-for-vimkind'
  -- use 'vim-test/vim-test'
  -- use {
  --   'rcarriga/vim-ultest',
  --   requires = { 'vim-test/vim-test' },
  --   run = ':UpdateRemotePlugins',
  -- }

  -- Language syntax
  use 'potatoesmaster/i3-vim-syntax'
  -- use {
  --   'rafcamlet/nvim-luapad',
  --   cmd = {
  --     'Luapad',
  --     'LuaRun',
  --     'Lua',
  --   },
  -- }

  -- UI
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
  use {
    'hrsh7th/nvim-compe',
    event = 'BufRead',
    wants = { 'LuaSnip', 'nvim-autopairs' },
    config = function()
      require 'setup/compe'
    end,

    requires = {
      {
        'L3MON4D3/LuaSnip',
        wants = 'friendly-snippets',
        after = 'nvim-compe',
        config = function()
          require 'setup/luasnip'
        end,
      },
      {
        'rafamadriz/friendly-snippets',
      },
      {
        -- insert or delete brackets, parens, quotes in pair
        'windwp/nvim-autopairs',
        config = function()
          require 'setup/autopairs'
        end,
      },
    },
  }
  use { 'tzachar/compe-tabnine', run = './install.sh' }
  use 'vim-voom/VOoM'
  use {
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    cmd = 'Voomquit',
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

  -- navigation
  use {
    -- "/Volumes/Data SSD/repos/nvim/tabout.nvim",
    'abecodes/tabout.nvim',
    wants = { 'nvim-treesitter' },
    after = { 'nvim-compe' },
    config = function()
      require('tabout').setup {
        tabkey = '',
        backwards_tabkey = '',
      }
    end,
  }
  --
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
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {
        plugins = {
          -- FIXME: working only after delai
          spelling = {
            enabled = true,
            suggestions = 20,
          },
        },
      }
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
  -- use {
  --   'edluffy/specs.nvim', -- not working
  -- }
  use {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {}
    end,
  }

  use '~/Media/Projects/closet'

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

  -- FIXME
  -- use {
  --   "folke/persistence.nvim",
  --   event = "BufReadPre",
  --   config = function()
  --     require("persistence").setup()
  --   end,
  -- }
  use {
    'rmagatti/auto-session',
    config = function()
      require('setup/auto-session').setup()
    end,
  }
  use 'henriquehbr/nvim-startup.lua'
end)
