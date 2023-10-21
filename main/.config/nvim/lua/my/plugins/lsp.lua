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
      automatic_installation = true,
    },
    dependencies = { 'williamboman/mason.nvim' },
  },
  {
    'neovim/nvim-lspconfig',
    name = 'lspconfig',
    event = 'BufReadPost',
    config = function()
      for _, lsp in ipairs {
        'bashls',
        'cssls',
        'html',
        'graphql',
        'eslint',
        'julials',
        'prismals',
        'golangci_lint_ls',
        -- 'emmet_language_server',
      } do
        require('lspconfig')[lsp].setup {
          capabilities = require('my.utils.lsp').get_cmp_capabilities(),
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
        mdx = { 'prettierd' },
        graphql = { 'prettierd' },
        handlebars = { 'prettierd' },
        toml = { 'prettierd' },
        haskell = { 'fourmolu' },
        -- markdown = { 'prettierd' }, -- bug thats kills last lines
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
  'nanotee/luv-vimdocs',
  'milisims/nvim-luaref',
  {
    'folke/neodev.nvim',
    ft = 'lua',
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
        capabilities = require('my.utils.lsp').get_cmp_capabilities_no_fold(),
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
    'yioneko/nvim-vtsls',
    ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    opts = {},
    config = function(_, opts)
      require('lspconfig.configs').vtsls = require('vtsls').lspconfig -- set default server config, optional but recommended
      require('lspconfig').vtsls.setup(opts)
    end,
    cmd = { 'VtsExec', 'VtsRename' },
    enabled = false,
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
      'TSToolsRenameFile'
    },
    opts = {},
  },
  {
    'ray-x/go.nvim',
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
  },
  {
    'mickael-menu/zk-nvim',
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
    opts = {
      under_cursor = false,
      filetypes_denylist = { 'NeogitStatus' },
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
    event = 'VeryLazy',
  },
  {
    'ahmedkhalf/project.nvim',
    event = 'VimEnter',
    name = 'project_nvim',
    opts = {
      detection_method = { 'lsp', 'pattern' },
    },
    enabled = false,
  },
  {
    'barreiroleo/ltex_extra.nvim',
    ft = { 'markdown', 'tex' },
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('ltex_extra').setup {
        server_opts = {
          load_langs = { 'en-US', 'fr' },
          capabilities = require('my.utils.lsp').get_cmp_capabilities(),
          flags = {
            debounce_text_changes = 10000,
            allow_incremental_sync = true,
          },
          -- on_attach = function(client, bufnr) end,
          settings = {
            ltex = {
              enabled = { 'markdown' },
              language = 'auto',
              additionalRules = {
                enablePickyRules = true,
                motherTongue = 'fr',
              },
              disabledRules = {
                fr = { 'APOS_TYP', 'FRENCH_WHITESPACE' },
              },
            },
          },
        },
      }
    end,
  },
  {
    'vigoux/ltex-ls.nvim',
    -- also requires java runtime to be installed
    dependencies = { 'neovim/nvim-lspconfig' },
    ft = { 'markdown', 'gitcommit', 'text' },
    opts = {
      filetypes = { 'markdown', 'gitcommit', 'text' },
      settings = {
        ltex = {
          enabled = { 'markdown' },
          language = 'auto',
          additionalRules = {
            enablePickyRules = true,
            motherTongue = 'fr',
          },
          disabledRules = {
            fr = { 'APOS_TYP', 'FRENCH_WHITESPACE' },
          },
          dictionary = (function()
            -- For dictionary, search for files in the runtime to have
            -- and include them as externals the format for them is
            -- dict/{LANG}.txt
            --
            -- Also add dict/default.txt to all of them
            local files = {}
            for _, file in ipairs(vim.api.nvim_get_runtime_file('dict/*', true)) do
              local lang = vim.fn.fnamemodify(file, ':t:r')
              local fullpath = vim.fs.normalize(file)
              files[lang] = { ':' .. fullpath }
            end

            if files.default then
              for lang, _ in pairs(files) do
                if lang ~= 'default' then
                  vim.list_extend(files[lang], files.default)
                end
              end
              files.default = nil
            end
            return files
          end)(),
        },
      },
    },
    cmd = {
      'LtexCheckDocument',
      'LtexClearCache',
      'LtexDisableHere',
      'LtexServerStatus',
    },
    enabled = false,
  },
}
