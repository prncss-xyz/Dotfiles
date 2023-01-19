local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath 'data'
    .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system {
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    }
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local function local_repo(name)
  return os.getenv 'PROJECTS' .. '/github.com/prncss-xyz/' .. name
end

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
      cmd = {
        'PlenaryBustedFile',
        'PlenaryBustedDirectory',
      },
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
    use {
      local_repo 'flies2.nvim',
      config = config 'flies2',
      module = 'flies2',
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
      'simrat39/inlay-hints.nvim',
      module = 'inlay-hints',
      config = default_config 'inlay-hints',
      disable = true,
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
      config = default_config 'refactoring',
      module = { 'telescope._extensions.refactoring', 'refactoring' },
    }
    use {
      'RRethy/vim-illuminate',
      setup = setup 'illuminate',
      config = config 'illuminate',
      event = 'Cursorhold',
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
    use { 'folke/neodev.nvim', module = 'neodev' }
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
    use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
    use { 'dmitmel/cmp-cmdline-history', after = 'nvim-cmp' }
    use { 'davidsierradz/cmp-conventionalcommits', after = 'nvim-cmp' }
    -- insert or delete brackets, parentheses, quotes in pair
    use {
      'windwp/nvim-autopairs',
      config = config 'nvim-autopairs',
      event = 'InsertEnter',
      disable = false,
    }
    use {
      'L3MON4D3/LuaSnip',
      module = 'luasnip',
      module_pattern = 'luasnip.*',
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
    use {
      'jbyuki/one-small-step-for-vimkind',
      module = 'osv',
    }
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
      tag = 'v1.*',
      disable = false,
    }
    use {
      'nvim-neotest/neotest-plenary',
      module = 'neotest-plenary',
    }
    use {
      'marilari89/neotest-vitest',
      module = 'neotest-vitest',
    }
    use {
      'haydenmeade/neotest-jest',
      module = 'neotest-jest',
      disable = true,
    }
    use {
      'nvim-neotest/neotest',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
      },
      module = 'neotest',
      config = config 'neotest',
    }
    use {
      'andythigpen/nvim-coverage',
      module = 'coverage',
      after = 'neotest',
      cmd = {
        'Coverage',
        'CoverageLoad',
        'CoverageShow',
        'CoverageHide',
        'CoverageToggle',
        'CoverageClear',
        'CoverageSummary',
      },
      config = default_config 'coverage',
    }
    use {
      'stevearc/overseer.nvim',
      config = config 'overseer',
      -- config = function ()
      --   require 'overseer'.setup()
      -- end,
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
      run = 'bash install.sh',
      module = 'sniprun',
      -- module_pattern = 'sniprun.*',
      config = function()
        require('sniprun').setup {
          selected_interpreters = {
            'Python3_jupyter',
          },
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
    use { 'rafamadriz/neon', module = 'neon' }
    use { 'ishan9299/nvim-solarized-lua', module = 'solarized' }
    use { 'sainnhe/gruvbox-material', event = 'ColorSchemePre' }
    use { 'sainnhe/everforest', event = 'ColorSchemePre' }
    use { 'rose-pine/neovim', as = 'rose-pine', module = 'rose-pine' }
    use { 'rockerBOO/boo-colorscheme-nvim', disable = true }
    use {
      'marko-cerovac/material.nvim',
      module = 'material',
      config = default_config('material', {
        lualine_style = 'stealth',
        plugins = {
          'dap',
          'gitsigns',
          'hop',
          'indent-blankline',
          'neogit',
          'nvim-cmp',
          'nvim-web-devicons',
          'telescope',
          'trouble',
        },
      }),
    }
    use {
      local_repo 'klint.nvim',
      config = config 'klint',
      rocks = 'lustache',
      module = 'klint',
      cmd = 'KlintExport',
    }

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
    use { 'mvllow/modes.nvim', config = default_config 'modes', disable = true }
    use {
      'nvim-zh/colorful-winsep.nvim',
      config = function()
        require('colorful-winsep').setup()
      end,
      event = 'BufReadPost',
      disable = true,
    }
    use {
      'lukas-reineke/indent-blankline.nvim',
      event = 'bufreadpre',
      config = config 'indent-blankline',
    }
    use {
      'lukas-reineke/headlines.nvim',
      event = 'bufreadpre',
      config = default_config 'headlines',
    }
    use {
      'folke/twilight.nvim',
      config = default_config 'twilight',
      module = 'twilight',
      cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
    }
    use {
      'levouh/tint.nvim',
      config = default_config 'tint',
      event = 'ColorSchemePre',
      disable = true,
    }

    -- UI
    use {
      'kevinhwang91/nvim-ufo',
      requires = 'kevinhwang91/promise-async',
      config = config 'nvim-ufo',
      event = 'BufReadPost',
    }
    use {
      'masukomi/vim-markdown-folding',
      disable = true,
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
      config = config 'dressing',
      event = 'BufReadPost',
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
      'smjonas/inc-rename.nvim',
      config = default_config 'inc_rename',
      cmd = { 'IncRename' },
      disable = true,
    }
    use {
      'rcarriga/nvim-notify',
      config = config 'nvim-notify',
      event = 'VimEnter',
      disable = true,
    }
    use {
      'folke/noice.nvim',
      -- after = 'nvim-notify',
      event = 'VimEnter',
      config = function()
        require('noice').setup()
      end,
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
      'is0n/fm-nvim',
      config = config 'fm-nvim',
      cmd = { 'Xplr' },
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
          refresh_interval = 0,
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
      disable = true,
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
      'crispgm/telescope-heading.nvim',
      module = 'telescope._extensions.heading',
    }
    -- FIXME: might not need
    use {
      'nvim-telescope/telescope-project.nvim',
      module = 'telescope._extensions.project',
    }
    use {
      -- 'cljoly/telescope-repo.nvim',
      local_repo 'telescope-repo.nvim',
      module = 'telescope._extensions.repo',
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
      -- no need for lazy loading
      'gpanders/editorconfig.nvim',
    }
    use {
      'NMAC427/guess-indent.nvim',
      config = default_config 'guess-indent',
      cmd = 'GuessIndent',
      module = 'guess-indent',
    }
    use {
      'nvim-pack/nvim-spectre',
      config = config 'nvim-spectre',
      module = 'spectre',
      module_pattern = 'spectre.action',
    }
    use {
      local_repo 'templum.nvim',
      config = config 'templum',
      event = 'VimEnter',
    }
    use { 'linty-org/readline.nvim', module = 'readline' }
    use {
      'AckslD/nvim-FeMaco.lua',
      cmd = 'FeMaco',
      module = 'femaco',
      config = default_config 'femaco',
    }
    use {
      'AckslD/nvim-neoclip.lua',
      config = default_config 'neoclip',
      event = 'VimEnter',
    }
    use {
      'Wansmer/treesj',
      config = default_config 'treesj',
      cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
    }
    use {
      'monaqa/dial.nvim',
      event = 'BufReadPost',
      config = function()
        require('plugins.dial').config()
      end,
      disable = true,
    }
    use {
      local_repo 'longnose.nvim',
      config = config 'longnose',
      module = 'longnose',
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
      disable = true,
    }
    use {
      'notjedi/nvim-rooter.lua',
      config = default_config 'nvim-rooter',
      event = 'BufReadPost',
    }
    use {
      'ThePrimeagen/harpoon',
      module = { 'harpoon', '._extensions.marks' },
      module_pattern = 'harpoon.*',
      config = config 'harpoon',
    }
    -- Various
    use { 'dstein64/vim-startuptime' }
    use {
      'famiu/bufdelete.nvim',
      module = 'bufdelete',
    }
    use {
      -- 'chrisgrieser/nvim-genghis',
      local_repo 'khutulun.nvim',
      module = 'khutulun',
      config = config 'khutulun',
    }
    use { 'lewis6991/impatient.nvim' }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
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
