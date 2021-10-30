local install_path = vim.fn.stdpath 'data'
  .. '/site/pack/packer/start/packer.nvim'

local function full()
  return require('pager').full
end

local function ghost()
  return os.getenv 'GHOST_NVIM' or false
end

local function never()
  return false
end

-- TODO: lazy loading; cf https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/plugins/init.lua

local function local_repo(name)
  return os.getenv 'PROJECTS' .. '/' .. name
end

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system {
    'git',
    'clone',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  vim.cmd 'packadd packer.nvim'
end

return require('packer').startup {
  function()
    use 'wbthomason/packer.nvim'
    use {
      'lewis6991/impatient.nvim',
      config = {
        -- Move to lua dir so impatient.nvim can cache it
        compile_path = vim.fn.stdpath 'config' .. '/lua/packer_compiled.lua',
      },
    }
    use {
      'nathom/filetype.nvim',
      config = function()
        require 'plugins.filetype'
      end,
    }
    use {
      'nvim-lua/plenary.nvim',
      module = 'plenary',
    }
    use {
      'nvim-lua/popup.nvim',
      module = 'popup',
    }
    use {
      'kyazdani42/nvim-web-devicons',
      module = 'nvim-web-devicons',
      config = function()
        require('nvim-web-devicons').setup { default = true }
      end,
    }

    -- tree sitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      -- event = 'BufRead',
      module = 'nvim-treesitter.ts_utils',
      opt = true,
      config = function()
        require 'plugins.treesitter'
      end,
      requires = { -- TODO: lazy
        { 'p00f/nvim-ts-rainbow', cond = full },
        { 'nvim-treesitter/playground', cmd = { 'TSPlaygroundToggle' } },
        { 'JoosepAlviste/nvim-ts-context-commentstring', cond = full },
        { 'nvim-treesitter/nvim-treesitter-textobjects', cond = full },
        -- { 'RRethy/nvim-treesitter-textsubjects', cond = full },
        -- "beloglazov/vim-textobj-punctuation", -- au/iu for punctuation
        { 'mfussenegger/nvim-ts-hint-textobject', cond = full },
        -- Use 'tressitter 'to autoclose and autorename html tag
        { 'windwp/nvim-ts-autotag', cond = full },
        -- shows the context of the currently visible buffer contents
        { 'romgrk/nvim-treesitter-context', cond = full },
      },
    }
    use {
      'lewis6991/spellsitter.nvim',
      after = 'nvim-treesitter',
      cond = full,
      config = function()
        require('spellsitter').setup()
      end,
    }

    -- syntax
    use 'ajouellette/sway-vim-syntax'
    use 'fladson/vim-kitty'
    use {
      -- weirdly seems required to format yaml frontmatter
      'godlygeek/tabular',
      requires = {
        disable = true,
        ft = 'markdown',
        -- unsuccessful setting options here
      },
    }

    -- tests
    use { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" }

    -- lua dev
    use { 'nanotee/luv-vimdocs', cond = full }
    use { 'milisims/nvim-luaref', cond = full }
    use { 'glepnir/prodoc.nvim', cond = full }

    use {
      'subnut/nvim-ghost.nvim',
      run = function()
        vim.fn['nvim_ghost#installer#install']()
      end,
      cond = ghost,
    }

    -- LSP
    use {
      'lewis6991/gitsigns.nvim',
      module = 'gitsigns',
      wants = 'plenary.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      cond = full,
      config = function()
        require('plugins.gitsigns').setup()
      end,
    }
    use {
      'stevearc/aerial.nvim',
      module = 'aerial',
    }
    use {
      'jose-elias-alvarez/null-ls.nvim',
      module = 'null-ls',
    }
    use { 'folke/lua-dev.nvim', module = 'lua-dev' }
    use { 'jose-elias-alvarez/nvim-lsp-ts-utils', module = 'nvim-lsp-ts-utils' }
    use {
      'neovim/nvim-lspconfig',
      cond = full,
      config = function()
        require('plugins.lsp').setup()
      end,
    }
    use {
      'kosayoda/nvim-lightbulb',
      after = 'nvim-lspconfig',
      config = function()
        vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
      end,
    }
    use {
      'simrat39/symbols-outline.nvim',
      cmd = 'SymbolsOutline',
      setup = function()
        local symbols = require('symbols').symbols
        vim.g.symbols_outline = {
          width = 30,
          show_guides = false,
          auto_preview = false,
          position = 'left',
          symbols = {
            Array = { icon = symbols.Array, hl = 'TSConstant' },
            Boolean = { icon = symbols.Boolean, hl = 'TSBoolean' },
            Class = { icon = symbols.Class, hl = 'TSType' },
            Constant = { icon = symbols.Constant, hl = 'TSConstant' },
            Constructor = { icon = symbols.Constructor, hl = 'TSConstructor' },
            Enum = { icon = symbols.Enum, hl = 'TSType' },
            EnumMember = { icon = symbols.EnumMember, hl = 'TSField' },
            Event = { icon = symbols.Event, hl = 'TSType' },
            Field = { icon = symbols.Field, hl = 'TSField' },
            File = { icon = symbols.File, hl = 'TSURI' },
            Function = { icon = symbols.Function, hl = 'TSFunction' },
            Interface = { icon = symbols.Interface, hl = 'TSType' },
            Key = { icon = symbols.Keyword, hl = 'TSType' },
            Method = { icon = symbols.Method, hl = 'TSMethod' },
            Module = { icon = symbols.Module, hl = 'TSNamespace' },
            Namespace = { icon = symbols.Namespace, hl = 'TSNamespace' },
            Null = { icon = symbols.Null, hl = 'TSType' },
            Number = { icon = symbols.Number, hl = 'TSNumber' },
            Object = { icon = symbols.Object, hl = 'TSType' },
            Operator = { icon = symbols.Operator, hl = 'TSOperator' },
            Package = { icon = symbols.Package, hl = 'TSNamespace' },
            Property = { icon = symbols.Property, hl = 'TSMethod' },
            String = { icon = symbols.String, hl = 'TSString' },
            Struct = { icon = symbols.Struct, hl = 'TSType' },
            Variable = { icon = symbols.Variable, hl = 'TSConstant' },
          },
          show_symbol_details = false,
          symbol_blacklist = {},
          lsp_blacklist = {
            'null-ls',
          },
        }
      end,
    }
    -- FIXME: snippets just disappeared
    use { local_repo 'friendly-snippets' }
    use {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      event = 'InsertEnter',
      requires = {
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        { 'f3fora/cmp-spell', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        { 'L3MON4D3/LuaSnip', module = 'luasnip' },
      },
      config = function()
        require 'plugins.cmp'
      end,
    }

    -- insert or delete brackets, parentheses, quotes in pair
    use {
      'windwp/nvim-autopairs',
      after = 'nvim-cmp',
      config = function()
        require 'plugins.autopairs'
      end,
    }

    -- UI
    use { 'gelguy/wilder.nvim' }
    use {
      'lukas-reineke/indent-blankline.nvim',
      event = 'BufReadPre',
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
    use { 'SmiteshP/nvim-gps', module = 'nvim-gps' }
    -- TODO: lazy
    use {
      'glepnir/galaxyline.nvim',
      cond = full,
      config = function()
        require 'plugins.galaxyline'
      end,
    }
    use {
      'folke/trouble.nvim',
      module = 'trouble.providers.telescope',
      cmd = {
        'TodoQuickFix',
        'TodoLocList',
        'TodoTrouble',
        'TodoTelescope',
      },
      config = function()
        require('trouble').setup {
          position = 'bottom',
          -- width = 30,
          use_lsp_diagnostic_signs = true,
        }
      end,
    }
    use {
      -- TODO: lazy
      'folke/todo-comments.nvim',
      -- event = 'BufReadPre',
      cond = full,
      config = function()
        require('todo-comments').setup {}
      end,
    }
    use 'kevinhwang91/nvim-hlslens'
    use {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup {
          mappings = {},
        }
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
    }
    use {
      'nvim-telescope/telescope-symbols.nvim',
      after = 'telescope.nvim',
    }
    use {
      -- personal branch for pnpm compat
      -- https://github.com/nvim-telescope/telescope-node-modules.nvim/pull/3
      local_repo 'telescope-node-modules.nvim',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension 'node_modules'
      end,
    }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension 'fzf'
      end,
    }
    use {
      'crispgm/telescope-heading.nvim',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension 'heading'
      end,
    }
    use {
      'nvim-telescope/telescope-project.nvim',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension 'project'
      end,
    }
    use {
      'romgrk/barbar.nvim',
      disable = true,
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
      local_repo 'nononotes-nvim',
      cond = full,
      config = function()
        require('plugins.nononotes').setup()
      end,
    }
    use {
      'sindrets/diffview.nvim',
      config = function()
        require('diffview').setup()
      end,
      cmd = {
        'DiffviewOpen',
        'DiffviewClose',
        'DiffviewFileHistory',
        'DiffViewToggleFiles',
        'DiffViewFocusFiles',
        'DiffViewRefresh',
      },
    }
    use {
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      module = 'neogit',
      config = function()
        require('neogit').setup {
          integrations = {
            diffview = true,
          },
        }
      end,
    }
    use {
      'edluffy/specs.nvim',
      after = 'neoscroll.nvim',
      config = function()
        require('specs').setup {}
      end,
    }
    use {
      'folke/zen-mode.nvim',
      cond = full,
      config = function()
        require('plugins.zen-mode').setup()
      end,
      cmd = { 'ZenMode' },
    }
    use {
      'folke/twilight.nvim',
      wants = 'twilight.nvim',
      requires = { 'folke/twilight.nvim' },
      -- cond = full,
      config = function()
        require('twilight').setup {}
      end,
      cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
    }
    use {
      'metakirby5/codi.vim',
      cmd = { 'Codi', 'Codi!', 'Codi!!' },
    }
    use { 'wellle/visual-split.vim', cond = full }
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
    use {
      'folke/which-key.nvim',
      -- cond = never,
      event = 'VimEnter',
      config = function()
        require('which-key').setup {
          plugins = {
            presets = {
              operators = false,
              motions = false,
              text_objects = false,
              windows = false,
              nav = false,
              z = false,
              g = false,
            },
          },
        }
      end,
    }

    -- navigation
    use {
      local_repo 'bufjump.nvim',
      module = 'bufjump',
      config = function()
        require('bufjump').setup {
          cond = require('bufjump').under_cwd,
        }
      end,
    }
    -- use { 'chentau/marks.nvim', } -- TODO:
    use {
      cond = full,
      'andymass/vim-matchup',
    }
    -- use 'hrsh7th/vim-eft'
    use {
      'ggandor/lightspeed.nvim',
      event = 'BufReadPost',
      config = function()
        require('lightspeed').setup {}
      end,
    }
    use {
      'abecodes/tabout.nvim',
      cond = full,
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
      event = 'InsertEnter',
      config = function()
        require 'plugins.hclipboard'
      end,
    }
    use {
      'AckslD/nvim-anywise-reg.lua',
      cond = full,
      config = function()
        require 'plugins.anywise_reg'
      end,
    }
    use {
      'bfredl/nvim-miniyank',
      disable = true,
      setup = function()
        require('utils').deep_merge(vim.g, {
          -- miniyank_delete_maxlines = 1,
          miniyank_filename = '/home/prncss/.miniyank.mpack',
        })
      end,
    }
    use {
      'svermeulen/vim-yoink',
      disable = true,
    }
    -- edition
    use {
      'JoseConseco/vim-case-change',
      cond = full,
      setup = function()
        vim.g.casechange_nomap = 1
      end,
    }
    use {
      'matze/vim-move',
      cond = full,
      setup = function()
        vim.g.move_map_keys = 0
      end,
    }
    use {
      'monaqa/dial.nvim',
      cond = full,
      config = function()
        require 'plugins.dial'
      end,
    }
    use {
      'tommcdo/vim-exchange',
      cond = full,
      setup = function()
        vim.g.exchange_no_mappings = 1
      end,
    }
    use {
      'machakann/vim-sandwich',
      cond = full,
      setup = function()
        require('utils').deep_merge(vim, {
          g = {
            sandwich_no_default_key_mappings = 1,
            operator_sandwich_no_default_key_mappings = 1,
            textobj_sandwich_no_default_key_mappings = 1,
          },
        })
      end,
    }
    local mac_repo = local_repo 'macrobatics'
    use {
      'svermeulen/vim-macrobatics',
      cond = full,
      setup = function()
        require('utils').deep_merge(vim.g, {
          Mac_NamedMacrosDirectory = mac_repo,
        })
      end,
    }
    use {
      'tpope/vim-repeat',
      cond = full,
    }
    use {
      'b3nj5m1n/kommentary',
      cond = full,
      setup = function()
        vim.g.kommentary_create_default_mappings = false
      end,
      config = function()
        require('kommentary.config').configure_language('default', {
          prefer_single_line_comments = true,
        })
        require('kommentary.config').configure_language('javascriptreact', {
          single_line_comment_string = 'auto',
          multi_line_comment_strings = 'auto',
          hook_function = function()
            require('ts_context_commentstring.internal').update_commentstring()
          end,
        })

        require('kommentary.config').configure_language('typescriptreact', {
          single_line_comment_string = 'auto',
          multi_line_comment_strings = 'auto',
          hook_function = function()
            require('ts_context_commentstring.internal').update_commentstring()
          end,
        })
        require('kommentary.config').configure_language('fish', {
          single_line_comment_string = '#',
        })
      end,
    }
    use {
      'AckslD/nvim-revJ.lua',
      cond = full,
      config = function()
        require('revj').setup {
          keymaps = require('bindings').plugins.revJ,
        }
      end,
    }
    use {
      'kana/vim-textobj-user',
      cond = full,
      setup = function()
        require('utils').deep_merge(vim, require('bindings').plugins)
      end,
      requires = {
        { 'Julian/vim-textobj-variable-segment', cond = full },
        {
          'kana/vim-textobj-datetime',
          cond = full,
          setup = function()
            vim.g.textobj_datetime_no_default_key_mappings = 1
          end,
        },
        { 'preservim/vim-textobj-sentence', cond = full },
        {
          'kana/vim-textobj-line',
          cond = full,
          setup = function()
            vim.g.textobj_line_no_default_key_mappings = 1
          end,
        },
        { 'kana/vim-textobj-entire', cond = full },
        { 'michaeljsmith/vim-indent-object', cond = full },
      },
    }
    use { 'wellle/targets.vim', cond = full }
    use {
      'tommcdo/vim-ninja-feet',
      cond = full,
      setup = function()
        vim.g.ninja_feet_no_mappings = 1
      end,
    }
    -- session
    use {
      'windwp/nvim-projectconfig',
      disable = true,
      config = function()
        require('nvim-projectconfig').load_project_config {
          project_dir = local_repo 'projects-config/',
        }
        require('utils').augroup('NvimProjectConfig', {
          {
            events = { 'DirChanged' },
            targets = { '*' },
            cmd = require('nvim-projectconfig').load_project_config,
          },
        })
      end,
    }
    use {
      'ethanholz/nvim-lastplace',
      cond = full,
      config = function()
        require('nvim-lastplace').setup {
          lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
          lastplace_open_folds = true,
        }
      end,
    }
    use {
      'folke/persistence.nvim',
      disable = true,
      event = 'BufReadPre',
      module = 'persistence',
      dir = os.getenv 'HOME' .. '/Personal/sessions/',
      config = function()
        require('persistence').setup()
      end,
    }
    use {
      'ahmedkhalf/project.nvim',
      cond = full,
      config = function()
        require('project_nvim').setup {}
        require('telescope').load_extension 'projects'
      end,
    }

    use {
      'rmagatti/auto-session',
      disable = true,
      config = function()
        -- require 'plugins.auto-session'
      end,
      -- requires = {
      --   'rmagatti/session-lens',
      -- },
    }
    use {
      'Shatur/neovim-session-manager',
      disable = true,
      setup = function()
        require('utils').deep_merge(vim.g, {
          session_dir = os.getenv 'HOME' .. 'Media/sessions',
        })
      end,
      config = function()
        require('telescope').load_extension 'session_manager'
      end,
    }

    -- themes
    use 'rafamadriz/neon'
    use 'ishan9299/nvim-solarized-lua'
    use 'sainnhe/gruvbox-material'
    use { 'rose-pine/neovim', as = 'rose-pine' }

    -- various
    use {
      'tpope/vim-eunuch',
      cmd = {
        'Cfind',
        'Chmod',
        'Clocate',
        'Delete',
        'Lfind',
        'Llocate',
        'Mkdir',
        'Move',
        'Rename',
        'SudoEdit',
        'SudoWrite',
        'Unlink',
        'Wall',
      },
    }

    use {
      'henriquehbr/nvim-startup.lua',
      cond = never,
      config = function()
        require('nvim-startup').setup {
          startup_file = '/tmp/nvim-startuptime',
          messages = print,
        }
      end,
    }
  end,
  config = {
    profile = {
      enable = true,
      threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
  },
}
