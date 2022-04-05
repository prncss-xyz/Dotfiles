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
require('modules.utils').augroup('PackerCompile', {
  {
    events = { 'BufWritePost' },
    targets = { dotfiles .. '/main/.config/nvim/lua/plugins.lua' },
    command = 'update luafile % | PackerCompile',
  },
})

return require('packer').startup {
  function()
    use 'wbthomason/packer.nvim'
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

    -- Treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      module = { 'nvim-treesitter', 'nvim-treesitter.parsers' }, -- HACK: why do I need this?
      module_pattern = 'nvim-treesitter.*',
      config = function()
        require 'plugins.treesitter'
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
      },
    }
    use {
      'lewis6991/spellsitter.nvim',
      after = 'nvim-treesitter',
      config = function()
        require('spellsitter').setup()
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
    use { 'SmiteshP/nvim-gps', module = 'nvim-gps' }
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
        require('plugins.dap').setup()
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
      'rcarriga/vim-ultest',
      requires = { 'vim-test/vim-test' },
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
      config = function()
        require('plugins.lsp').setup()
      end,
    }
    use {
      'jose-elias-alvarez/null-ls.nvim',
      event = 'BufReadPost',
      config = function()
        require('plugins.null_ls').setup()
      end,
    }
    use { 'folke/lua-dev.nvim', module = 'lua-dev' }
    use { 'b0o/schemastore.nvim', module = 'schemastore' }
    use {
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      module = 'nvim-lsp-ts-utils',
    }
    use {
      'simrat39/symbols-outline.nvim',
      after = 'nvim-lspconfig',
      cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen' },
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
        require('modules.utils').augroup('Outline', {
          {
            events = { 'FileType' },
            targets = { 'Outline' },
            -- command = function()
            --   vim.opt_local.scl = 'no'
            -- end,
            command = 'setlocal scl=no',
          },
        })
      end,
      -- config = function() end,
    }
    use {
      'ThePrimeagen/refactoring.nvim',
      module = 'refactoring',
      config = function()
        require('refactoring').setup {}
      end,
    }
    use {
      'weilbith/nvim-code-action-menu',
      wants = 'telescope.nvim',
      cmd = 'CodeActionMenu',
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
      config = function()
        local augroup = require('modules.utils').augroup
        -- diminishes flashing while typing
        augroup('IlluminateInsert', {
          {
            events = { 'VimEnter', 'InsertEnter' },
            targets = { '*' },
            command = function()
              vim.g.Illuminate_delay = 1000
            end,
          },
        })

        augroup('IlluminateNormal', {
          {
            events = { 'InsertLeave' },
            targets = { '*' },
            command = function()
              vim.g.Illuminate_delay = 0
            end,
          },
        })
      end,
      module = 'illuminate',
    }
    use {
      'rmagatti/goto-preview',
      config = function()
        require 'plugins.goto-preview'
      end,
      module = 'goto-preview',
    }

    -- completion
    use { local_repo 'friendly-snippets' }
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
        { 'f3fora/cmp-spell', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        {
          'L3MON4D3/LuaSnip',
          module = 'luasnip',
          config = function()
            require 'plugins.luasnip'
          end,
        },
      },
      config = function()
        require 'plugins.cmp'
      end,
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
    -- use { 'ThePrimeagen/vim-apm' } -- not working
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
        require('plugins.gitsigns').setup()
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
          filetype_exclude = { 'markdown', 'help', 'packer' },
          char_highlight_list = highlitght_list,
          space_char_highlight_list = highlitght_list,
          space_char_blankline_highlight_list = highlitght_list,
        }
      end,
    }
    use {
      'glepnir/galaxyline.nvim',
      event = 'BufEnter',
      config = function()
        require 'plugins.galaxyline'
      end,
    }
    use {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup {
          mappings = {},
        }
      end,
    }
    use {
      'stevearc/dressing.nvim',
      config = function()
        require('dressing').setup {}
      end,
    }
    -- Navigation
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
        require 'plugins.trouble'
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
      'kevinhwang91/nvim-hlslens',
      config = function()
        require('hlslens').setup {
          calm_down = true,
        }
      end,
    }
    use {
      'haya14busa/vim-asterisk',
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
      cmd = { 'ZenMode' },
      config = function()
        require('plugins.zen-mode').setup()
      end,
    }
    use {
      'folke/twilight.nvim',
      config = function()
        require('twilight').setup {}
      end,
      cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
    }
    use {
      'wellle/visual-split.vim',
      keys = {
        '<Plug>(Visual-Split-VSSplit)',
        '<Plug>(Visual-Split-VSSplitAbove)',
        '<Plug>(Visual-Split-VSSplitBelow)',
      },
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
        require('plugins.xplr').setup()
      end,
      requires = { { 'nvim-lua/plenary.nvim' }, { 'MunifTanjim/nui.nvim' } },
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
      event = 'BufReadPost',
      'andymass/vim-matchup',
      disable = true,
      setup = function()
        vim.g.matchup_matchparen_offscreen = {}
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
        vim.g.undotree_SplitWidth = 30
        vim.g.undotree_TreeVertShape = '│'
      end,
      cmd = { 'UndotreeToggle' },
    }
    use {
      -- 'benfowler/telescope-luasnip.nvim',
      local_repo 'telescope-luasnip.nvim',
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
        require 'plugins.hclipboard'
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
        require 'plugins.dial'
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
        require('plugins.comment').setup()
      end,
    }

    -- TODO: https://github.com/AndrewRadev/splitjoin.vim
    use {
      'bkad/CamelCaseMotion',
      event = 'BufReadPost',
    }
    use {
      'kana/vim-textobj-user',
      event = 'BufReadPost',
      setup = function()
        require('modules.utils').deep_merge(vim, require('bindings').plugins)
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
    }
    use { local_repo 'flies.nvim' }
    use {
      -- 'tommcdo/vim-ninja-feet',
      local_repo 'vim-ninja-feet',
      event = 'BufReadPost',
      setup = function()
        vim.g.ninja_feet_no_mappings = 1
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
