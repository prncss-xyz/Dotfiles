return {
  {
    'williamboman/mason.nvim',
    opts = {},
    cmd = {
      'Mason',
      'MasonUpdate',
      'MasonInstall',
      'MasonUninstall',
      'MasonUninstallAll',
      'MasonLog',
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {
        'bashls',
        'graphql',
        'jsonls',
        'yamlls',
        'gopls',
        'ltex',
        'eslint',
        'golangci_lint_ls',
      },
      automatic_installation = false,
    },
    dependencies = { 'williamboman/mason.nvim' },
  },
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPost',
    config = function()
      for _, lsp in ipairs {
        'bashls',
        --[[ 'cssls', ]]
        --[[ 'html', ]]
        'graphql',
        'eslint',
        --[[ 'julials', ]]
        --[[ 'prismals', ]]
        --[[ 'golangci_lint_ls', -- FIXME: ]]
        -- 'emmet_language_server',
        'gopls',
      } do
        local flags = {}
        if lsp == 'eslint' then
          flags = { 'format' }
        end
        require('lspconfig')[lsp].setup {
          capabilities = require('my.utils.lsp').get_cmp_capabilities(flags),
          flags = require('my.utils.lsp').flags,
        }
      end
    end,
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    cmd = { 'LspInfo' },
    init = function()
      vim.diagnostic.config { virtual_text = false, update_in_insert = true }
    end,
  },
  -- https://mason-registry.dev/registry/list
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'prettierd',
        'stylua',
        'shfmt',
        'golines',
        'fourmolu',
        'shellcheck',
        'yamllint',
      },
      auto_update = true,
    },
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate' },
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim',
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },
  {
    'zeioth/garbage-day.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    opts = {},
    enabled = false,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        go = { 'my_golines' },
        sh = { 'shfmt' },
        lua = { 'stylua' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        vue = { 'prettierd' },
        css = { 'prettierd' },
        scss = { 'prettierd' },
        less = { 'prettierd' },
        html = { 'prettierd' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        yaml = { 'prettierd' },
        graphql = { 'prettierd' },
        handlebars = { 'prettierd' },
        toml = { 'prettierd' },
        haskell = { 'fourmolu' },
        markdown = { 'prettierd' }, -- bug thats kills last lines
      },
      formatters = {
        fourmolu = {
          command = 'fourmolu',
          args = { '--stdin-input-file', '$FILENAME' },
          stdin = true,
        },
        my_golines = {
          command = 'golines',
          stdin = true,
          args = {
            '--max-len=100',
            '--base-formatter=gofumpt',
          },
        },
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    ft = {
      'sh',
      'yaml',
    },
    opts = {
      linters_by_ft = {
        sh = { 'shellcheck' },
        yaml = { 'yamllint' },
      },
    },
    config = function(_, opts)
      local lint = require 'lint'
      lint.linters_by_ft = opts.linters_by_ft or {}
      for k, v in pairs(opts.linters or {}) do
        lint.linters[k] = v
      end
      local uv = vim.uv or vim.loop
      local timer = assert(uv.new_timer())
      local DEBOUNCE_MS = opts.debounce_ms or 500
      local group = vim.api.nvim_create_augroup('Lint', { clear = true })
      vim.api.nvim_create_autocmd(
        { 'BufWritePost', 'TextChanged', 'InsertLeave' },
        {
          group = group,
          callback = function()
            local bufnr = vim.api.nvim_get_current_buf()
            timer:stop()
            timer:start(
              DEBOUNCE_MS,
              0,
              vim.schedule_wrap(function()
                if vim.api.nvim_buf_is_valid(bufnr) then
                  vim.api.nvim_buf_call(bufnr, function()
                    lint.try_lint(nil, { ignore_errors = true })
                  end)
                end
              end)
            )
          end,
        }
      )
      lint.try_lint(nil, { ignore_errors = true })
    end,
  },
  { 'Bilal2453/luvit-meta' },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    enabled = false,
    opts = {
      library = {
        'luvit-meta/library',
      },
      globals = {
        'dump',
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
  },
  {
    'folke/neodev.nvim',
    ft = 'lua',
    enabled = true,
    opts = {
      neodev = {
        library = { plugins = { 'neotest' }, types = true },
      },
      lua_ls = {
        capabilities = require('my.utils.lsp').get_cmp_capabilities(),
        flags = require('my.utils.lsp').flags,
        cmd = { 'lua-language-server' },
        settings = {
          Lua = {
            hint = {
              enabled = true,
            },
            diagnostics = {
              globals = {
                'dump',
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
              enabled = false,
            },
          },
        },
      },
    },
    config = function(_, opts)
      require('neodev').setup(opts.neodev)
      require('lspconfig').lua_ls.setup(opts.lua_ls)
    end,
  },
  {
    'b0o/schemastore.nvim',
    config = function()
      require('lspconfig').jsonls.setup {
        capabilities = require('my.utils.lsp').get_cmp_capabilities(),
        flags = require('my.utils.lsp').flags,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enabled = true },
          },
        },
      }
      require('lspconfig').yamlls.setup {
        capabilities = require('my.utils.lsp').get_cmp_capabilities(),
        flags = require('my.utils.lsp').flags,
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enabled = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      }
    end,
    ft = { 'json', 'yaml' },
  },
  {
    'dmmulroy/ts-error-translator.nvim',
    opts = {},
  },
  {
    'yioneko/nvim-vtsls',
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    config = function()
      require('lspconfig.configs').vtsls = require('vtsls').lspconfig
      require('lspconfig').vtsls.setup {}
    end,
    cmd = { 'VtsExec', 'VtsRename' },
  },
  {
    'pmizio/typescript-tools.nvim',
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    cmd = {
      'TSToolsOrganizeImports',
      'TSToolsSortImports',
      'TSToolsRemoveUnusedImports',
      'TSToolsRemoveUnused',
      'TSToolsAddMissingImports',
      'TSToolsFixAll',
      'TSToolsGoToSourceDefinition',
      'TSToolsRenameFile',
    },
    opts = {},
    enabled = false,
  },
  {
    'ray-x/go.nvim',
    enabled = false,
    -- needed for GoDebug but I'm using 'leoluz/nvim-dap-go' instead
    -- dependencies = { 'ray-x/guihua.lua' },
    ft = { 'go', 'gomod' },
    opts = {
      lsp_cfg = {
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
      },
      lsp_keymaps = false,
      icons = false,
      dap_debug_keymap = false,
      dap_debug_gui = false,
      trouble = true,
      luasnip = true,
    },
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
      'GoTest',
      'GoTestSum',
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
    opts = {
      on_attach = function(client, bufnr)
        require('my.utils.lsp').on_attach(client, bufnr)
        require('sqls').on_attach(client, bufnr)
      end,
    },
    config = function(_, opts)
      require('lspconfig').sqls.setup(opts)
    end,
    enabled = false,
  },
  {
    'zk-org/zk-nvim',
    ft = 'markdown',
    name = 'zk',
    opts = {
      picker = 'telescope',
      lsp = {
        config = {
          cmd = { 'zk', 'lsp' },
          name = 'zk',
        },
      },
      auto_attach = {
        enabled = true,
        filetypes = { 'markdown' },
      },
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
    'danarth/sonarlint.nvim',
    opts = {
      server = {
        cmd = {
          'sonarlint-language-server',
          '-stdio',
          '-analyzers',
          vim.fn.expand '$MASON/share/sonarlint-analyzers/sonargo.jar',
          vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarjs.jar',
        },
        settings = {
          rules = {
            ['typescript:S101'] = {
              level = 'on',
              parameters = { format = '^[A-Z][a-zA-Z0-9]*$' },
            },
            ['typescript:S103'] = {
              level = 'on',
              parameters = { maximumLineLength = 180 },
            },
            ['typescript:S106'] = { level = 'on' },
            ['typescript:S107'] = {
              level = 'on',
              parameters = { maximumFunctionParameters = 7 },
            },
          },
        },
      },
      filetypes = {
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
        'go',
      },
    },
    ft = {
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'go',
    },
    enabled = false,
  },
  {
    'mrcjkb/haskell-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim', -- Optional
    },
    branch = '2.x.x', -- Recommended
    init = function() -- Optional, see Advanced configuration
    end,
    ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
  },
  {
    'barreiroleo/ltex_extra.nvim',
    ft = { 'markdown', 'tex', 'gitcommit', 'text' },
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {
      server_opts = {
        load_langs = { 'en-US', 'fr' },
        capabilities = require('my.utils.lsp').get_cmp_capabilities(),
        flags = {
          debounce_text_changes = 10000,
          allow_incremental_sync = true,
        },
        settings = {
          ltex = {
            enabled = { 'markdown' },
            language = 'auto',
            additionalRules = {
              enablePickyRules = true,
            },
            disabledRules = {
              en = {
                'UPPERCASE_SENTENCE_START',
                'PUNCTUATION_PARAGRAPH_END',
              },
              fr = {
                'APOS_TYP',
                'FRENCH_WHITESPACE',
                'UPPERCASE_SENTENCE_START',
                'PUNCTUATION_PARAGRAPH_END',
              },
            },
          },
        },
      },
    },
  },
  {
    'artemave/workspace-diagnostics.nvim',
  },
}
