local function default_config(name, config)
  return string.format(
    "require('%s').setup(%s)",
    name,
    vim.inspect(config or {})
  )
end

local function config(name)
  return string.format("require('my.config.%s').config()", name)
end

local function setup(name)
  return string.format("require('my.config.%s').setup()", name)
end

return require('packer').startup {
  function()
    use {
      'brymer-meneses/grammar-guard.nvim',
      module = 'grammar-guard',
    }


    -- tasks
    use {
      'mfussenegger/nvim-dap',
      module = 'dap',
      config = function()
        require('my.config.dap').config()
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
    -- eventual replacement for codi, not quite mature though
    use {
      'jbyuki/carrot.nvim',
      cmd = { 'CarrotEval', 'CarrotNewBlock' },
    }

    -- Git
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

    -- UI
    use {
      's1n7ax/nvim-window-picker',
      tag = 'v1.*',
      config = function()
        require('window-picker').setup {
          selection_chars = require('my.config.binder.parameters').selection_chars:upper(),
        }
      end,
      module = 'window-picker',
    }
    use {
      'smjonas/inc-rename.nvim',
      config = default_config 'inc_rename',
      cmd = { 'IncRename' },
      disable = true,
    }
    use {
      -- 'simnalamburt/vim-mundo'
      'mbbill/undotree',
      setup = function()
        require('my.config.undotree').setup()
      end,
      cmd = { 'UndotreeToggle' },
    }
    use {
      'is0n/fm-nvim',
      config = config 'fm-nvim',
      cmd = { 'Xplr' },
    }

    -- Telescope
    use {
      'nvim-telescope/telescope-node-modules.nvim',
      module = 'telescope._extensions.node_modules',
    }
    -- FIXME: might not need
    use {
      'nvim-telescope/telescope-project.nvim',
      module = 'telescope._extensions.project',
    }
    use {
      'nvim-telescope/telescope-dap.nvim',
      module = 'telescope._extensions.dap',
    }

    -- Edition
    use {
      'NMAC427/guess-indent.nvim',
      config = default_config 'guess-indent',
      cmd = 'GuessIndent',
      module = 'guess-indent',
    }
    use {
      'AckslD/nvim-neoclip.lua',
      config = default_config 'neoclip',
      event = 'VimEnter',
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


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
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
