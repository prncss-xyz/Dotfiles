return {
  'nanotee/luv-vimdocs',
  'milisims/nvim-luaref',
  {
    'williamboman/mason.nvim',
    opts = {},
    cmd = {
      'Mason',
      'MasonLog',
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      automatic_installation = true,
    },
    dependencies = { 'williamboman/mason.nvim' },
  },
  {
    'neovim/nvim-lspconfig',
    name = 'lspconfig',
    event = 'BufReadPost',
    config = require('my.config.lsp').config,
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    cmd = { 'LspInfo' },
  },
  {
    'jay-babu/mason-null-ls.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
      require('mason-null-ls').setup {
        ensure_installed = nil,
        automatic_installation = true,
        automatic_setup = false,
      }
    end,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = require('my.config.null-ls').config,
    dependencies = { 'jay-babu/mason-null-ls.nvim' },
  },
  {
    'folke/neodev.nvim',
    ft = 'lua',
    config = function()
      require('neodev').setup {
        library = { plugins = { 'neotest' }, types = true },
        -- override = function(root_dir, library)
        --   if
        --     require('neodev.util').has_file(root_dir, '/home/prncss/Dotfiles/')
        --   then
        --     library.enabled = true
        --     library.plugins = true
        --   end
        -- end,
      }
      require('lspconfig').lua_ls.setup {
        capabilities = require('my.utils.lsp').get_cmp_capabilities(),
        flags = require('my.utils.lsp').flags,
        cmd = { 'lua-language-server' },
        settings = {
          Lua = {
            hint = {
              enable = true,
            },
            diagnostics = {
              globals = {
                -- nvim
                'vim',
                -- packer.nvim
                'use',
                -- xplr
                'xplr',
                'version',
                -- busted
                'it',
                'describe',
                'assert',
                'pending',
                'setup',
                'teardown',
                'lazy_setup',
                'lazy_teardown',
                'strict_setup',
                'strict_teardown',
                'before_each',
                'after_each',
                'finally',
              },
            },
            runtime = {
              version = 'LuaJIT',
            },
            workspace = {
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end,
  },
  {
    'b0o/schemastore.nvim',
  },
  {
    'jose-elias-alvarez/typescript.nvim',
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    config = function()
      require('typescript').setup {
        flags = require('my.utils.lsp').flags,
        disable_commands = false,
        debug = false,
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
        },
        capabilities = require('my.utils.lsp').get_cmp_capabilities(),
        on_attach = function(client, bufnr)
          require('my.utils.lsp').on_attach(client, bufnr)
        end,
      }
      require('null-ls').register(
        require 'typescript.extensions.null-ls.code-actions'
      )
    end,
    enabled = false,
  },
  {
    'yioneko/nvim-vtsls',
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    config = function()
      require('lspconfig').vtsls.setup {}
      require('lspconfig').lua_ls.setup(require('vtsls').lspconfig)
    end,
    cmd = { 'VtsExec', 'VtsRename' },
  },
  {
    'ray-x/go.nvim',
    -- needed for GoDebug but I'm using 'leoluz/nvim-dap-go' instead
    -- dependencies = { 'ray-x/guihua.lua' },
    ft = { 'go', 'gomod' },
    opts = {
      lsp_cfg = true,
      lsp_keymaps = false,
      icons = false,
      dap_debug_keymap = false,
      dap_debug_gui = false,
      trouble = true,
      luasnip = true,
    },
    config = function(_, opts)
      require('go').setup(opts)
      local null_ls = require 'null-ls'
      local gotest_codeaction = require('go.null_ls').gotest_action()
      null_ls.register(gotest_codeaction)
      -- those trigger a forever spin in Noice
      if false then
        local gotest = require('go.null_ls').gotest()
        null_ls.register(gotest)
        local golangci_lint = require('go.null_ls').golangci_lint()
        null_ls.register(golangci_lint)
      end
    end,
    build = ':lua require("go.install").update_all_sync()',
    cmd = {
      -- Note: auto fill struct also supported by gopls lsp-action
      'GoFillStruct',
      'GoFillSwitch',
      'GoIfErr',
      'GoFixPlurals',
      'GoImpl', -- generate method stubs for implementing an interface
      'Gomvp', -- Rename module name
      -- tests code actions
      -- lint
      'GoMake',
      'GoBuild',
      'GoGenerate',
      'GoRun',
      'GoStop',
      'GoGet',
      'GoVet',
      'GoCoverage',
      'GoDoc',
      'GoPkgOutline',
      'GoAddTag',
      'GoRmTag',
      'GoClearTag',
      'GoMockGen',
      'GoCmt',
      'GoModInit',
      'GoModTidy',
      'GoModVendor',
      'GoCodeLenAct',
      'GoToggleInlay',
      'GoJson2Struct',
      'GoGenReturn',
      'GoVulnCheck',
      'Goenum',
      'GoNew',
      'Ginkgo',
    },
  },
  {
    'nanotee/sqls.nvim',
    ft = 'sql',
    config = function()
      require('lspconfig').sqls.setup {
        on_attach = function(client, bufnr)
          require('my.utils.lsp').on_attach(client, bufnr)
          require('sqls').on_attach(client, bufnr)
        end,
      }
    end,
  },
  {
    'mickael-menu/zk-nvim',
    ft = 'markdown',
    name = 'zk',
    opts = {
      layout = {
        default_direction = 'left',
        min_width = require('my.parameters').pane_width,
      },
      backends = {
        'treesitter',
        'lsp',
        'markdown',
      },
      filter_kind = false,
      -- filter_kind = {
      --   'Class',
      --   'Constructor',
      --   'Enum',
      --   'Function',
      --   'Interface',
      --   'Module',
      --   'Method',
      --   'Struct',
      -- },
      -- To see all available values, see :help SymbolKind
    },
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
  },

  {
    'mrcjkb/haskell-tools.nvim',
    opts = {
      tools = {
        hoogle = {
          -- mode = 'browser',
        },
      },
    },
    config = function(_, opts)
      require('haskell-tools').start_or_attach(opts)
      require('telescope').load_extension 'ht'
    end,
    branch = '1.x.x',
    ft = 'haskell',
  },
  {
    'luc-tielen/telescope_hoogle',
    dependencies = {
      'mrcjkb/haskell-tools',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension 'hoogle'
    end,
    enabled = false,
  },
  {
    'stevearc/aerial.nvim',
    opts = {
      layout = {
        default_direction = 'left',
        min_width = require('my.parameters').pane_width,
      },
      backends = {
        'treesitter',
        'lsp',
        'markdown',
      },
      filter_kind = false,
      -- filter_kind = {
      --   'Class',
      --   'Constructor',
      --   'Enum',
      --   'Function',
      --   'Interface',
      --   'Module',
      --   'Method',
      --   'Struct',
      -- },
      -- To see all available values, see :help SymbolKind
    },
    cmd = {
      'AerialOpen',
      'AerialClose',
      'AerialInfo',
      'AerialNext',
      'AerialPrev',
    },
  },
  {
    'RRethy/vim-illuminate',
    config = function()
      -- Are also used by vim-illuminate.
      -- The defaults option (CursorLine) was quite unreadable.
      -- Actual settings cause issue when cursor it at the beginning or end.
      -- `vim.cmd 'highlight! link LspReferenceText String'`
      -- for Neon colorscheme:
      -- vim.cmd 'highlight! LspReferenceText guibg=#4db5bd guifg=#ecee7b'
      local utils = require 'my.utils'
      local diff_add = utils.extract_nvim_hl 'DiffAdd'
      local diff_change = utils.extract_nvim_hl 'DiffChange'
      local diagnostic_warn = utils.extract_nvim_hl 'DiagnosticWarn'
      if false then
        vim.api.nvim_set_hl(
          0,
          'IlluminatedWordText',
          { bg = diff_add.fg, fg = diagnostic_warn.fg }
        )
        vim.api.nvim_set_hl(
          0,
          'IlluminatedWordRead',
          { bg = diff_change.fg, fg = diagnostic_warn.fg }
        )
        vim.api.nvim_set_hl(
          0,
          'IlluminatedWordWrite',
          { bg = diff_change.fg, fg = diagnostic_warn.fg }
        )
      end
      require('illuminate').configure {
        providers = {
          'lsp',
          'treesitter',
          'regex',
        },
        delay = 0,
      }
    end,
    event = 'VeryLazy',
  },
  {
    'ahmedkhalf/project.nvim',
    event = 'VimEnter',
    name = 'project_nvim',
    opts = {},
    enabled = false,
  },
}
