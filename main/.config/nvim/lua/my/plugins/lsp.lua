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
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'stylua',
        'shfmt',
        'shellcheck',
        'prettierd',
        'golangci-lint',
        'golines',
        'revive',
      },
      auto_update = true,
    },
    dependencies = { 'williamboman/mason.nvim' },
    event = 'VimEnter',
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
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = 'BufReadPost',
    config = require('my.config.null-ls').config,
  },
  {
    'folke/neodev.nvim',
    ft = 'lua',
    config = function()
      require('neodev').setup {
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
        on_attach = function(client, bufnr)
          require('my.utils.lsp').on_attach(client, bufnr)
          -- require('inlay-hints').on_attach(client, bufnr)
        end,
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
    ft = 'json',
    config = function()
      require('lspconfig').jsonls.setup {
        settings = {
          json = { schemas = require('schemastore').json.schemas() },
        },
        on_attach = require('my.utils.lsp').on_attach,
        capabilities = require('my.utils.lsp').get_cmp_capabilities(),
        flags = require('my.utils.lsp').flags,
      }
    end,
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
  },
  {
    'ray-x/go.nvim',
    ft = { 'go', 'gomod' },
    name = 'go',
    config = function()
      require('go').setup { lsp_cfg = false }
      local cfg = require('go.lsp').config()
      require('lspconfig').gopls.setup(cfg)
      local go_null = require 'go.null_ls'
      local null_ls = require 'null-ls'
      --[[ null_ls.register(go_null.gotest()) ]]
      -- makes null_ls works forever
      null_ls.register(go_null.gotest_action())
      -- null_ls.register(go_null.golangci_lint())
    end,
    enable = true,
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
    config = require('my.config.zk').config,
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
    'stevearc/aerial.nvim',
    config = require('my.config.aerial').config,
    cmd = {
      'AerialOpen',
      'AerialClose',
      'AerialInfo',
    },
  },
  {
    'ThePrimeagen/refactoring.nvim',
    opts = {},
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
      vim.api.nvim_set_hl(
        0,
        'LspReferenceWrite',
        { bg = diff_add.fg, fg = diagnostic_warn.fg }
      )
      vim.api.nvim_set_hl(
        0,
        'LspReferenceRead',
        { bg = diff_change.fg, fg = diagnostic_warn.fg }
      )
      vim.api.nvim_set_hl(
        0,
        'LspReferenceText',
        { bg = diff_change.fg, fg = diagnostic_warn.fg }
      )
      require('illuminate').configure {
        providers = {
          'lsp',
          'treesitter',
          'regex',
        },
        delay = 0,
      }
    end,
    event = 'CursorHold',
  },
}
