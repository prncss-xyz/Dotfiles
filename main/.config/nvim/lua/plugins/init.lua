local install_path = vim.fn.stdpath 'data'
  .. '/site/pack/packer/start/packer.nvim'

local function local_repo(name)
  return os.getenv 'PROJECTS' .. '/github.com/prncss-xyz/' .. name
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

local function setup(name)
  return string.format("require('plugins.%s').setup()", name)
end

return require('packer').startup {
  function()
    use 'wbthomason/packer.nvim'
    use {
      'nvim-lua/plenary.nvim',
      module = 'plenary',
    }
    use {
      'kevinhwang91/promise-async',
      module = { 'async', 'promise' },
      module_pattern = 'promise-async',
    }
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
    -- Use tressitter to autoclose and autorename HTML tag
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

    -- LUV docs in :help
    use { 'nanotee/luv-vimdocs' }
    -- lua docs in :help
    use { 'milisims/nvim-luaref' }

    -- LSP
    use {
      'neovim/nvim-lspconfig',
      module = 'lspconfig',
      event = 'BufReadPost',
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
      'stevearc/aerial.nvim',
      config = config 'aerial',
      module = 'aerial',
      after = 'lualine.nvim',
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
      'jose-elias-alvarez/typescript.nvim',
      module = 'typescript',
    }
    use { 'folke/lua-dev.nvim', module = 'lua-dev' }
    use { 'b0o/schemastore.nvim', module = 'schemastore' }
    use { 'nanotee/sqls.nvim', module = 'sqls' }
    use {
      'brymer-meneses/grammar-guard.nvim',
      module = 'grammar-guard',
    }

    -- completion
    use { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' }
    use {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      -- event = { 'InsertEnter' },
      event = { 'InsertEnter', 'CmdlineEnter' },
      config = function()
        require('plugins.cmp').config()
      end,
    }
    use { 'hrsh7th/cmp-calc', after = 'nvim-cmp' }
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
      config = config 'nvim-autopairs',
      event = 'InsertEnter',
    }
    use {
      'L3MON4D3/LuaSnip',
      module = 'luasnip',
      event = 'InsertEnter',
      config = config 'luasnip',
    }

    -- tasks
    use {
      'mfussenegger/nvim-dap',
      module = 'dap',
      config = function()
        require('plugins.dap').config()
      end,
    }
    use {
      'theHamsta/nvim-dap-virtual-text',
      after = 'nvim-dap',
      config = default_config 'nvim-dap-virtual-text',
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
      'mxsdev/nvim-dap-vscode-js',
      -- module = 'dap-vscode-js',
      requires = { 'mfussenegger/nvim-dap' },
      config = config 'nvim-dap-vscode-js',
      after = 'nvim-dap',
    }
    use {
      'microsoft/vscode-js-debug',
      opt = true,
      run = 'npm install --legacy-peer-deps && npm run compile',
    }
    use {
      'nvim-neotest/neotest-plenary',
      module = 'neotest-plenary',
    }
    use {
      'haydenmeade/neotest-jest',
      module = 'neotest-jest',
    }
    use {
      'nvim-neotest/neotest',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim',
      },
      module = 'neotest',
      config = config 'neotest',
    }
    use {
      'stevearc/overseer.nvim',
      config = config 'overseer',
      module = { 'overseer', 'neotest.consumers.overseer' },
      cmd = {
        'OverseerOpen',
        'OverseerClose',
        'OverseerToggle',
        'OverseerSaveBundle',
        'OverseerLoadBundle',
        'OverseerDeleteBundle',
        'OverseerRunCmd',
        'OverseerRun',
        'OverseerBuild',
        'OverseerQuickAction',
        'OverseerTaskAction',
      },
    }

    -- Runners
    -- binary installed with `yay -S neovim-sniprun`
    use {
      'michaelb/sniprun',
      run = 'bash ./install.sh',
      module = 'sniprun',
      -- module_pattern = 'sniprun.*',
      config = function()
        -- FIX: this seems never to be called
        print 'sniprun user config'
        -- assert(false)
        require('sniprun').setup {
          selected_interpreters = {
            'Python3_jupyter',
          },
          -- display = { 'FloatingWindow' },
        }
      end,
    }
    -- eventual replacement for codi, not quite mature though
    use {
      'jbyuki/dash.nvim',
      module = 'dash',
      cmd = { 'DashRun', 'DashConnect', 'DashDebug' },
    }
    use {
      'jbyuki/carrot.nvim',
      cmd = { 'CarrotEval', 'CarrotNewBlock' },
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

    -- Themes
    use 'rafamadriz/neon'
    use 'ishan9299/nvim-solarized-lua'
    use 'sainnhe/gruvbox-material'
    use { 'rose-pine/neovim', as = 'rose-pine' }

    -- apparance
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
      'edluffy/specs.nvim',
      after = 'neoscroll.nvim',
      config = function() end,
    }
    use { 'mvllow/modes.nvim', config = default_config 'modes' }

    -- UI
    use {
      'kevinhwang91/nvim-ufo',
      requires = 'kevinhwang91/promise-async',
      config = config 'nvim-ufo',
      event = 'BufReadPost',
    }
    use {
      'masukomi/vim-markdown-folding',
      ft = 'markdown',
      cmd = { 'FoldToggle' },
    }
    use {
      local_repo 'buffstory.nvim',
      config = default_config 'buffstory',
      event = 'BufReadPre',
      module = 'buffstory',
    }
    use {
      'rafcamlet/tabline-framework.nvim',
      config = config 'tabline-framework',
      wants = 'lualine.nvim',
      event = 'BufEnter',
    }
    use {
      'nvim-lualine/lualine.nvim',
      -- wants = { 'aerial.nvim', 'overseer.nvim' },
      event = 'BufReadPost',
      config = config 'lualine',
    }
    use {
      'stevearc/dressing.nvim',
      config = default_config 'dressing',
      event = 'bufreadpost',
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
      event = 'bufreadpre',
      config = config 'indent-blankline',
    }
    use {
      'folke/trouble.nvim',
      module = 'trouble',
      module_pattern = 'trouble.*',
      config = config 'trouble',
    }
    use {
      'folke/todo-comments.nvim',
      event = 'BufReadPost',
      config = config 'todo-comments',
      module = 'todo-comments',
      cmd = {
        'TodoTrouble',
        'TodoTelescope',
      },
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
      module = 'neo-tree',
      cmd = { 'Neotree' },
    }
    use {
      local_repo 'neo-tree-zk.nvim',
      module = 'neo-tree.sources.zk',
      module_pattern = 'neo-tree-zk.sources.zk.*',
    }
    use {
      local_repo 'split.nvim',
      module = 'split',
    }

    -- Navigation
    use {
      'haya14busa/vim-asterisk',
      setup = function()
        vim.g['asterisk#keeppos'] = 1
      end,
    }
    use {
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
    }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
      module = 'telescope._extensions.fzf',
    }
    use {
      'nvim-telescope/telescope-project.nvim',
      module = 'telescope._extensions.project',
    }
    use {
      'cljoly/telescope-repo.nvim',
      module = 'telescope._extensions.repo',
    }
    use {
      'nvim-telescope/telescope-file-browser.nvim',
      module = 'telescope._extensions.file_browser',
      disable = true,
    }
    use {
      'nvim-telescope/telescope-dap.nvim',
      module = 'telescope._extensions.dap',
    }
    use {
      'mickael-menu/zk-nvim',
      config = config 'zk',
      module = { 'zk', 'telescope._extensions.dap' },
      module_pattern = 'zk.*',
      cmd = {
        'ZkIndex',
        'ZkNew',
        'ZkNewFromTitleSelection',
        'ZkNewFromContentSelection',
        'ZkCd',
        'ZkNotes',
        'ZkBacklinks',
        'ZkLinks',
        'ZkMatch',
        'ZkTags',
      },
      ft = 'markdown',
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
      'AckslD/nvim-FeMaco.lua',
      cmd = 'FeMaco',
      module = 'femaco',
      config = default_config 'femaco',
    }
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
      'gbprod/substitute.nvim',
      module = 'substitute',
      config = function()
        require('substitute').setup {
          range = {
            prefix = false,
            prompt_current_text = false,
            confirm = false,
            complete_word = false,
            motion1 = false,
            motion2 = false,
            suffix = '',
          },
          exchange = {
            motion = false,
          },
        }
      end,
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
      config = config 'project',
      event = 'BufReadPost',
    }
    use {
      'ThePrimeagen/harpoon',
      module = { 'harpoon', '._extensions.marks' },
      module_pattern = 'harpoon.*',
      config = config 'harpoon',
    }

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
