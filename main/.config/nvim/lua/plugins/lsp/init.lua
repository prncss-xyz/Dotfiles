local M = {}

-- null_ls uses its own configuration file

function M.setup()
  if vim.g.u_lsp_lines then
    vim.fn.sign_define(
      'DiagnosticSignError',
      { text = '', texthl = 'diagnosticvirtualtextError' }
    )
    vim.fn.sign_define(
      'DiagnosticSignWarn',
      { text = '', texthl = 'diagnosticvirtualtextWarn' }
    )
    vim.fn.sign_define(
      'DiagnosticSignHint',
      { text = '', texthl = 'diagnosticvirtualtextHint' }
    )
    vim.fn.sign_define(
      'DiagnosticSignInfo',
      { text = '', texthl = 'diagnosticvirtualtextInfo' }
    )
  else
    vim.fn.sign_define(
      'DiagnosticSignError',
      { text = ' ', texthl = 'diagnosticvirtualtextError' }
    )
    vim.fn.sign_define(
      'DiagnosticSignWarn',
      { text = ' ', texthl = 'diagnosticvirtualtextWarn' }
    )
    vim.fn.sign_define(
      'DiagnosticSignHint',
      { text = '', texthl = 'diagnosticvirtualtextHint' }
    )
    vim.fn.sign_define(
      'DiagnosticSignInfo',
      { text = ' ', texthl = 'diagnosticvirtualtextInfo' }
    )
  end

  vim.diagnostic.config {
    virtual_text = false,
  }
end

function M.config()
  local function noformat_on_attach(client, _)
    -- TODO: bindings
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    client.config.flags.debounce_text_changes = 150
    require('illuminate').on_attach(client)
  end

  -- will be called before noformat_on_attach
  local function ts_uttils_on_attach(client, _)
    local ts_utils = require 'nvim-lsp-ts-utils'
    ts_utils.setup {
      debug = false,
      disable_commands = false,
      enable_import_on_completion = true, -- touched

      -- import all
      import_all_timeout = 5000, -- ms
      -- lower numbers indicate higher priority
      import_all_priorities = {
        same_file = 1, -- add to existing import statement
        local_files = 2, -- git files or files with relative path markers
        buffer_content = 3, -- loaded buffer content
        buffers = 4, -- loaded buffer names
      },
      import_all_scan_buffers = 100,
      import_all_select_source = false,

      -- update imports on file move
      update_imports_on_move = true,
      require_confirmation_on_move = true,
      watch_dir = nil,

      -- filter diagnostics
      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = {},
    }

    -- required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)
  end

  -- LSP settings
  local lspconfig = require 'lspconfig'
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local flags = {
    debounce_text_changes = 500,
    allow_incremental_sync = true,
  }

  for _, lsp in ipairs {
    'bashls',
    'html',
    'cssls',
    'vimls',
    'yamlls',
    'graphql',
  } do
    lspconfig[lsp].setup {
      on_attach = noformat_on_attach,
      capabilities = capabilities,
      flags = flags,
    }
  end
  lspconfig.jsonls.setup {
    settings = { json = { schemas = require('schemastore').json.schemas() } },
    on_attach = noformat_on_attach,
    capabilities = capabilities,
    flags = flags,
  }
  lspconfig.tsserver.setup {
    on_attach = function(client, bufnr)
      noformat_on_attach(client, bufnr)
      ts_uttils_on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    flags = flags,
  }
  local luadev = require('lua-dev').setup {
    lspconfig = {
      capabilities = capabilities,
      cmd = { 'lua-language-server' },
      on_attach = noformat_on_attach,
      settings = {
        Lua = {
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
            },
          },
          runtime = {
            version = 'LuaJIT',
          },
          telemetry = {
            enable = false,
          },
        },
      },
      flags = flags,
    },
  }
  lspconfig.sumneko_lua.setup(luadev)

  lspconfig.sqls.setup {
    on_attach = function(client, bufnr)
      noformat_on_attach(client, bufnr)
      require('sqls').on_attach(client, bufnr)
    end,
  }

  lspconfig.eslint.setup {
    settings = {
      packageManager = 'pnpm',
    },
  }

  -- use GrammaryStart
  -- lspconfig.grammarly.setup {}
  -- also:
  -- require('grammar-guard').init()
  -- nvim_lsp.grammar_guard.setup {}

  --TODO:
  lspconfig.emmet_ls.setup {
    capabilities = capabilities,
    filetypes = { 'html', 'css', 'typescriptreact', 'javascriptreact' },
  }
  require 'plugins.lsp.utils'
end

return M