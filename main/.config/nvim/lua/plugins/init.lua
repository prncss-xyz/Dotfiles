local install_path = vim.fn.stdpath 'data'
  .. '/site/pack/packer/start/packer.nvim'

local function ghost()
  return os.getenv 'GHOST_NVIM' or false
end

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
local dotfiles = os.getenv 'DOTFILES'
require('utils').augroup('PackerCompile', {
  {
    events = { 'BufWritePost' },
    targets = { dotfiles .. '/main/.config/nvim/lua/plugins.lua' },
    command = 'update luafile % | PackerCompile',
  },
})

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
    use {
      'nathom/filetype.nvim',
      config = function()
        require('plugins.filetype').config()
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
      'MunifTanjim/nui.nvim',
      module = 'nui',
    }
    use {
      'kyazdani42/nvim-web-devicons',
      module = 'nvim-web-devicons',
      config = function()
        require('nvim-web-devicons').setup { default = true }
      end,
    }

    -- Treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      module = { 'nvim-treesitter', 'nvim-treesitter.parsers' }, -- HACK: why do I need this?
      module_pattern = 'nvim-treesitter.*',
      config = function()
        require('plugins.treesitter').config()
      end,
      requires = { -- TODO: lazy
        { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' },
        { 'nvim-treesitter/playground', cmd = { 'TSPlaygroundToggle' } },
        {
          'nvim-treesitter/nvim-treesitter-textobjects',
          module = 'nvim-treesitter.textobjects',
        },
        { 'mfussenegger/nvim-ts-hint-textobject', module = 'tsht' },
        -- Use tressitter to autoclose and autorename html tag
        {
          'windwp/nvim-ts-autotag',
          after = 'nvim-treesitter',
          event = 'InsertEnter',
        },
        {
          'JoosepAlviste/nvim-ts-context-commentstring',
          after = 'nvim-treesitter',
        },
        -- You can toggle automatic highlighting for the current treesitter unit.
        -- :lua require"treesitter-unit".toggle_highlighting(higroup?)
        { 'David-Kunz/treesitter-unit', module = 'treesitter-unit' },
      },
    }
    use {
      'lewis6991/spellsitter.nvim',
      after = 'nvim-treesitter',
      config = function()
        require('spellsitter').setup {}
      end,
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
      'SmiteshP/nvim-gps',
      module = 'nvim-gps',
      config = function()
        require('plugins.nvim-gps').config()
      end,
    }
    use {
      'mizlan/iswap.nvim',
      cmd = { 'ISwap', 'ISwapWith' },
      config = function()
        require('iswap').setup {}
      end,
    }
    use { 'mfussenegger/nvim-treehopper', module = 'tsht' }

    -- syntax
    use 'ajouellette/sway-vim-syntax'
    -- use 'fladson/vim-kitty'

    -- luv docs in :help
    use { 'nanotee/luv-vimdocs' }
    -- lua docs in :help
    use { 'milisims/nvim-luaref' }

    -- edit browser's textinput in nvim instance
    use {
      'subnut/nvim-ghost.nvim',
      run = function()
        vim.fn['nvim_ghost#installer#install']()
      end,
      cond = ghost,
    }

    -- DAP
    use {
      'nvim-telescope/telescope-dap.nvim',
    }
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
    use 'jbyuki/one-small-step-for-vimkind'
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
      cmd = { 'GrammarlyStart', 'GrammarlyStop' },
      setup = function()
        require('plugins.lsp').setup()
      end,
      config = function()
        require('plugins.lsp').config()
      end,
    }
    use {
      'simrat39/symbols-outline.nvim',
      after = 'nvim-lspconfig',
      cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen' },
      setup = function()
        require('plugins.symbols-outline').setup()
      end,
    }
    use {
      'ThePrimeagen/refactoring.nvim',
      module = 'refactoring',
      config = function()
        require('refactoring').setup {}
      end,
    }
    use {
      'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
      config = function()
        if vim.g.u_lsp_lines then
          require('lsp_lines').register_lsp_virtual_lines()
        end
      end,
      after = 'nvim-lspconfig',
    }
    use {
      'RRethy/vim-illuminate',
      setup = function()
        require('plugins.illuminate').setup()
      end,
      config = function()
        require('plugins.illuminate').config()
      end,
      module = 'illuminate',
    }
    use {
      'rmagatti/goto-preview',
      config = function()
        require('plugins.goto-preview').config()
      end,
      module = 'goto-preview',
    }
    -- LSP, language-specific
    use {
      'jose-elias-alvarez/null-ls.nvim',
      event = 'BufReadPost',
      config = function()
        require('plugins.null-ls').config()
      end,
    }
    use {
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      module = 'nvim-lsp-ts-utils',
    }
    use { 'folke/lua-dev.nvim', module = 'lua-dev' }
    use { 'b0o/schemastore.nvim', module = 'schemastore' }
    use { 'nanotee/sqls.nvim', module = 'sqls' }

    -- completion
    use { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' }
    use {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      event = { 'CmdlineEnter', 'CmdlineEnter' },
      requires = {
        { 'tzachar/fuzzy.nvim', module = 'fuzzy', disable = true },
        { 'tzachar/cmp-fuzzy-buffer', after = 'nvim-cmp', disable = true },
        { 'tzachar/cmp-fuzzy-path', after = 'nvim-cmp', disable = true },
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        {
          'hrsh7th/cmp-path',
          module = 'cmp-path',
          after = 'nvim-cmp',
        },
        { 'lukas-reineke/cmp-rg', after = 'nvim-cmp' },
        { 'f3fora/cmp-spell', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        {
          'L3MON4D3/LuaSnip',
          module = 'luasnip',
          config = function()
            require('plugins.luasnip').config()
          end,
        },
      },
      config = function()
        require('plugins.cmp').config()
      end,
    }
    use {
      'tzachar/cmp-tabnine',
      run = './install.sh',
      requires = 'hrsh7th/nvim-cmp',
      after = 'nvim-cmp',
      cmd = 'CmpTabnineHub',
      disable = true,
    }
    use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
    -- insert or delete brackets, parentheses, quotes in pair
    use {
      'windwp/nvim-autopairs',
      after = 'nvim-cmp',
      config = function()
        require('nvim-autopairs').setup {
          disable_in_macro = true,
        }
      end,
    }

    -- Tracking
    -- use { 'git-time-metric/gtm-vim-plugin'}
    use {
      'chrisbra/BufTimer',
      setup = function()
        vim.g.buf_report_autosave_dir = os.getenv 'HOME'
          .. '-'
          .. (os.getenv 'hostname' or 'unknown') -- FIXME:
      end,
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
          integrations = {
            diffview = true,
          },
        }
      end,
    }
    -- Resolve git conflicts with ConflictMarker* commands
    use {
      'rhysd/conflict-marker.vim',
      setup = function()
        vim.g.conflict_marker_enable_mappings = 0
      end,
    }

    -- UI
    use {
      'lukas-reineke/indent-blankline.nvim',
      event = 'BufReadPre',
      config = function()
        local highlitght_list = { 'CursorLine', 'Function' }
        require('indent_blankline').setup {
          show_current_context = false,
          char = ' ',
          buftype_exclude = { 'terminal', 'help', 'nofile' },
          filetype_exclude = { 'help', 'packer' },
          char_highlight_list = highlitght_list,
          space_char_highlight_list = highlitght_list,
          space_char_blankline_highlight_list = highlitght_list,
        }
      end,
    }
    use {
      -- TODO: replace by maintained plugin
      'glepnir/galaxyline.nvim',
      event = 'BufEnter',
      config = config 'galaxyline',
    }
    use {
      'stevearc/dressing.nvim',
      config = function()
        require('dressing').setup {}
      end,
    }
    use {
      'folke/trouble.nvim',
      -- module = 'trouble.providers.telescope',
      wants = 'telescope.nvim',
      cmd = {
        'TodoQuickFix',
        'TodoLocList',
        'TodoTrouble',
        'TodoTelescope',
      },
      config = function()
        require('plugins.trouble').config()
      end,
    }
    use {
      'folke/todo-comments.nvim',
      wants = 'trouble.nvim',
      event = 'BufReadPost',
      cmd = { 'TodoTrouble', 'TodoTelescope' },
      config = function()
        require('todo-comments').setup {}
      end,
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
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = default_config 'neo-tree',
      cmd = { 'Neotree' },
      disable = true,
      -- promising but not ready
    }
    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      setup = function()
        require('plugins.nvim-tree').setup()
      end,
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
    }
    use {
      'haya14busa/vim-asterisk',
      setup = g_setup { ['asterisk#keeppos'] = 1 },
    }
    use {
      'edluffy/specs.nvim',
      after = 'neoscroll.nvim',
      config = function()
        require('specs').setup {}
      end,
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
      local_repo 'marks.nvim',
      -- 'chentau/marks.nvim',
      event = 'BufReadPost',
      config = function()
        require('marks').setup {
          default_mappings = false,
          mappings = require('modules.binder').captures.marks,
        }
      end,
    }
    use {
      'phaazon/hop.nvim',
      module = 'hop',
      config = function()
        require('hop').setup {
          jump_on_sole_occurrence = true,
        }
      end,
    }
    use { 'indianboy42/hop-extensions', module = 'hop-extensions' }
    use {
      'abecodes/tabout.nvim',
      event = 'InsertEnter',
      config = function()
        require('tabout').setup {
          tabkey = '',
          backwards_tabkey = '',
        }
      end,
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
      local_repo 'nononotes-nvim',
      config = function()
        require('plugins.nononotes').setup()
      end,
    }
    use {
      'metakirby5/codi.vim',
      cmd = { 'Codi', 'Codi!', 'Codi!!' },
    }
    use {
      'mbbill/undotree',
      setup = function()
        require('plugins.undotree').setup()
      end,
      cmd = { 'UndotreeToggle' },
    }
    use {
      'benfowler/telescope-luasnip.nvim',
      -- local_repo 'telescope-luasnip.nvim',
      module = 'telescope._extensions.luasnip', -- if you wish to lazy-load
    }
    -- bindings
    use {
      'folke/which-key.nvim',
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

    -- Clipboard
    use {
      'kevinhwang91/nvim-hclipboard',
      event = 'InsertEnter',
      config = function()
        require('plugins.hclipboard').config()
      end,
    }
    use {
      'bfredl/nvim-miniyank',
      disable = true,
      setup = function()
        vim.g.miniyank_filename = '/home/prncss/.miniyank.mpack'
      end,
    }
    use {
      'svermeulen/vim-yoink',
      disable = true,
    }

    -- Edition
    use {
      'AndrewRadev/splitjoin.vim',
      setup = function()
        vim.g.splitjoin_join_mapping = ''
        vim.g.splitjoin_split_mapping = ''
      end,
      cmd = { 'SplitjoinJoin', 'SplitjoinSplit' },
    }
    use {
      'JoseConseco/vim-case-change',
      event = 'BufReadPost',
      setup = function()
        vim.g.casechange_nomap = 1
      end,
    }
    use {
      'matze/vim-move',
      event = 'BufReadPost',
      setup = function()
        vim.g.move_map_keys = 0
      end,
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
    }
    local mac_repo = local_repo 'macrobatics'
    use {
      'svermeulen/vim-macrobatics',
      event = 'BufReadPost',
      setup = function()
        vim.g.Mac_NamedMacrosDirectory = mac_repo
      end,
    }
    use {
      'tpope/vim-repeat',
      event = 'BufReadPost',
    }
    use {
      'numToStr/Comment.nvim',
      event = 'BufReadPost',
      wants = 'nvim-ts-context-commentstring',
      requires = { 'JoosepAlviste/nvim-ts-context-commentstring' },
      config = function()
        require('plugins.comment').config()
      end,
    }
    use {
      'bkad/CamelCaseMotion',
      event = 'BufReadPost',
    }
    use {
      'kana/vim-textobj-user',
      event = 'BufReadPost',
      setup = function()
        require('utils').deep_merge(vim, require('bindings').plugins)
      end,
      requires = {
        {
          'Julian/vim-textobj-variable-segment',
          opt = true,
          after = 'vim-textobj-user',
        },
        {
          'kana/vim-textobj-datetime',
          after = 'vim-textobj-user',
          setup = function()
            vim.g.textobj_datetime_no_default_key_mappings = 0
          end,
        },
        {
          'preservim/vim-textobj-sentence',
          after = 'vim-textobj-user',
        },
      },
    }
    use {
      'wellle/targets.vim',
      event = 'BufReadPost',
      setup = function()
        vim.g.targets_nl = 'np'
      end,
    }
    use { local_repo 'flies.nvim' }
    use {
      local_repo 'buffet.nvim',
      config = function()
        require('buffet').setup()
      end,
    }

    -- Session
    use {
      'windwp/nvim-projectconfig',
      disable = true,
      config = function()
        require('nvim-projectconfig').load_project_config {
          project_dir = local_repo 'projects-config/',
        }
        -- require('utils').augroup('NvimProjectConfig', {
        --   {
        --     events = { 'DirChanged' },
        --     targets = { '*' },
        --     cmd = require('nvim-projectconfig').load_project_config,
        --   },
        -- })
      end,
    }
    use {
      'ethanholz/nvim-lastplace',
      event = 'BufReadPre',
      config = function()
        require('nvim-lastplace').setup {
          lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
          lastplace_ignore_filetype = {
            'gitcommit',
            'gitrebase',
            'svn',
            'hgcommit',
          },
          lastplace_open_folds = true,
        }
      end,
    }
    use {
      'ahmedkhalf/project.nvim',
      config = function()
        require('project_nvim').setup {}
      end,
    }

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
      config = {
        require('sniprun').setup {
          live_mode_toggle = 'on',
          selected_interpreters = {
            'Python3_jupyter',
            -- 'JS_TS_deno'
          },
        },
      },
    }

    -- Various
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
