-- bootstraping packer
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
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
      require 'setup/treesitter'
    end,
  }

  -- TUI
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  -- pictograms
  use {
    'onsails/lspkind-nvim',
    config = function()
      require('lspkind').init {
        symbol_map = {
          Snippet = '',
        },
      }
    end,
  }
  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      require 'setup/telescope'
    end,
  }
  -- for lsp completion items
  use 'kyazdani42/nvim-web-devicons'

  -- Installers
  use 'Pocco81/DAPInstall.nvim'

  -- Projects
  use 'ethanholz/nvim-lastplace'
  use 'windwp/nvim-projectconfig'
  use 'rmagatti/auto-session'
  use {
    'rmagatti/session-lens',
    requires = {
      'rmagatti/auto-session',
      'nvim-telescope/telescope.nvim',
    },
    -- after = {
    --   'rmagatti/auto-session',
    --   'nvim-telescope/telescope.nvim',
    -- },
  }

  -- Docs
  use 'nanotee/luv-vimdocs' -- luv docs in vimdoc format
  use 'folke/lua-dev.nvim' -- EmmyLua library for the nvim lua API for
  use 'milisims/nvim-luaref'
  use 'glepnir/prodoc.nvim'

  -- Navigation
  use 'kevinhwang91/nvim-hlslens'
  use 'haya14busa/vim-asterisk'
  use 'andymass/vim-matchup' -- highlight, navigate, and operate on sets of matching text. It extends vim's % key to language-specific words instead of just single characters. -- treesitter integration
  use 'bkad/CamelCaseMotion' -- ,w
  use 'ggandor/lightspeed.nvim'

  -- Edition
  use 'matze/vim-move' -- Move current line/selection
  use 'svermeulen/vim-cutlass' -- overrides the delete operations to actually just delete and not affect the current yank
  use 'tommcdo/vim-exchange'
  use 'machakann/vim-sandwich'
  use 'mattn/emmet-vim'
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- requires = { 'nvim-treesitter/nvim-treesitter' },
    -- after = { 'nvim-treesitter/nvim-treesitter' },
  }
  use {
    'RRethy/nvim-treesitter-textsubjects',
    -- requires = { 'nvim-treesitter/nvim-treesitter' },
    -- after = { 'nvim-treesitter/nvim-treesitter' },
  }
  use {
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language('default', {
        prefer_single_line_comments = true,
      })
    end,
  }
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use {
    -- insert or delete brackets, parens, quotes in pair
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end,
  }
  -- Use 'tressitter 'to autoclose and autorename html tag
  use {
    'windwp/nvim-ts-autotag',
    -- requires = { 'nvim-treesitter/nvim-treesitter' },
    -- after = { 'nvim-treesitter/nvim-treesitter' },
  }

  -- Language support
  use {
    'lewis6991/spellsitter.nvim',
    config = function()
      require('spellsitter').setup()
    end,
  }
  use {
    'neovim/nvim-lspconfig',
    config = function() end,
  }

  use 'L3MON4D3/LuaSnip' -- snippet engine
  use 'rafamadriz/friendly-snippets' -- snippet collection

  -- use "jose-elias-alvarez/nvim-lsp-ts-utils"
  use 'romgrk/nvim-treesitter-context' -- shows the context of the currently visible buffer content

  use 'mfussenegger/nvim-dap'
  use {
    'nvim-telescope/telescope-dap.nvim',
    requires = {
      'mfussenegger/nvim-dap',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
    },
  }
  use 'theHamsta/nvim-dap-virtual-text'
  use 'jbyuki/one-small-step-for-vimkind'
  use 'vim-test/vim-test'
  use { 'rcarriga/vim-ultest', requires = { 'vim-test/vim-test' }, run = ':UpdateRemotePlugins' }
  use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }

  -- Language syntax
  use 'potatoesmaster/i3-vim-syntax'

  use {
    'rafcamlet/nvim-luapad',
    command = {
      'Luapad',
      'LuaRun',
      'Lua',
    },
  }
  --[[

  (cbca)

  --]]

  -- UI
  use 'haringsrob/nvim_context_vt'
  use {
    'mbbill/undotree', -- FIXME
    command = { 'UndotreeToggle' },
  }
  use 'Pocco81/TrueZen.nvim'
  use 'folke/zen-mode.nvim'
  use 'wellle/visual-split.vim'
  use { 'kevinhwang91/nvim-bqf' }
  use {
    'hrsh7th/nvim-compe',
    config = function()
      require 'setup/compe'
    end,
  }
  use 'folke/trouble.nvim'
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require 'setup/gitsigns'
    end,
  }
  use 'sindrets/diffview.nvim'
  use {
    'glepnir/galaxyline.nvim',
    config = function()
      require 'setup/galaxyline'
    end,
  }
  use 'kosayoda/nvim-lightbulb'
  use 'brettanomyces/nvim-terminus'
  use 'romgrk/barbar.nvim'
  -- use 'akinsho/nvim-bufferline.lua'
  use 'lukas-reineke/indent-blankline.nvim'
  use {
    'liuchengxu/vista.vim',
  }
  use 'simrat39/symbols-outline.nvim'
  use 'p00f/nvim-ts-rainbow'
  use {
    'junegunn/goyo.vim',
    config = function()
      require 'setup/goyo'
    end,
    command = { 'goyo', 'goyo!', 'goyo!!' },
  }
  use {
    'junegunn/limelight.vim',
    config = function()
      -- default: 0.5
      vim.g.limelight_default_coefficient = 0.5
      -- number of preceding/following paragraphs to include (default: 0)

      -- beginning/end of paragraph
      -- when there's no empty line between the paragraphs
      -- and each paragraph starts with indentation
      vim.g.limelight_bop = [[^\s]]
      vim.g.limelight_eop = [[\ze\n^\s]]
      -- highlighting priority (default: 10)
      -- set it to -1 not to overrule hlsearch
      vim.g.limelight_priority = -1
    end,
    command = { 'goyo', 'goyo!', 'goyo!!', 'zenmode' },
  }
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use {
    'metakirby5/codi.vim',
    command = { 'codi', 'codi!', 'codi!!' },
  }
  use {
    'nvim-treesitter/playground',
    command = { 'tsplaygroundtoggle' },
  }
  use 'nvim-telescope/telescope-symbols.nvim'
  use {
    'crispgm/telescope-heading.nvim',
    requires = {
      { 'nvim-telescope/telescope.nvim' },
    },
  }
  use {
    'sudormrfbin/cheatsheet.nvim',
    requires = {
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
  }

  -- Integration
  use 'tpope/vim-eunuch'

  -- Natural languages
  use {
    'vigoux/LanguageTool.nvim',
    command = { 'LanguageToolSetup', 'LanguageToolCheck' },
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
    command = { 'Cheat', 'CheatWithoutComments', 'CheatList', 'CheatListWithoutComments' },
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
  use '~/Media/Projects/nononotes-nvim'
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
