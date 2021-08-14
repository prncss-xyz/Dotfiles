local install_path = vim.fn.stdpath 'data'
  .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system {
    'git',
    'clone',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  vim.api.nvim_command 'packadd packer.nvim'
end

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  -- use_rocks 'iconv'
  use 'tami5/sql.nvim'
  use {
    'nvim-lua/plenary.nvim',
  }
  use {
    'nvim-lua/popup.nvim',
  }
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
  use 'kyazdani42/nvim-web-devicons'

  -- tree sitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require 'plugins.treesitter'
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
      -- "beloglazov/vim-textobj-punctuation", -- au/iu for punctuation
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
          require('treesitter-context.config').setup {}
          table.insert(_G.pre_save_cmds, 'NvimTreeClose')
        end,
      },
      'haringsrob/nvim_context_vt',
    },
  }

  -- extra syntax
  use 'blankname/vim-fish'
  use 'potatoesmaster/i3-vim-syntax'
  use 'fladson/vim-kitty'
  use {
    -- weirdly seems required to format yaml frontmatter
    'godlygeek/tabular',
    requires = {
      'plasticboy/vim-markdown',
      ft = 'markdown',
      -- unsuccessful setting options here
    },
  }

  -- Natural languages
  use {
    'vigoux/LanguageTool.nvim',
    cmd = { 'LanguageToolSetup', 'LanguageToolCheck' },
  }

  -- lua dev
  use 'nanotee/luv-vimdocs'
  use 'milisims/nvim-luaref'
  use 'glepnir/prodoc.nvim'

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require('plugins.lsp').setup()
    end,
    -- needs to load early for trouble can integrate with telescope
    requires = {
      {
        'jose-elias-alvarez/null-ls.nvim',
      },
      {
        'jose-elias-alvarez/nvim-lsp-ts-utils',
      },
      {
        'folke/lua-dev.nvim',
      },
      {
        'RRethy/vim-illuminate',
      },
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
        'simrat39/symbols-outline.nvim',
      },
    },
  }

  -- completion
  use {
    'hrsh7th/nvim-compe',
    config = function()
      require 'plugins.compe'
    end,

    requires = {
      {
        'L3MON4D3/LuaSnip',
        config = function()
          require 'plugins.luasnip'
        end,
      },
      {
        'rafamadriz/friendly-snippets',
      },
      {
        -- insert or delete brackets, parens, quotes in pair
        'windwp/nvim-autopairs',
        config = function()
          require 'plugins.autopairs'
        end,
      },
    },
  }

  -- UI
  use { 'vim-scripts/conomode.vim', disable = true }
  use {
    'gelguy/wilder.nvim',
    -- disable = true,
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      local highlitght_list = { 'CursorLine', 'Function' }
      require('indent_blankline').setup {
        show_current_context = false,
        char = ' ',
        buftype_exclude = { 'terminal', 'help' },
        filetype_exclude = { 'markdown', 'help' },
        char_highlight_list = highlitght_list,
        space_char_highlight_list = highlitght_list,
        space_char_blankline_highlight_list = highlitght_list,
      }
    end,
  }
  use {
    'glepnir/galaxyline.nvim',
    config = function()
      require 'plugins.galaxyline'
    end,
  }
  use {
    'folke/trouble.nvim',
    module = 'trouble.providers.telescope',
    config = function()
      require('trouble').setup {
        use_lsp_diagnostic_signs = true,
      }
    end,
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('plugins.gitsigns').setup()
    end,
  }
  use 'kevinhwang91/nvim-hlslens'
  use {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {}
    end,
  }
  use {
    'nvim-telescope/telescope.nvim',
    event = 'CursorHold',
    module_pattern = 'telescope.*',
    config = function()
      require('plugins.telescope').setup()
    end,
    requires = {
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'crispgm/telescope-heading.nvim',
      '~/Media/Projects/telescope-bookmarks.nvim',
      -- not compatible with pnpm
      -- 'nvim-telescope/telescope-node-modules.nvim',
      -- 'nvim-telescope/telescope-dap.nvim',
    },
  }
  use {
    'romgrk/barbar.nvim',
    setup = function()
      require('utils').deep_merge(vim, {
        g = {
          bufferline = {
            auto_hide = true,
            icon_separator_active = '',
            icon_separator_inactive = '',
            icon_close_tab = '',
            icon_close_tab_modified = '',
          },
        },
      })
      table.insert(_G.post_restore_cmds, 'BufferOrderByDirectory')
    end,
  }
  use {
    after = 'telescope.nvim',
    '~/Media/Projects/nononotes-nvim',
    config = function()
      require('plugins.nononotes').setup()
    end,
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      table.insert(_G.pre_save_cmds, 'BufferOrderByDirectory')
    end,
  }
  use {
    'numToStr/Navigator.nvim',
    config = function()
      require('Navigator').setup {}
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
    'folke/zen-mode.nvim',
    config = function()
      require('setup/zen-mode').setup()
    end,
    cmd = { 'ZenMode' },
  }
  use {
    'folke/twilight.nvim',
    config = function()
      require('twilight').setup {}
    end,
    cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
  }
  use {
    'metakirby5/codi.vim',
    cmd = { 'Codi', 'Codi!', 'Codi!!' },
  }

  use 'wellle/visual-split.vim'

  -- UI-side
  use {
    'mbbill/undotree', -- FIXME
    command = { 'UndotreeToggle' },
  }

  -- bindings
  use 'kana/vim-submode'
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {
        plugins = {
          presets = {
            z = false,
            g = false,
          },
        },
      }
      require('bindings').setup()
    end,
  }

  -- navigation
  use { 'kshenoy/vim-signature' }
  use 'haya14busa/vim-asterisk'
  use 'andymass/vim-matchup'
  use 'hrsh7th/vim-eft'
  use {
    'ggandor/lightspeed.nvim',
    config = function()
      require('lightspeed').setup {}
    end,
  }
  use {
    -- "/Volumes/Data SSD/repos/nvim/tabout.nvim",
    'abecodes/tabout.nvim',
    config = function()
      require('tabout').setup {
        tabkey = '',
        backwards_tabkey = '',
      }
    end,
  }

  -- edition
  use {
    'kevinhwang91/nvim-hclipboard',
    config = function()
      require 'plugins.hclipboard'
    end,
  }
  use {
    'AckslD/nvim-anywise-reg.lua',
    config = function()
      require 'plugins.anywise_reg'
    end,
  }
  use 'matze/vim-move'
  use {
    'monaqa/dial.nvim',
    config = function()
      require 'plugins.dial'
    end,
  }
  use 'tommcdo/vim-exchange'
  use 'machakann/vim-sandwich'
  use {
    'svermeulen/vim-macrobatics',
    setup = function()
      require('utils').deep_merge(vim.g, {
        Mac_NamedMacrosDirectory = '~/Media/Projects/macrobatics',
      })
    end,
    requires = 'tpope/vim-repeat',
  }
  -- use 'mattn/emmet-vim'
  use {
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language('default', {
        prefer_single_line_comments = true,
      })
      require('kommentary.config').configure_language('fish', {
        single_line_comment_string = '#',
      })
    end,
  }
  use {
    'AckslD/nvim-revJ.lua',
    config = function()
      require('revj').setup {
        keymaps = {
          operator = 'mj', -- for operator (+motion)
          line = 'mmj', -- for formatting current line
          visual = 'mj', -- for formatting visual selection
        },
      }
    end,
  }
  use {
    'kana/vim-textobj-user',
    requires = {
      -- iv, av
      'Julian/vim-textobj-variable-segment',
      -- ad, id
      'kana/vim-textobj-datetime',
      -- remap vim, abbvr: numbers etc.
      -- as, is (configuratble)
      'preservim/vim-textobj-sentence',
      -- al il
      'kana/vim-textobj-line',
      -- ae, ie
      'kana/vim-textobj-entire',
      -- indent level
      -- same) ai ii same or deaper) aI iI
      'michaeljsmith/vim-indent-object',
      -- a,, i,
      -- let g:vim_textobj_parameter_mapping = ','
      'sgur/vim-textobj-parameter',
    },
  }
  use 'wellle/targets.vim'
  use 'tommcdo/vim-ninja-feet'

  -- session
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
  use {
    'folke/persistence.nvim',
    config = function()
      require('persistence').setup()
    end,
  }
  use {
    'rmagatti/auto-session',
    config = function()
      require 'plugins.auto-session'
    end,
    requires = {
      'rmagatti/session-lens',
      module = 'session-lens',
    },
  }

  -- themes
  use 'rafamadriz/neon'
  -- classics
  use 'ishan9299/nvim-solarized-lua'
  use 'sainnhe/gruvbox-material'

  -- various
  use {
    'jghauser/mkdir.nvim',
    config = function()
      require 'mkdir'
    end,
  }
  use 'tpope/vim-eunuch'
  use {
    'henriquehbr/nvim-startup.lua',
    config = function()
      require('nvim-startup').setup {}
    end,
  }
end)
