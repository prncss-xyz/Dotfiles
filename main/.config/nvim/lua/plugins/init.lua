local install_path = vim.fn.stdpath 'data'
  .. '/site/pack/packer/start/packer.nvim'

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

-- FIXME:

local function default_config(name, config)
  return string.format(
    "require('%s').setup(%s)",
    name,
    vim.inspect(config or {})
  )
end

local function config(name)
  return string.format("require('plugins.%s').config()", name)
end

local function g_setup(o)
  return string.format('vim_g_setup(%s)', vim.inspect(o))
end

local function setup(name)
  return string.format("require('plugins.%s').setup()", name)
end

return require('packer').startup {
  function()
    use 'wbthomason/packer.nvim'
    use { 'nvim-lua/plenary.nvim', module = 'plenary' }
    use { 'nvim-lua/popup.nvim', module = 'popup' }
    use { 'MunifTanjim/nui.nvim', module = 'nui' }
    use { 'tami5/sqlite.lua', module = 'sqlite' }
    use {
      'kyazdani42/nvim-web-devicons',
      module = 'nvim-web-devicons',
      config = default_config('nvim-web-devicons', { default = true }),
    }

    -- treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      module = { 'nvim-treesitter', 'nvim-treesitter.parsers' }, -- HACK: why do I need this?
      module_pattern = 'nvim-treesitter.*',
      config = config 'nvim-treesitter',
    }
    use { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' }
    use {
      local_repo 'flies.nvim',
      config = config 'flies',
      module = 'flies',
      module_pattern = 'flies.*',
      event = 'BufReadPost',
    }
    use { 'mfussenegger/nvim-ts-hint-textobject', module = 'tsht' }
    use {
      'nvim-treesitter/playground',
      cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
    }
    -- Use tressitter to autoclose and autorename html tag
    use { 'windwp/nvim-ts-autotag', event = 'InsertEnter' }
    use { 'David-Kunz/treesitter-unit', module = 'treesitter-unit' }
    use {
      'JoosepAlviste/nvim-ts-context-commentstring',
      module = 'ts_context_commentstring',
    }
    use {
      -- annotation toolkit
      'danymat/neogen',
      module = 'neogen',
      config = function()
        require('neogen').setup {
          enabled = true,
          snippet_engine = 'luasnip',
        }
      end,
      requires = 'nvim-treesitter/nvim-treesitter',
    }
    use {
      'nvim-treesitter/nvim-treesitter-context',
      config = config 'nvim-treesitter-context',
      after = 'nvim-treesitter',
    }

    -- syntax
    use { 'ajouellette/sway-vim-syntax', ft = 'sway' }
    -- use 'fladson/vim-kitty'

    -- luv docs in :help
    use { 'nanotee/luv-vimdocs' }
    -- lua docs in :help
    use { 'milisims/nvim-luaref' }

    -- DAP
    use {
      'mfussenegger/nvim-dap',
      module = 'dap',
      config = function()
        require('plugins.dap').config()
      end,
    }
    use {
      'rcarriga/nvim-dap-ui',
      requires = { 'mfussenegger/nvim-dap' },
      module = 'dapui',
      config = function()
        require('dapui').setup()
      end,
    }
    use { 'jbyuki/one-small-step-for-vimkind', module = 'osv' }
    use {
      'vim-test/vim-test',
      cmd = {
        'TestNearest',
        'TestFile',
        'TestSuite',
        'TestLast',
        'TestVisit',
      },
    }
    use {
      'rcarriga/vim-ultest',
      requires = {
        'vim-test/vim-test',
      },
      run = ':UpdateRemotePlugins',
      cmd = {
        'Ultest',
        'UltestNearest',
        'UltestDebug',
        'UltestLast',
        'UltestDebugNearest',
        'UltestOutput',
        'UltestAttach',
        'UltestStop',
        'UltestStopNearest',
        'UltestSummary',
        'UltestSummaryOpen',
        'UltestSummaryClose',
        'UltestClear',
      },
      setup = function()
        require('plugins.ultest').setup()
      end,
      config = function()
        require('plugins.ultest').config()
      end,
    }

    -- LSP
    use {
      'neovim/nvim-lspconfig',
      module = 'lspconfig',
      event = 'BufReadPost',
      setup = setup 'lsp',
      config = config 'lsp',
    }
    use {
      'jose-elias-alvarez/null-ls.nvim',
      event = 'BufReadPost',
      config = function()
        require('plugins.null-ls').config()
      end,
    }
    use {
      'simrat39/symbols-outline.nvim',
      after = 'nvim-lspconfig',
      cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen' },
      setup = setup 'symbols-outline',
      disable = true,
    }
    use {
      'stevearc/aerial.nvim',
      config = config 'aerial',
      module = 'aerial',
      cmd = {
        'AerialOpen',
        'AerialClose',
        'AerialInfo',
      },
    }
    use {
      'ThePrimeagen/refactoring.nvim',
      module = 'refactoring',
      config = default_config 'refactoring',
    }
    use {
      'RRethy/vim-illuminate',
      setup = setup 'illuminate',
      config = config 'illuminate',
      module = 'illuminate',
    }
    use {
      'rmagatti/goto-preview',
      config = config 'goto-preview',
      module = 'goto-preview',
    }
    -- LSP, language-specific
    use {
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      module = 'nvim-lsp-ts-utils',
    }
    use { 'folke/lua-dev.nvim', module = 'lua-dev' }
    use { 'b0o/schemastore.nvim', module = 'schemastore' }
    use { 'nanotee/sqls.nvim', module = 'sqls' }
    use {
      'brymer-meneses/grammar-guard.nvim',
      after = 'nvim-lspconfig',
      config = config 'grammar-guard',
      disable = true,
    }

    -- completion
    use { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' }
    use {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      event = { 'InsertEnter', 'CmdlineEnter' },
      config = function()
        require('plugins.cmp').config()
      end,
    }
    use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
    use {
      'hrsh7th/cmp-path',
      module = 'cmp-path',
      after = 'nvim-cmp',
    }
    use { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' }
    use { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' }
    use {
      'David-Kunz/cmp-npm',
      after = 'nvim-cmp',
      requires = {
        'nvim-lua/plenary.nvim',
      },
    }
    use { 'mtoohey31/cmp-fish', ft = 'fish' }
    use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
    use { 'dmitmel/cmp-cmdline-history', after = 'nvim-cmp' }
    use { 'davidsierradz/cmp-conventionalcommits', after = 'nvim-cmp' }
    -- insert or delete brackets, parentheses, quotes in pair
    use {
      'windwp/nvim-autopairs',
      -- after = 'nvim-cmp',
      config = config 'nvim-autopairs',
      event = 'InsertEnter',
    }
    use {
      'L3MON4D3/LuaSnip',
      module = 'luasnip',
      event = 'InsertEnter',
      config = config 'luasnip',
    }
    -- Git
    use {
      'lewis6991/gitsigns.nvim',
      -- module = 'gitsigns',
      event = 'BufReadPost',
      wants = 'plenary.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('plugins.gitsigns').config()
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
          disable_builtin_notifications = true,
          kind = 'split',
          integrations = {
            diffview = true,
          },
        }
      end,
    }

    -- UI
    use {
      local_repo 'buffstory.nvim',
      config = default_config 'buffstory',
      event = 'BufReadPre',
    }
    use {
      'rafcamlet/tabline-framework.nvim',
      config = config 'tabline-framework',
      event = 'BufEnter',
    }
    use {
      -- TODO: replace by maintained plugin
      'glepnir/galaxyline.nvim',
      event = 'BufEnter',
      config = config 'galaxyline',
    }
    use {
      'stevearc/dressing.nvim',
      config = default_config 'dressing',
      event = 'BufReadPost',
      -- module = vim.ui,
    }
    use {
      'rcarriga/nvim-notify',
      config = config 'nvim-notify',
      disable = true,
    }
    use {
      's1n7ax/nvim-window-picker',
      tag = 'v1.*',
      config = function()
        require('window-picker').setup {
          selection_chars = require('plugins.binder.parameters').selection_chars:upper(),
        }
      end,
      module = 'window-picker',
    }
    use {
      'lukas-reineke/indent-blankline.nvim',
      event = 'BufReadPre',
      config = config 'indent-blankline',
    }
    use {
      'folke/trouble.nvim',
      module = 'trouble',
      module_pattern = 'trouble.*',
      cmd = {
        'TodoQuickFix',
        'TodoLocList',
        'TodoTrouble',
        'TodoTelescope',
      },
      config = config 'trouble',
    }
    use {
      'folke/todo-comments.nvim',
      event = 'BufReadPost',
      cmd = { 'TodoTrouble', 'TodoTelescope' },
      config = default_config 'todo-comments',
    }
    use {
      'folke/zen-mode.nvim',
      cmd = { 'ZenMode' },
      config = config 'zen-mode',
    }
    use {
      'folke/twilight.nvim',
      config = default_config 'twilight',
      module = 'twilight',
      cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
    }
    use {
      -- 'simnalamburt/vim-mundo'
      'mbbill/undotree',
      setup = function()
        require('plugins.undotree').setup()
      end,
      cmd = { 'UndotreeToggle' },
    }
    use {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = config 'neo-tree',
      cmd = { 'Neotree' },
    }
    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require('plugins.nvim-tree').config()
      end,
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
      disable = true,
    }
    use {
      'fhill2/xplr.nvim',
      run = function()
        require('xplr').install { hide = true }
      end,
      module = 'xplr',
      config = function()
        require('plugins.xplr').config()
      end,
      requires = { { 'nvim-lua/plenary.nvim' }, { 'MunifTanjim/nui.nvim' } },
      disable = true,
    }
    use {
      local_repo 'split.nvim',
      module = 'split',
    }

    -- Navigation
    use {
      'karb94/neoscroll.nvim',
      module = 'neoscroll',
      config = function()
        require('neoscroll').setup {
          mappings = {},
        }
      end,
    }
    use {
      'kevinhwang91/nvim-hlslens',
      config = function()
        require('hlslens').setup {
          calm_down = true,
        }
      end,
      module = 'hlslens',
    }
    use {
      'haya14busa/vim-asterisk',
      setup = g_setup { ['asterisk#keeppos'] = 1 },
    }
    use {
      'edluffy/specs.nvim',
      after = 'neoscroll.nvim',
      config = function() end,
    }
    use {
      local_repo 'bufjump.nvim',
      module = 'bufjump',
      config = function()
        require('bufjump').setup {
          cond = require('bufjump').under_cwd,
        }
      end,
    }
    use {
      -- local_repo 'marks.nvim',
      'chentoast/marks.nvim',
      event = 'BufReadPost',
      config = function()
        require('marks').setup {
          default_mappings = false,
          refresh_interval = 9,
        }
        -- https://github.com/chentoast/marks.nvim/issues/40
        vim.api.nvim_create_autocmd('cursorhold', {
          pattern = '*',
          callback = require('marks').refresh,
        })
      end,
    }
    use {
      'phaazon/hop.nvim',
      module = 'hop',
      config = config 'hop',
    }
    use {
      'abecodes/tabout.nvim',
      event = 'InsertEnter',
      config = config 'tabout',
    }

    -- Telescope
    use {
      'nvim-telescope/telescope.nvim',
      config = function()
        require('plugins.telescope').config()
      end,
      module = 'telescope',
      module_pattern = 'telescope.*',
      cmd = 'Telescope',
    }
    use {
      'nvim-telescope/telescope-node-modules.nvim',
      module = 'telescope._extensions.node_modules',
      -- config = function()
      --   require('telescope').load_extension 'node_modules'
      -- end,
    }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
      module = 'telescope._extensions.fzf',
    }
    use {
      'crispgm/telescope-heading.nvim',
      module = 'telescope._extensions.heading',
    }
    use {
      'nvim-telescope/telescope-project.nvim',
      module = 'telescope._extensions.project',
    }
    use {
      'nvim-telescope/telescope-dap.nvim',
      module = 'telescope._extensions.dap',
    }
    use {
      local_repo 'nononotes-nvim',
      config = function()
        require('plugins.nononotes').setup()
      end,
      -- ft = 'markdown',
    }
    -- data files, no need for lazy loading
    use { 'nvim-telescope/telescope-symbols.nvim' }
    use {
      'nvim-telescope/telescope-cheat.nvim',
      module = 'telescope._extensions.cheat',
      module_pattern = 'telescope._extensions.cheat.*',
    }

    -- Bindings
    use {
      'mrjones2014/legendary.nvim',
      module = 'legendary',
      config = config 'legendary',
      cmd = {
        'Legendary',
        'LegendaryScratch',
        'LegendaryEvalLine',
        'LegendaryEvalLines',
        'LegendaryEvalBuf',
        'LegendaryApi',
      },
    }
    use {
      'linty-org/key-menu.nvim',
      module = 'key-menu',
    }
    use {
      local_repo 'binder.nvim',
      event = 'VimEnter',
      config = config 'binder',
    }
    -- Edition
    use {
      local_repo 'templum.nvim',
      config = config 'templum',
      event = 'VimEnter',
    }
    use { 'linty-org/readline.nvim', module = 'readline' }
    use {
      'AckslD/nvim-neoclip.lua',
      config = config 'nvim-neoclip',
    }
    use {
      'AndrewRadev/splitjoin.vim',
      setup = function()
        vim.g.splitjoin_join_mapping = ''
        vim.g.splitjoin_split_mapping = ''
      end,
      cmd = { 'SplitjoinJoin', 'SplitjoinSplit' },
    }
    use {
      'monaqa/dial.nvim',
      event = 'BufReadPost',
      config = function()
        require('plugins.dial').config()
      end,
    }
    use {
      'tommcdo/vim-exchange',
      event = 'BufReadPost',
      setup = function()
        vim.g.exchange_no_mappings = 1
      end,
      disable = true,
    }
    local mac_repo = local_repo 'macrobatics'
    use {
      'svermeulen/vim-macrobatics',
      event = 'BufReadPost',
      setup = function()
        vim.g.Mac_NamedMacrosDirectory = mac_repo
      end,
      disable = true,
    }
    use {
      'tpope/vim-repeat',
      event = 'BufReadPost',
    }
    use {
      'numToStr/Comment.nvim',
      event = 'BufReadPost',
      module = 'Comment',
      module_pattern = 'Comment.*',
      after = 'nvim-treesitter',
      -- TODO: replace after with key = {...}
      config = config 'comment',
    }

    -- Session
    use {
      'ethanholz/nvim-lastplace',
      event = 'BufReadPre',
      config = default_config('nvim-lastplace', {
        lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
        lastplace_ignore_filetype = {
          'gitcommit',
          'gitrebase',
          'svn',
          'hgcommit',
        },
      }),
    }
    use {
      'ahmedkhalf/project.nvim',
      config = default_config 'project_nvim',
      event = 'BufReadPost',
    }
    use {
      'ThePrimeagen/harpoon',
      module = { 'harpoon', '._extensions.marks' },
      module_pattern = 'harpoon.*',
      config = config 'harpoon',
    }

    -- Theming
    use { 'mvllow/modes.nvim', config = default_config 'modes', disable = false }

    -- Themes
    use 'rafamadriz/neon'
    use 'ishan9299/nvim-solarized-lua'
    use 'sainnhe/gruvbox-material'
    use { 'rose-pine/neovim', as = 'rose-pine' }

    -- Runners
    -- binary installed with `yay -S neovim-sniprun`
    use {
      'michaelb/sniprun',
      module = 'sniprun',
      module_pattern = 'sniprun.*',
      cmd = {
        'SnipRun',
        'SnipInfo',
        'SnipReset',
        'SnipReplMemoryClean',
        'SnipClose',
      },
      config = default_config('sniprun', {
        require('sniprun').setup {
          live_mode_toggle = 'on',
          selected_interpreters = {
            'Python3_jupyter',
            -- 'JS_TS_deno'
          },
        },
      }),
      disable = true,
    }
    use {
      'metakirby5/codi.vim',
      cmd = { 'Codi', 'Codi!', 'Codi!!' },
      disable = true,
    }
    use {
      'rafcamlet/nvim-luapad',
      cmd = { 'Luapad', 'LuaRun' },
      module = 'luapad',
      module_pattern = 'luapad.*',
      config = default_config 'luapad',
    }
    use {
      'jbyuki/dash.nvim',
      module = 'dash',
      cmd = { 'DashRun', 'DashConnect', 'DashDebug' },
    }
    use {
      'jbyuki/carrot.nvim',
      cmd = { 'CarrotEval', 'CarrotNewBlock' },
    }

    use { 'nvim-neorg/neorg', config = config 'neorg' }

    -- Various
    use { 'lewis6991/impatient.nvim' }
    use { 'dstein64/vim-startuptime' }
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float { border = 'single' }
      end,
    },
    profile = {
      enable = true,
      threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
  },
}
