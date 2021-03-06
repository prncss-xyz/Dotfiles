local install_path = vim.fn.stdpath 'data'
  .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system {
    'git',
    'clone',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  vim.cmd 'packadd packer.nvim'
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
        end,
      },
      -- 'haringsrob/nvim_context_vt',
    },
  }

  -- extra syntax
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
      -- {
      --   'RRethy/vim-illuminate',
      -- },
      {
        'kosayoda/nvim-lightbulb',
        config = function()
          vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
        end,
      },
      {
        'simrat39/symbols-outline.nvim',
        setup = function()
          vim.g.symbols_outline = {
            width = 30,
            show_guides = false,
            auto_preview = false,
            position = 'left',
            symbols = {
              Method = { icon = '_', hl = 'TSMethod' },
            },
            show_symbol_details = false,
            symbol_blacklist = {},
            lsp_blacklist = {
              'null-ls',
            },
          }
        end,
      },
    },
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'f3fora/cmp-spell',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'DeepInThought/vscode-shell-snippets',
      'L3MON4D3/LuaSnip',
    },
    config = function()
      require 'plugins.cmp'
    end,
  }
  use {
    -- insert or delete brackets, parens, quotes in pair
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function()
      require 'plugins.autopairs'
    end,
    -- config = function()
    -- end,
  }

  -- command line
  use { 'vim-scripts/conomode.vim' }
  use { 'gelguy/wilder.nvim' }

  -- UI
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
    requires = {
      {
        'SmiteshP/nvim-gps',
        config = function()
          require('nvim-gps').setup {}
        end,
      },
    },
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
    config = function()
      require('plugins.telescope').setup()
    end,
    module = 'telescope',
    module_pattern = 'telescope.*',
    cmd = 'Telescope',
    requires = {
      {
        'cljoly/telescope-repo.nvim',
      },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'nvim-telescope/telescope-symbols.nvim',
      'crispgm/telescope-heading.nvim',
      '~/Media/Projects/telescope-bookmarks.nvim',
      'nvim-telescope/telescope-project.nvim',
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
    end,
  }
  use {
    '~/Media/Projects/nononotes-nvim',
    config = function()
      require('plugins.nononotes').setup()
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
    'TimUntersberger/neogit',
    config = function()
      require('neogit').setup {
        integrations = {
          diffview = true,
        },
      }
    end,
  }

  use {
    'folke/zen-mode.nvim',
    config = function()
      require('plugins.zen-mode').setup()
    end,
    cmd = { 'ZenMode' },
  }
  use {
    'folke/twilight.nvim',
    config = function()
      require('twilight').setup {}
    end,
    -- cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
  }
  use {
    'metakirby5/codi.vim',
    cmd = { 'Codi', 'Codi!', 'Codi!!' },
  }
  use 'wellle/visual-split.vim'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    setup = function()
      require('plugins.nvim-tree').setup()
    end,
    config = function()
      require('plugins.nvim-tree').config()
    end,
    -- session manager destroys nvim-tree buffer which prevents nvim-tree from working
    -- nvim-tree so needs to be loaded after the session is restored
    cmd = {
      'NvimTreeClipboard',
      'NvimTreeClose',
      'NvimTreeFindFile',
      'NvimTreeFocus',
      'NvimTreeOpen',
      'NvimTreeRefresh',
      'NvimTreeResize',
      'NvimTreeToggle',
    },
  }
  use {
    'mbbill/undotree', -- FIXME
    setup = function()
      require('utils').deep_merge(vim.g, {
        undotree_SplitWidth = 30,
        undotree_TreeVertShape = '│',
      })
    end,
    cmd = { 'UndotreeToggle' },
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
    end,
  }

  -- navigation
  use {
    'kshenoy/vim-signature',
    setup = function()
      local deep_merge = require('utils').deep_merge
      deep_merge(vim, require('bindings').plugins.signature)
    end,
  }
  use {
    'andymass/vim-matchup',
    setup = function()
      require('utils').deep_merge(vim.g, {
        -- matchup_matchparen_offscreen = { method = "popup" }
        -- matchup_matchparen_hi_surround_always = 1,
        -- matchup_matchparen_deferred = 1,
        matchup_matchparen_offscreen = { method = 'status' },
      })
    end,
  }
  use 'hrsh7th/vim-eft'
  use {
    'ggandor/lightspeed.nvim',
    config = function()
      require('lightspeed').setup {}
    end,
  }
  use {
    'abecodes/tabout.nvim',
    config = function()
      require('tabout').setup {
        tabkey = '',
        backwards_tabkey = '',
      }
    end,
  }

  -- clipboard
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
  -- use {
  --   'bfredl/nvim-miniyank',
  --   setup = function()
  --     require('utils').deep_merge(vim.g, {
  --       -- miniyank_delete_maxlines = 1,
  --       miniyank_filename = '/home/prncss/.miniyank.mpack',
  --     })
  --   end,
  -- }
  -- use {
  --   'svermeulen/vim-yoink',
  -- }

  -- edition
  use {
    'JoseConseco/vim-case-change',
    setup = function()
      vim.g.casechange_nomap = 1
    end,
  }
  use {
    'matze/vim-move',
    setup = function()
      vim.g.move_map_keys = 0
    end,
  }
  use {
    'monaqa/dial.nvim',
    config = function()
      require 'plugins.dial'
    end,
  }
  use {
    'tommcdo/vim-exchange',
    setup = function()
      vim.g.exchange_no_mappings = 1
    end,
  }
  use {
    'machakann/vim-sandwich',
    setup = function()
      require('utils').deep_merge(vim, {
        g = {
          -- not as documented
          sandwich_no_default_key_mappings = 1,
          operator_sandwich_no_default_key_mappings = 1,
          textobj_sandwich_no_default_key_mappings = 1,
        },
      })
    end,
  }
  use {
    'svermeulen/vim-macrobatics',
    setup = function()
      require('utils').deep_merge(vim.g, {
        Mac_NamedMacrosDirectory = '~/Media/Projects/macrobatics',
      })
    end,
    requires = 'tpope/vim-repeat',
  }
  use 'mattn/emmet-vim'
  use {
    'b3nj5m1n/kommentary',
    setup = function()
      vim.g.kommentary_create_default_mappings = false
    end,
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
        keymaps = require('bindings').plugins.revJ,
      }
    end,
  }
  use {
    'kana/vim-textobj-user',
    setup = function()
      require('utils').deep_merge(vim, require('bindings').plugins)
    end,
    requires = {
      'Julian/vim-textobj-variable-segment',
      {
        'kana/vim-textobj-datetime',
        setup = function()
          vim.g.textobj_datetime_no_default_key_mappings = 1
        end,
      },
      -- 'preservim/vim-textobj-sentence',
      {
        'kana/vim-textobj-line',
        setup = function()
          vim.g.textobj_line_no_default_key_mappings = 1
        end,
      },
      'kana/vim-textobj-entire',
      'michaeljsmith/vim-indent-object',
      'sgur/vim-textobj-parameter',
    },
  }
  use 'wellle/targets.vim'
  use {
    'tommcdo/vim-ninja-feet',
    setup = function()
      vim.g.ninja_feet_no_mappings = 1
    end,
  }

  -- session
  -- use {
  --   'windwp/nvim-projectconfig',
  --   config = function()
  --     require('nvim-projectconfig').load_project_config {
  --       project_dir = '~/Media/Projects/projects-config/',
  --     }
  --     require('utils').augroup('NvimProjectConfig', {
  --       {
  --         events = { 'DirChanged' },
  --         targets = { '*' },
  --         cmd = require('nvim-projectconfig').load_project_config,
  --       },
  --     })
  --   end,
  -- }
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
    event = "BufReadPre",
    module = "persistence",
    dir = os.getenv 'HOME' .. '/Personal/sessions/',
    config = function()
      require('persistence').setup()
    end,
  }
  use {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {}
    end,
  }
  -- use {
  --   'rmagatti/auto-session',
  --   config = function()
  --     -- require 'plugins.auto-session'
  --   end,
  --   -- requires = {
  --   --   disabled = true,
  --   --   'rmagatti/session-lens',
  --   -- },
  -- }
  -- use {
  --   'Shatur/neovim-session-manager',
  --   setup = function()
  --     require('utils').deep_merge(vim.g, {
  --       session_dir = os.getenv 'HOME' .. 'Media/sessions',
  --     })
  --   end,
  --   config = function()
  --     require('telescope').load_extension 'session_manager'
  --   end,
  -- }

  -- themes
  use 'rafamadriz/neon'
  use 'ishan9299/nvim-solarized-lua'
  use 'sainnhe/gruvbox-material'
  use { 'rose-pine/neovim', as = 'rose-pine' }

  -- various
  use 'tpope/vim-eunuch'
  use {
    'vigoux/LanguageTool.nvim',
    cmd = { 'LanguageToolSetup', 'LanguageToolCheck' },
    setup = function()
      require('utils').deep_merge(vim.g, {
        -- see https://languagetool.org/http-api/swagger-ui/#!/default/post_check
        languagetool_server_command = 'echo "Server Started"',
        languagetool = {
          ['.'] = { language = 'auto' },
        },
      })
    end,
    config = function()
      vim.cmd 'autocmd User LanguageToolCheckDone LanguageToolSummary'
    end,
  }
  use {
    'henriquehbr/nvim-startup.lua',
    config = function()
      require('nvim-startup').setup {}
    end,
  }
end)
